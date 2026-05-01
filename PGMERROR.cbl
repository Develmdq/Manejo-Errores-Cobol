      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMERROR.

      *****************************************************************
      *       SUBPROGRAMA CENTRALIZADO DE MANEJO DE ERRORES           *
      *****************************************************************
      * AUTOR : MARCET EDUARDO                      FECHA: 2026       *
      *****************************************************************
      * FUNCION:                                                      *
      *   RECIBE LA ESTRUCTURA DE ERROR DEL PROGRAMA LLAMADOR,        *
      *   MUESTRA UN BLOQUE INFORMATIVO EN EL SPOOL Y CANCELA         *
      *   LA EJECUCION DE FORMA CONTROLADA.                           *
      *   SOPORTA ENTORNOS BATCH Y CICS.                              *
      *****************************************************************
      * USO DESDE EL PROGRAMA LLAMADOR:                               *
      *                                                               *
      *   COPY CPERROR.                                               *
      *                                                               *
      *   MOVE 'MIPGM001'    TO WS-ERR-PROGRAMA                       *
      *   MOVE 'FETCH CURSOR CLIENTES' TO WS-ERR-PUNTO                *
      *   MOVE 'BATCH'       TO WS-ERR-ENTORNO                        *
      *   CALL 'PGMERROR'    USING WS-ERROR                           *
      *                                                               *
      *****************************************************************

      *****************************************************************
       ENVIRONMENT DIVISION.
      *****************************************************************
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
                 DECIMAL-POINT IS COMMA.

      *****************************************************************
       DATA DIVISION.
      *****************************************************************
       WORKING-STORAGE SECTION.
       77 FILLER               PIC X(26) VALUE '* INICIO WS *'.

       01 WS-SEPARADOR         PIC X(60) VALUE ALL '='.
       01 WS-SEPARADOR-MIN     PIC X(60) VALUE ALL '-'.

      * FECHA Y HORA DEL ERROR *
       01 WS-FECHA.
          05 WS-FECHA-EDITADA  PIC X(10).
          05 FILLER            PIC X(01).
          05 WS-HORA-EDITADA   PIC X(08).

       77 FILLER               PIC X(26) VALUE '* FINAL  WS *'.

       LINKAGE SECTION.

           COPY CPERROR.

      *****************************************************************
       PROCEDURE DIVISION USING WS-ERROR.
      *****************************************************************

       PRINCIPAL.

           PERFORM 1000-I-INICIO THRU 1000-F-INICIO
           PERFORM 2000-I-PROCESO THRU 2000-F-PROCESO
           PERFORM 3000-MOSTRAR-ERROR
           PERFORM 4000-CANCELAR
           .
       FIN-PRINCIPAL. 
           GOBACK.

      *****************************************************************
      *              CAPTURAR FECHA Y HORA DEL ERROR                  *
      *****************************************************************
       1000-I-INICIO.
       
           INITIALIZE WS-FECHA
           MOVE FUNCTION FORMATTED-CURRENT-DATE("%d-%m-%Y")
              TO WS-FECHA-EDITADA
           MOVE FUNCTION FORMATTED-CURRENT-DATE("%H:%M:%S")
              TO WS-HORA-EDITADA
           .
       1000-F-INICIO. 
           EXIT.

      *****************************************************************
      *         RESOLVER DESCRIPCION DE CODIGOS DE ERROR              *
      *****************************************************************
       2000-I-PROCESO.

           PERFORM 2100-DESCRIBIR-SQLCODE
           PERFORM 2200-DESCRIBIR-FILE-STATUS
           .
       2000-F-PROCESO. 
           EXIT.


      *****************************************************************
      *              MOSTRAR BLOQUE DE ERROR EN SPOOL                 *
      *****************************************************************
       3000-MOSTRAR-ERROR.

           DISPLAY WS-SEPARADOR
           DISPLAY '>>> ERROR FATAL <<<'
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'PROGRAMA     : ' WS-ERR-PROGRAMA
           DISPLAY 'ENTORNO      : ' WS-ERR-ENTORNO
           DISPLAY WS-FECHA
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'PUNTO        : ' WS-ERR-PUNTO
           DISPLAY 'ACCION       : ' WS-ERR-ACCION
           DISPLAY WS-SEPARADOR-MIN
           DISPLAY 'FILE STATUS  : '
                   WS-ERR-FILE-STATUS
                   ' - '
                   WS-FS-DESC
           DISPLAY 'SQLCODE      : '
                   WS-ERR-SQLCODE
                   ' - '
                   WS-SQL-DESC
           DISPLAY 'RESP CICS    : ' WS-ERR-RESP-CICS
           DISPLAY 'RESP2 CICS   : ' WS-ERR-RESP2-CICS
           DISPLAY WS-SEPARADOR
           EXIT PARAGRAPH.

      *****************************************************************
      *              CANCELAR SEGUN ENTORNO                           *
      *****************************************************************
       4000-CANCELAR.

           EVALUATE TRUE
           WHEN ERR-ES-BATCH
                PERFORM 4100-CANCELAR-BATCH
           WHEN ERR-ES-CICS
                PERFORM 4200-CANCELAR-CICS
           WHEN OTHER
                PERFORM 4100-CANCELAR-BATCH
           END-EVALUATE
           EXIT PARAGRAPH.

       4100-CANCELAR-BATCH.

           MOVE 9999 TO RETURN-CODE
           EXIT PARAGRAPH.

       4200-CANCELAR-CICS.

           EXEC CICS ABEND
                ABCODE(WS-ERR-ABCODE)
                END-EXEC
           EXIT PARAGRAPH.