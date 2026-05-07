🚧 Proyecto en desarrollo como parte de mi especialización en arquitectura COBOL".

🛠️ Subprograma: PGMERROR (Gestión de Errores)
Esta rutina funcionará como el controlador central de errores del sistema, diseñado para transformar fallos críticos en información clara y procedimiento de cierre controlado.

* Centralizará en un único bloque el nombre del programa, el punto de falla y los códigos técnicos (SQLCODE, File Status, CICS RESP).
* Forzará una detención controlada con RC 9999, evitando interrupciones anormales (ABENDs) no gestionados, asegurando que el operador de consola reciba una alerta clara y el flujo de procesos se detenga antes de corromper datos.
* Permitirá que los programas de negocio deleguen toda la lógica de reporte y cancelación a este componente, manteniendo el código principal enfocado en la lógica de negocio.
"El FILE STATUS del archivo de salida se declara directamente sobre WS-ERR-FILE-STATUS de CPERROR, eliminando el MOVE intermedio y estandarizando el manejo de errores en todos los programas que adopten esta arquitectura."