//PGMERROR JOB 1,NOTIFY=&SYSUID,REGION=0M
//*----------------------------------------------------------*
//*  PASO 1: COMPILACION COBOL                              *
//*----------------------------------------------------------*
//COBOL   EXEC IGYWCL
//COBOL.SYSIN   DD DSN=&SYSUID..CBL(RUTERRBA),DISP=SHR
//COBOL.SYSLIB  DD DSN=&SYSUID..SYSLIB,DISP=SHR
//LKED.SYSLMOD  DD DSN=&SYSUID..LOAD(RUTERRBA),DISP=SHR
/*
