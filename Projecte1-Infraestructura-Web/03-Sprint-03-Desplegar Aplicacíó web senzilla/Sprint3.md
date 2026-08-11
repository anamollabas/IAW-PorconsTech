1 Despliegue de una aplicación web LAMP sencilla
En esta práctica tendremos que realizar el despliegue de una aplicación web LAMP sencilla en una instancia EC2 de Amazon Web Services (AWS) con la última versión de Ubuntu Server.

En primer lugar, tendrás que instalar y configurar la pila LAMP haciendo uso de los scripts que diseñaste en la Actividad 1.1. Una vez que hayas comprobado que todos los servicios de la pila LAMP están funcionando correctamente, instala y configura la aplicación web propuesta.

1.1 Repositorio de la aplicación web que tendrá que desplegar
https://github.com/anamollabas/iaw-practica-lamp
1.2 Tareas a realizar
A continuación se describen muy brevemente algunas de las tareas que tendrá que realizar.

Crea una instancia EC2 en AWS.

La Amazon Machine Image (AMI) que vamos a seleccionar para esta práctica será una Community AMI con la última versión de Ubuntu Server.

Cuando esté creando la instancia deberá configurar los puertos que estarán abiertos para poder conectarnos por SSH y para poder acceder por HTTP/HTTPS.

SSH (TCP)
HTTP (TCP)
HTTPS (TCP)
Crea un par de claves (pública y privada) para conectar por SSH con la instancia. También puedes hacer uso de las claves que te proporciona AWS Academy (vockey.pem).

Crea una dirección IP elástica y asígnala a la instancia EC2.

Una vez que haya iniciado su instancia deberá hacer uso de los scripts de bash que diseñó en las prácticas anteriores para automatizar la instalación de la pila LAMP.

Automatice la instalación de la aplicación web LAMP propuesta.

Busque cuál es la dirección IP elástica de su instancia y compruebe que puede acceder a ella desde una navegador web.

1.3 Entregables
Deberá crear un repositorio en GitHub con el nombre de la práctica y añadir al profesor como colaborador.

El repositorio debe tener el siguiente contenido:

Un documento técnico con la descripción de todos los pasos que se han llevado a cabo.
Los scripts de Bash que se han utilizado para automatizar la instalación y configuración de la pila LAMP, así como de la aplicación web LAMP propuesta.
Además del contenido anterior puede ser necesario crear otros archivos de configuración. A continuación se muestra un ejemplo de cómo puede ser la estructura del repositorio:

.
├── README.md
├── conf
│   └── 000-default.conf
└── scripts
    ├── .env
    ├── install_lamp.sh
    └── deploy.sh
1.3.1 Documento técnico
El documento técnico README.md tiene que estar escrito en Markdown y debe incluir como mínimo los siguientes contenidos:

Descripción del proceso de instalación de la aplicación web LAMP propuesta.
1.3.2 Scripts de Bash
El directorio scripts debe incluir los siguientes archivos:

.env: Este archivo contiene todas las variables de configuración que se utilizarán en los scripts de Bash.

install_lamp.sh: Script de Bash con la automatización del proceso de instalación de la pila LAMP.

deploy.sh: Script de Bash con la automatización del proceso de instalación de la aplicación web LAMP propuesta.

2 Referencias
Amazon Web Services
Amazon Web Services en Wikipedia
Ubuntu Server
Instalación de la pila LAMP en Ubuntu Server
3 Licencia
Licencia de Creative Commons