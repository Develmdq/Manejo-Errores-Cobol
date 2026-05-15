      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMERROR.

      ******************************************************************
      *       SUBPROGRAMA CENTRALIZADO DE MANEJO DE ERRORES            *
      ******************************************************************
      * AUTOR : MARCET EDUARDO                      FECHA: 2026        *
      ******************************************************************
      * FUNCION:                                                       *
      *   RECIBE LA ESTRUCTURA DE ERROR DEL PROGRAMA LLAMADOR,         *
      *   MUESTRA UN BLOQUE INFORMATIVO EN EL SPOOL                    *
      *   SOPORTA ENTORNOS BATCH Y CICS.                               *
      ******************************************************************
      * USO DESDE EL PROGRAMA LLAMADOR:                                *
      *                                                                *
      *   1. INCLUIR LA COPY EN WORKING-STORAGE:                       *
      *      COPY CPERROR.                                             *
      *                                                                *
      *   2. ANTES DE INVOCAR LA RUTINA, CARGAR LOS CAMPOS             *
      *      RELEVANTES DE WS-ERROR SEGUN EL CONTEXTO DEL ERROR:       *
      *      MOVE 'MIPGM001' TO WS-ERR-PROGRAMA                        *
      *      SET  ERR-ES-BATCH TO TRUE                                 *
      *      MOVE SQLCODE     TO WS-ERR-SQLCODE                        *
      *      (u otros campos segun corresponda)                        *
      *                                                                *
      *   3. INVOCAR LA RUTINA:                                        *
      *      CALL 'PGMERROR' USING WS-ERROR                            *
      *                                                                *
      ******************************************************************

      ******************************************************************
       ENVIRONMENT DIVISION.
      ******************************************************************
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
                 DECIMAL-POINT IS COMMA.

      ******************************************************************
       DATA DIVISION.
      ******************************************************************
       WORKING-STORAGE SECTION.
       77 FILLER               PIC X(26)    VALUE '* INICIO WS *'.

       01 WS-SEPARADOR         PIC X(60)    VALUE ALL '='.
       01 WS-SEPARADOR-MIN     PIC X(60)    VALUE ALL '-'.
       01 WS-ENCABEZADO        PIC X(60)    VALUE SPACES.

      * FECHA Y HORA DEL ERROR *
       01 WS-FECHA-HORA-ERR.
             05 WS-AAAA        PIC X(04).
             05 WS-MM          PIC X(02).
             05 WS-DD          PIC X(02).
             05 WS-HH          PIC X(02).
             05 WS-MIN         PIC X(02).
             05 WS-SS          PIC X(02).

       77 FILLER               PIC X(26)    VALUE '* FINAL  WS *'.

       LINKAGE SECTION.

           COPY CPERROR.

      ******************************************************************
       PROCEDURE DIVISION USING WS-ERROR.
      ******************************************************************
       MAIN-PROGRAM.
           PERFORM 1000-I-INICIO    THRU 1000-F-INICIO
           PERFORM 2000-I-PROCESO   THRU 2000-F-PROCESO
           PERFORM 3000-I-FINAL     THRU 3000-F-FINAL
           .
       F-MAIN-PROGRAM. GOBACK.

      ******************************************************************
      *              CAPTURAR FECHA Y HORA DEL ERROR                   *
      ******************************************************************
       1000-I-INICIO.
           MOVE FUNCTION CURRENT-DATE(1:14)  TO WS-FECHA-HORA-ERR
           .
       1000-F-INICIO.  EXIT.

       2000-I-PROCESO.

           MOVE SPACES TO WS-ENCABEZADO
           STRING '>>> INFORME DE ERROR      ' DELIMITED BY SIZE
                  WS-DD                        DELIMITED BY SIZE
                  '/'                          DELIMITED BY SIZE
                  WS-MM                        DELIMITED BY SIZE
                  '/'                          DELIMITED BY SIZE
                  WS-AAAA                      DELIMITED BY SIZE
                  ' - '                        DELIMITED BY SIZE
                  WS-HH                        DELIMITED BY SIZE
                  ':'                          DELIMITED BY SIZE
                  WS-MIN                       DELIMITED BY SIZE
                  '     <<< '                  DELIMITED BY SIZE
             INTO WS-ENCABEZADO
           END-STRING
           .
       2000-F-PROCESO.  EXIT.

       3000-I-FINAL.

           DISPLAY WS-ENCABEZADO
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'PROGRAMA     : ' WS-ERR-PROGRAMA
           DISPLAY 'ENTORNO      : ' WS-ERR-ENTORNO
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'TIPO ERROR   : ' WS-TIPO-ERROR
           DISPLAY WS-SEPARADOR-MIN

           EVALUATE TRUE
              WHEN WS-ERR-FS NOT = '00'
                 DISPLAY 'FILE STATUS  : ' WS-ERR-FS
              WHEN  WS-ERR-SQLCODE NOT = 0
                 DISPLAY 'SQLCODE      : ' WS-ERR-SQLCODE
              WHEN ERR-ES-CICS
                 DISPLAY 'RESP CICS    : ' WS-ERR-RESP-CICS
                 DISPLAY 'RESP2 CICS   : ' WS-ERR-RESP2-CICS
           END-EVALUATE
           DISPLAY WS-SEPARADOR
           .
        3000-F-FINAL.  EXIT.

