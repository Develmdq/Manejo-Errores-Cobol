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

      *---------------------------------------------------------------*
      * FECHA Y HORA DEL ERROR                                        *
      *---------------------------------------------------------------*
       01 WS-FECHA.
          05 WS-FECHA-EDITADA  PIC X(10).
          05 FILLER            PIC X(01).
          05 WS-HORA-EDITADA   PIC X(08).

      *---------------------------------------------------------------*
      * DESCRIPCION DEL SQLCODE                                       *
      *---------------------------------------------------------------*
       01 WS-SQL-DESC          PIC X(30) VALUE SPACES.

      *---------------------------------------------------------------*
      * DESCRIPCION DEL FILE STATUS                                   *
      *---------------------------------------------------------------*
       01 WS-FS-DESC           PIC X(30) VALUE SPACES.

       77 FILLER               PIC X(26) VALUE '* FINAL  WS *'.

      *---------------------------------------------------------------*
       LINKAGE SECTION.
      *---------------------------------------------------------------*
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



       2100-DESCRIBIR-SQLCODE.

           EVALUATE TRUE
           WHEN ERR-SQL-OK
                MOVE 'SIN ERROR SQL' TO WS-SQL-DESC
           WHEN ERR-SQL-NOT-FOUND
                MOVE 'NOT FOUND / FIN CURSOR' TO WS-SQL-DESC
           WHEN ERR-SQL-NULL
                MOVE 'NULL EN VARIABLE HOST' TO WS-SQL-DESC
           WHEN ERR-SQL-NO-CURSOR
                MOVE 'CURSOR NO ABIERTO' TO WS-SQL-DESC
           WHEN ERR-SQL-YA-ABIERTO
                MOVE 'CURSOR YA ESTABA ABIER' TO WS-SQL-DESC
           WHEN ERR-SQL-SIN-PERMISO
                MOVE 'SIN PERMISO DB2' TO WS-SQL-DESC
           WHEN ERR-SQL-CLAVE-DUP
                MOVE 'CLAVE DUPLICADA' TO WS-SQL-DESC
           WHEN ERR-SQL-MULTI-ROW
                MOVE 'SELECT INTO MULTI FILA' TO WS-SQL-DESC
           WHEN ERR-SQL-DEADLOCK
                MOVE 'DEADLOCK - ROLLBACK' TO WS-SQL-DESC
           WHEN ERR-SQL-TIMEOUT
                MOVE 'TIMEOUT - DEADLOCK' TO WS-SQL-DESC
           WHEN OTHER
                MOVE 'REVISAR MANUAL DB2' TO WS-SQL-DESC
           END-EVALUATE
           EXIT PARAGRAPH.

       2200-DESCRIBIR-FILE-STATUS.

           EVALUATE TRUE
           WHEN ERR-FS-OK
                MOVE 'SIN ERROR DE ARCHIVO' TO WS-FS-DESC
           WHEN ERR-FS-AT-END
                MOVE 'FIN DE ARCHIVO' TO WS-FS-DESC
           WHEN ERR-FS-CLAVE-DUP
                MOVE 'CLAVE DUPLICADA VSAM' TO WS-FS-DESC
           WHEN ERR-FS-NO-FOUND
                MOVE 'REGISTRO NO ENCONTRADO' TO WS-FS-DESC
           WHEN ERR-FS-NO-FILE
                MOVE 'ARCHIVO NO ENCONTRADO' TO WS-FS-DESC
           WHEN ERR-FS-NO-PERMIT
                MOVE 'OPERACION NO PERMITIDA' TO WS-FS-DESC
           WHEN OTHER
                MOVE 'REVISAR MANUAL COBOL' TO WS-FS-DESC
           END-EVALUATE
           EXIT PARAGRAPH.

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