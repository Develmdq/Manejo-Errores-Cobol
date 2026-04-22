      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMERROR.

      ******************************************************************
      *       SUBPROGRAMA CENTRALIZADO DE MANEJO DE ERRORES            *
      ******************************************************************
      * AUTOR: MARCET EDUARDO                       FECHA: 20/01/2026 *
      ******************************************************************
      * PARAMETROS DE ENTRADA:                                         *
      *   LS-NOMBRE-PGM  : NOMBRE DEL PROGRAMA QUE REPORTA EL ERROR   *
      *   LS-ACCION      : ACCION QUE SE EJECUTABA AL MOMENTO DEL ERROR*
      *   LS-FILE-STATUS : CODIGO DE FILE STATUS DEL ARCHIVO           *
      *   LS-SQLCODE     : CODIGO SQLCODE DE DB2                       *
      ******************************************************************

      ******************************************************************
       DATA DIVISION.
      ******************************************************************
       WORKING-STORAGE SECTION.
       77 FILLER             PIC X(26)  VALUE '* INICIO WS *'.

       01 WS-LINEA-SEPARADOR PIC X(40)  VALUE ALL '='.

       77 FILLER             PIC X(26)  VALUE '* FINAL  WS *'.

      *-----------------------------------------------------------------
       LINKAGE SECTION.
      *-----------------------------------------------------------------
       01 LS-NOMBRE-PGM      PIC X(8).
       01 LS-ACCION          PIC X(20).
       01 LS-FILE-STATUS     PIC X(2).
       01 LS-SQLCODE         PIC S9(9) COMP.

      ******************************************************************
       PROCEDURE DIVISION USING LS-NOMBRE-PGM
                                LS-ACCION
                                LS-FILE-STATUS
                                LS-SQLCODE.
      ******************************************************************
       PRINCIPAL.

           PERFORM 1000-INFORMAR-ERROR
           PERFORM 2000-CANCELAR
           .
       FIN-PRINCIPAL. GOBACK.

      ******************************************************************
      *                  INFORMAR ERROR EN SPOOL                       *
      ******************************************************************
       1000-INFORMAR-ERROR.

           DISPLAY WS-LINEA-SEPARADOR
           DISPLAY '*** ERROR FATAL ***'
           DISPLAY 'PROGRAMA    : ' LS-NOMBRE-PGM
           DISPLAY 'ACCION      : ' LS-ACCION
           DISPLAY 'FILE STATUS : ' LS-FILE-STATUS
           DISPLAY 'SQLCODE     : ' LS-SQLCODE
           DISPLAY WS-LINEA-SEPARADOR
           EXIT PARAGRAPH.

      ******************************************************************
      *                  CANCELAR EJECUCION                            *
      ******************************************************************
       2000-CANCELAR.

           MOVE 9999          TO RETURN-CODE

           EXIT PARAGRAPH.
