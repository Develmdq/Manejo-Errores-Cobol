      *****************************************************************
      * COPYBOOK: CPERROR                                            *
      *****************************************************************
      * ESTRUCTURA COMPARTIDA PARA MANEJO CENTRALIZADO DE ERRORES    *
      * USO: INCLUIR EN WS DEL PGM LLAMADOR Y EN LINKAGE DE PGMERROR *
      *****************************************************************
      * AUTOR: MARCET EDUARDO                      FECHA: 2026       *
      *****************************************************************

       01 WS-ERROR.

      *---------------------------------------------------------------*
      * IDENTIFICACION                                                *
      *---------------------------------------------------------------*
           05 WS-ERR-PROGRAMA     PIC X(08) VALUE SPACES.
              88 ERR-SIN-PROGRAMA           VALUE SPACES.

           05 WS-ERR-PUNTO        PIC X(30) VALUE SPACES.
              88 ERR-SIN-PUNTO              VALUE SPACES.

           05 WS-ERR-ACCION       PIC X(20) VALUE SPACES.
              88 ERR-SIN-ACCION             VALUE SPACES.

      *---------------------------------------------------------------*
      * ENTORNO DE EJECUCION                                          *
      *---------------------------------------------------------------*
           05 WS-ERR-ENTORNO      PIC X(05) VALUE SPACES.
              88 ERR-ES-BATCH               VALUE 'BATCH'.
              88 ERR-ES-CICS                VALUE 'CICS '.

      *---------------------------------------------------------------*
      * CODIGOS DE ERROR POR AREA                                     *
      *---------------------------------------------------------------*
           05 WS-ERR-FILE-STATUS  PIC X(02) VALUE SPACES.
              88 ERR-FS-OK                  VALUE '00'.
              88 ERR-FS-AT-END              VALUE '10'.
              88 ERR-FS-CLAVE-DUP           VALUE '22'.
              88 ERR-FS-NO-FOUND            VALUE '23'.
              88 ERR-FS-NO-FILE             VALUE '35'.
              88 ERR-FS-NO-PERMIT           VALUE '37'.

           05 WS-ERR-SQLCODE      PIC S9(09) COMP VALUE ZEROS.
              88 ERR-SQL-OK                 VALUE 0.
              88 ERR-SQL-NOT-FOUND          VALUE 100.
              88 ERR-SQL-NULL               VALUE -305.
              88 ERR-SQL-NO-CURSOR          VALUE -501.
              88 ERR-SQL-YA-ABIERTO         VALUE -502.
              88 ERR-SQL-SIN-PERMISO        VALUE -551.
              88 ERR-SQL-CLAVE-DUP          VALUE -803.
              88 ERR-SQL-MULTI-ROW          VALUE -811.
              88 ERR-SQL-DEADLOCK           VALUE -911.
              88 ERR-SQL-TIMEOUT            VALUE -913.

           05 WS-ERR-RESP-CICS    PIC S9(09) COMP VALUE ZEROS.
              88 ERR-CICS-OK                VALUE 0.

           05 WS-ERR-RESP2-CICS   PIC S9(09) COMP VALUE ZEROS.

      *---------------------------------------------------------------*
      * ABEND CODE PARA CICS (4 CARACTERES)                          *
      *---------------------------------------------------------------*
           05 WS-ERR-ABCODE       PIC X(04) VALUE 'ERR9'.
