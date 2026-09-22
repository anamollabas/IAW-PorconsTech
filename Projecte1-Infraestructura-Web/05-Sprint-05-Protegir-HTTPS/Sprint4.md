Implantación de Aplicaciones Web

Curso 2026/2027

## HTTPS. Creación y configuración de un certificado SSL/TLS autofirmado en Apache

En esta práctica vamos a crear un **certificado SSL/TLS autofirmado** con la herramienta [`openssl`](https://www.openssl.org/). Una vez creado vamos a configurar el [servidor web Apache](https://httpd.apache.org/) para que utilice dicho certificado.

El proceso de creación de un certificado autofirmado consta de los siguientes pasos:

1.  Crear una clave privada y un certificado autofirmado.
2.  Configurar la clave privada y el certificado autofirmado en el servidor web.

Tenga en cuenta que cuando un cliente acceda desde un navegador web a un sitio web que utiliza un certificado autofirmado, se mostrará un mensaje de advertencia indicando que **el certificado no es de confianza, porque no ha sido emitido por una [autoridad de certificación (CA)](https://es.wikipedia.org/wiki/Infraestructura_de_clave_p%C3%BAblica) reconocida**.

Si el cliente acepta el certificado, el navegador web lo almacenará en su almacén de certificados y no volverá a mostrar el mensaje de advertencia.

No se recomienda utilizar certificados autofirmados en sitios web públicos, por lo tanto, esta práctica se utiliza con fines educativos para conocer con detalle cómo funciona el proceso de creación y configuración de un certificado autofirmado.

El proceso de creación de un certificado emitido por una [autoridad de certificación (CA)](https://es.wikipedia.org/wiki/Infraestructura_de_clave_p%C3%BAblica), consta de los siguientes pasos:

1.  Crear una clave privada.
    
2.  Crear una solicitud de certificado o _Certificate Signing Request_ (CSR) y enviarla a una autoridad de certificación (CA).
    
3.  La CA valida la solicitud y emite un certificado.
    
4.  El certificado se instala en el servidor web.
    

## Instalación del servidor web Apache

En primer lugar deberemos tener instado un [servidor web Apache](https://httpd.apache.org/) en nuestra máquina. Si todavía no lo hemos instalado, podemos hacerlo con los siguientes comandos:

```
<span id="cb1-1"><span>sudo</span> apt update</span>
<span id="cb1-2"><span>sudo</span> apt install apache2 <span>-y</span></span>
```

## Creación del certificado autofirmado

Para crear un certificado autofirmado vamos a utilizar la utilidad [`openssl`](https://www.openssl.org/).

Este es el comando que vamos a utilizar:

```
<span id="cb2-1"><span>sudo</span> openssl req <span>\</span></span>
<span id="cb2-2">  <span>-x509</span> <span>\</span></span>
<span id="cb2-3">  <span>-nodes</span> <span>\</span></span>
<span id="cb2-4">  <span>-days</span> 365 <span>\</span></span>
<span id="cb2-5">  <span>-newkey</span> rsa:2048 <span>\</span></span>
<span id="cb2-6">  <span>-keyout</span> /etc/ssl/private/apache-selfsigned.key <span>\</span></span>
<span id="cb2-7">  <span>-out</span> /etc/ssl/certs/apache-selfsigned.crt</span>
```

Vamos a explicar cada uno de los parámetros que hemos utilizado.

-   `req`: El subcomando `req` se utiliza para crear solicitudes de certificado en formato `PKCS#10`. También puede utilizarse para crear certificados autofirmados, que será el uso que le daremos en esta práctica.
    
-   `-x509`: Indica que queremos crear un certificado autofirmado en lugar de una solicitud de certificado, que se enviaría a una autoridad de certificación.
    
-   `-nodes`: Indica que la clave privada del certificado no estará protegida por contraseña y estará sin encriptar. Esto permite a las aplicaciones usar el certificado sin tener que introducir una contraseña cada vez que se utilice.
    
-   `-days 365`: Este parámetro indica la validez del certificado. En este caso hemos configurado una validez de 365 días.
    
-   `-newkey rsa:2048`: Este parámetro indica que queremos generar una nueva clave privada `RSA` de 2048 bits junto con el certificado. La longitud de clave de 2048 bits es un estándar razonable para la seguridad en la actualidad.
    
-   `-keyout /etc/ssl/private/apache-selfsigned.key`: Indica la ubicación y el nombre del archivo donde se guardará la clave privada generada. En este caso, hemos seleccionado que se guarde en la ruta `/etc/ssl/private/apache-selfsigned.key`.
    
-   `-out /etc/ssl/certs/apache-selfsigned.crt`: Indica la ubicación y el nombre del archivo donde se guardará el certificado. En este caso, hemos seleccionado que se guarde en la ruta `/etc/ssl/certs/apache-selfsigned.crt`.
    

Al ejecutar el comando tendremos que introducir una serie de datos por teclado que se añadirán al certificado. Los datos que tenemos que introducir son los siguientes:

-   **Código del país** de 2 caracteres que identifica el país donde se emite el certificado. Por ejemplo, `ES` para España.
-   **Provincia** donde se emite el certificado.
-   **Localidad** donde se emite el certificado.
-   **Nombre de la organización** para la que se emite el certificado.
-   **Nombre de la unidad o sección** de la organización.
-   **Nombre del dominio** para el que se emite el certificado.
-   **Email**.

**Ejemplo:**

Este ejemplo muestra la salida que obtendremos al ejecutar el comando anterior para crear el certificado autofirmado.

```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
```

## Cómo automatizar la creación de un certificado autofirmado

Para automatizar la creación de un certificado autofirmado desde un script de _Bash_, podemos hacer uso del parámetro `-subj` que nos permite pasar los datos se adjuntan al certificado como argumentos desde la línea de comandos.

**Ejemplo:**

```
<span id="cb4-1"><span>#!/bin/bash</span></span>
<span id="cb4-2"><span>set</span> <span>-x</span></span>
<span id="cb4-3"></span>
<span id="cb4-4"><span># Configuramos las variables con los datos que necesita el certificado</span></span>
<span id="cb4-5"><span>OPENSSL_COUNTRY</span><span>=</span><span>"ES"</span></span>
<span id="cb4-6"><span>OPENSSL_PROVINCE</span><span>=</span><span>"Almeria"</span></span>
<span id="cb4-7"><span>OPENSSL_LOCALITY</span><span>=</span><span>"Almeria"</span></span>
<span id="cb4-8"><span>OPENSSL_ORGANIZATION</span><span>=</span><span>"IES Celia"</span></span>
<span id="cb4-9"><span>OPENSSL_ORGUNIT</span><span>=</span><span>"Departamento de Informatica"</span></span>
<span id="cb4-10"><span>OPENSSL_COMMON_NAME</span><span>=</span><span>"practica-https.local"</span></span>
<span id="cb4-11"><span>OPENSSL_EMAIL</span><span>=</span><span>"admin@iescelia.org"</span></span>
<span id="cb4-12"></span>
<span id="cb4-13"><span># Creamos el certificado autofirmado</span></span>
<span id="cb4-14"><span>sudo</span> openssl req <span>\</span></span>
<span id="cb4-15">  <span>-x509</span> <span>\</span></span>
<span id="cb4-16">  <span>-nodes</span> <span>\</span></span>
<span id="cb4-17">  <span>-days</span> 365 <span>\</span></span>
<span id="cb4-18">  <span>-newkey</span> rsa:2048 <span>\</span></span>
<span id="cb4-19">  <span>-keyout</span> /etc/ssl/private/apache-selfsigned.key <span>\</span></span>
<span id="cb4-20">  <span>-out</span> /etc/ssl/certs/apache-selfsigned.crt <span>\</span></span>
<span id="cb4-21">  <span>-subj</span> <span>"/C=</span><span>$OPENSSL_COUNTRY</span><span>/ST=</span><span>$OPENSSL_PROVINCE</span><span>/L=</span><span>$OPENSSL_LOCALITY</span><span>/O=</span><span>$OPENSSL_ORGANIZATION</span><span>/OU=</span><span>$OPENSSL_ORGUNIT</span><span>/CN=</span><span>$OPENSSL_COMMON_NAME</span><span>/emailAddress=</span><span>$OPENSSL_EMAIL</span><span>"</span></span>
```

## Cómo consultar la información del sujeto del certificado

```
<span id="cb5-1"><span>openssl</span> x509 <span>-in</span> /etc/ssl/certs/apache-selfsigned.crt <span>-noout</span> <span>-subject</span></span>
```

## Cómo consultar la fecha de caducidad del certificado

```
<span id="cb6-1"><span>openssl</span> x509 <span>-in</span> /etc/ssl/certs/apache-selfsigned.crt <span>-noout</span> <span>-dates</span></span>
```

## Configuración de un VirtualHost con SSL/TSL en el servidor web Apache

**Paso 1**

Editamos el archivo de configuración del virtual host donde queremos habilitar el tráfico HTTPS.

En nuestro caso, utilizaremos el archivo de configuración que tiene Apache por defecto para SSL/TLS, que está en la ruta: `/etc/apache2/sites-available/default-ssl.conf`.

El contenido del archivo será el siguiente:

```
<span id="cb7-1"><span>&lt;</span>VirtualHost <span>*:443</span><span>&gt;</span></span>
<span id="cb7-2">    <span>#ServerName practica-https.local</span></span>
<span id="cb7-3">    <span>DocumentRoot</span> /var/www/html</span>
<span id="cb7-4">    <span>DirectoryIndex</span> index.php index.html</span>
<span id="cb7-5"></span>
<span id="cb7-6">    <span>SSLEngine</span> on</span>
<span id="cb7-7">    <span>SSLCertificateFile</span> /etc/ssl/certs/apache-selfsigned.crt</span>
<span id="cb7-8">    <span>SSLCertificateKeyFile</span> /etc/ssl/private/apache-selfsigned.key</span>
<span id="cb7-9"><span>&lt;</span>/VirtualHost<span>&gt;</span></span>
```

Las directivas que hemos configurado son:

-   `<VirtualHost *:443>`: Indica que este virtual host escuchará en el puerto `443` (HTTPS).
    
-   `ServerName`: Indica el nombre de dominio y se utiliza para indicar al servidor web Apache qué peticiones debe servir para este virtual host. En nuestro ejemplo estamos utilizando el dominio `practica-https.local`.
    
-   `DocumentRoot`: Es la ruta donde se encuentra el directorio raíz del host virtual.
    
-   `SSLEngine on`: Configuramos que este virtual host utilizará SSL/TLS.
    
-   `SSLCertificateFile`: Indica la ruta donde se encuentra el certificado autofirmado.
    
-   `SSLCertificateKeyFile`: Indica la ruta donde se encuentra la clave privada del certificado autofirmado.
    

**Paso 2**

Habilitamos el virtual host que acabamos de configurar.

```
<span id="cb8-1"><span>sudo</span> a2ensite default-ssl.conf</span>
```

Tenga en cuenta que estamos utilizando el nombre de archivo `default-ssl.conf` porque estamos utilizando el archivo que tiene Apache por defecto para configurar un virtual host con SSL/TLS, pero en su caso puede ser otro.

**Paso 3**

Habilitamos el módulo SSL en Apache.

**Paso 4**

Configuramos el virtual host de HTTP para que redirija todo el tráfico a HTTPS.

En nuestro caso, el virtual host que maneja las peticiones HTTP está en el archivo de configuración que utiliza Apache por defecto para el puerto `80`: `/etc/apache2/sites-available/000-default.conf`.

El contenido del archivo será el siguiente:

```
<span id="cb10-1"><span>&lt;</span>VirtualHost <span>*:80</span><span>&gt;</span></span>
<span id="cb10-2">    <span>#ServerName practica-https.local</span></span>
<span id="cb10-3">    <span>DocumentRoot</span> /var/www/html</span>
<span id="cb10-4"></span>
<span id="cb10-5">    <span># Redirige al puerto 443 (HTTPS)</span></span>
<span id="cb10-6">    <span>RewriteEngine</span> On</span>
<span id="cb10-7">    <span>RewriteCond</span> %{HTTPS} off</span>
<span id="cb10-8">    <span>RewriteRule</span> ^ https://%{HTTP_HOST}%{REQUEST_URI} <span>[</span><span>L,R=301</span><span>]</span></span>
<span id="cb10-9"><span>&lt;</span>/VirtualHost<span>&gt;</span></span>
```

Las directivas que hemos configurado son:

-   `RewriteEngine On`: Habilita el motor de reescritura de URLs y nos permite usar reglas de reescritura.
    
-   `RewriteCond %{HTTPS} off`: Esta directiva es una condición que comprueba si la petición recibida utiliza HTTPS o no. Si se cumple esta condición, entonces se ejecuta la siguiente línea.
    
-   `RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]`: Las reglas de reescritura tienen la siguiente sintaxis `RewriteRule Pattern Substitution [flags]`.
    
    -   `Pattern`: Es el patrón que se debe cumplir en la URL solicitada para que la regla de reescritura se aplique. En este caso, `^` coincide con el principio de la URL, por lo que se aplicará a todas las solicitudes.
    -   `Substitution`: Es la URL a la que se redirige la solicitud. En este caso, se utiliza el valor `https://%{HTTP_HOST}%{REQUEST_URI}` y por lo tanto se redirige la solicitud a HTTPS manteniendo el mismo nombre de dominio y URI.
    -   `flags`: Son los flags que se pueden utilizar para modificar el comportamiento de la regla de reescritura. En este caso, el flag `[L,R=301]` indica que es una redirección permanente (Código de estado: 301).

Las directivas utilizan las siguientes **variables del servidor** que se obtienen de la cabecera de la petición HTTP:

-   `%{HTTPS}`: Contiene el texto `on` si la conexión utiliza SSL/TLS o `off` en caso contrario.
    
-   `%{HTTP_HOST}`: Contiene el nombre de dominio que se ha utilizado en la petición del cliente para acceder al sitio web.
    
-   `%{REQUEST_URI}`: Contiene la URI que ha utilizado el cliente para acceder al sitio web. Por ejemplo, `/index.html`. Si la petición incluye parámetros éstos estarán almacenados en la variable `%{QUERY_STRING}`.
    

[En la documentación oficial del módulo `mod_rewrite` de Apache](https://httpd.apache.org/docs/2.4/mod/mod_rewrite.html) puede encontrar más información sobre estas directivas.

**Paso 5**

Para que el servidor web Apache pueda hacer la redirección de HTTP a HTTPS es necesario habilitar el módulo `rewrite` en Apache.

**Paso 6**

Reiniciamos el servicio de Apache

```
<span id="cb12-1"><span>sudo</span> systemctl restart apache2</span>
```

**Paso 7**

Una vez llegado a este punto, es necesario comprobar que el puerto `443` está abierto en las reglas del firewall para permitir el tráfico HTTPS.

**Paso 8**

Accede desde un navegador web al nombre de dominio que acabas de configurar. En nuesro caso será: `https://practica-https.local`.

## Tareas a realizar

En esta práctica tendremos que realizar la instalación de la [pila LAMP](https://github.com/anamollabas/iaw-practica-lamp) y la **configuración de un certificado SSL/TLS autofirmado** en el [servidor web Apache](https://httpd.apache.org/), en una instancia EC2 de [Amazon Web Services (AWS)](https://aws.amazon.com/es/) con la última versión de [Ubuntu Server](https://ubuntu.com/server).

A continuación se describen **muy brevemente** algunas de las tareas que tendrá que realizar.

1.  Crea una instancia EC2 en AWS.
    
2.  La **Amazon Machine Image (AMI)** que vamos a seleccionar para esta práctica será una **Community AMI** con la última versión de **Ubuntu Server**.
    
3.  Cuando esté creando la instancia deberá configurar los puertos que estarán abiertos para poder conectarnos por SSH y para poder acceder por HTTP/HTTPS.
    
    -   SSH (TCP)
    -   HTTP (TCP)
    -   HTTPS (TCP)
4.  Crea un par de claves (pública y privada) para conectar por SSH con la instancia. También puedes hacer uso de las claves que te proporciona AWS Academy (_vockey.pem_).
    
5.  Crea una dirección **IP elástica** y asígnala a la instancia EC2.
    
6.  Una vez que haya iniciado su instancia deberá hacer uso de los **scripts de bash** que diseñó en las prácticas anteriores para automatizar la instalación de la pila LAMP.
    
7.  Automatice la creación y configuración de un certificado autofirmado SSL/TLS con la utilidad [`openssl`](https://www.openssl.org/) para el servidor web Apache.
    
8.  Busque cuál es la dirección IP elástica de su instancia y compruebe que puede acceder a ella desde una navegador web.
    

## Entregables

Deberá crear un repositorio en [GitHub](https://github.com/) con el nombre de la práctica y añadir al profesor como colaborador.

El repositorio debe tener el siguiente contenido:

-   Un **documento técnico** con la descripción de todos los pasos que se han llevado a cabo.
-   Los **scripts de Bash** que se han utilizado para automatizar la creación y configuración de un certificado SSL/TLS autofirmado en el servidor web Apache.

Además del contenido anterior puede ser necesario crear otros archivos de configuración. A continuación se muestra un ejemplo de cómo puede ser la estructura del repositorio:

```
.
├── README.md
├── conf
│   ├── 000-default.conf
│&nbsp;&nbsp; └── default-ssl.conf
└── scripts
    ├── .env
    ├── install_lamp.sh
    └── setup_selfsigned_certificate.sh
```

### Documento técnico

El documento técnico `README.md` tiene que estar escrito en [Markdown](https://es.wikipedia.org/wiki/Autoridad_de_certificaci%C3%B3n) y debe incluir **como mínimo** los siguientes contenidos:

-   Descripción del proceso de creación y configuración del certificado SSL/TLS autofirmado en el servidor web Apache.

### Scripts de Bash

El directorio `scripts` debe incluir los siguientes archivos:

-   `.env`: Este archivo contiene todas las variables de configuración que se utilizarán en los scripts de Bash.
    
-   `install_lamp.sh`: Script de Bash con la automatización del proceso de instalación de la pila LAMP.
    
-   `setup_selfsigned_certificate.sh`: Script de Bash con la automatización del proceso de creación y configuración de un certificado SSL/TLS autofirmado en Apache.
    

## Referencias

-   [¿Qué es HTTPS?](https://www.cloudflare.com/es-es/learning/ssl/what-is-https/). Documentación oficial de Cloudflare.
-   [Book: OpenSSL Cookbook](https://www.feistyduck.com/library/openssl-cookbook/). Ivan Ristić.
-   [Infraestructura de clave pública (PKI)](https://es.wikipedia.org/wiki/Infraestructura_de_clave_p%C3%BAblica). Wikipedia.
-   [Autoridad Certificadora (CA)](https://es.wikipedia.org/wiki/Autoridad_de_certificaci%C3%B3n). Wikipedia.
-   [X.509](https://es.wikipedia.org/wiki/X.509). Wikipedia.
-   [RSA](https://es.wikipedia.org/wiki/RSA). Wikipedia.
-   [Módulo `mod_rewrite` de Apache](https://httpd.apache.org/docs/2.4/mod/mod_rewrite.html). Documentación oficial de Apache.

## Licencia

[![Licencia de Creative Commons](data:image/png;base64,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)](http://creativecommons.org/licenses/by-nc-sa/4.0/)  
