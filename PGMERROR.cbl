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

      * FECHA Y HORA DEL ERROR *
       01 WS-FECHA                          VALUE SPACES.
          05 WS-FECHA-EDITADA  PIC X(10)    VALUE SPACES.
          05 FILLER            PIC X(01)    VALUE SPACES.
          05 WS-HORA-EDITADA   PIC X(08)    VALUE SPACES.

       01 WS-SQLCODE-DISPLAY   PIC -(9)9    VALUE ZEROS.   

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
           INITIALIZE WS-FECHA
           MOVE FUNCTION FORMATTED-CURRENT-DATE("%d-%m-%Y")
              TO WS-FECHA-EDITADA
           MOVE FUNCTION FORMATTED-CURRENT-DATE("%H:%M:%S")
              TO WS-HORA-EDITADA
           .
       1000-F-INICIO.  EXIT.
           
       2000-I-PROCESO.
       
           IF WS-ERR-SQLCODE NOT = ZEROS
              MOVE WS-ERR-SQLCODE TO WS-SQLCODE-DISPLAY
           END-IF
           .
       2000-F-PROCESO.  EXIT.

       3000-I-FINAL.

           DISPLAY WS-SEPARADOR
           DISPLAY '>>> INFORME DE ERROR <<<'
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'PROGRAMA     : ' WS-ERR-PROGRAMA
           DISPLAY 'ENTORNO      : ' WS-ERR-ENTORNO
           DISPLAY WS-FECHA
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'TIPO ERROR   : ' WS-TIPO-ERROR
           DISPLAY WS-SEPARADOR-MIN
           
           EVALUATE TRUE 
              WHEN WS-ERR-FILE-STATUS NOT = '00'
                 DISPLAY 'FILE STATUS  : ' WS-ERR-FILE-STATUS
              WHEN  WS-ERR-SQLCODE NOT = 0    
                 DISPLAY 'SQLCODE      : ' WS-SQLCODE-DISPLAY
              WHEN ERR-ES-CICS     
                 DISPLAY 'RESP CICS    : ' WS-ERR-RESP-CICS
                 DISPLAY 'RESP2 CICS   : ' WS-ERR-RESP2-CICS
           END-EVALUATE 
           DISPLAY WS-SEPARADOR
           .
        3000-F-FINAL.  EXIT.

