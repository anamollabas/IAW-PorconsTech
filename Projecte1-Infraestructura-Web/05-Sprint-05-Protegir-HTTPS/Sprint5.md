# Sprint 5 · Proteger la infraestructura con HTTPS

> **Proyecto 1 · Infraestructura Web · PorçonsTech**

En este Sprint vamos a proteger el acceso a nuestra aplicación web utilizando **HTTPS**.

Para ello crearemos un **certificado SSL/TLS autofirmado con OpenSSL** y configuraremos **Apache** para utilizarlo.

> Un certificado autofirmado es útil para aprender cómo funciona HTTPS, pero **no es adecuado para una web pública real**, porque no ha sido emitido por una autoridad de certificación reconocida. Por eso el navegador mostrará una advertencia de seguridad.

---

## 1. Objetivo del Sprint

Al finalizar este Sprint debes ser capaz de:

- crear una clave privada y un certificado autofirmado;
- identificar qué información contiene el certificado;
- configurar Apache para utilizar HTTPS;
- habilitar el puerto **443**;
- redirigir las peticiones HTTP hacia HTTPS;
- comprobar que la aplicación sigue funcionando;
- explicar por qué el navegador muestra una advertencia con un certificado autofirmado.

---

## 2. Punto de partida

**No tienes que crear una nueva EC2 ni volver a instalar la pila LAMP.**

Continúa utilizando la instancia y la aplicación del Sprint anterior.

Antes de empezar comprueba:

- [ ] la instancia EC2 está en ejecución;
- [ ] puedes acceder por SSH;
- [ ] Apache está activo;
- [ ] la aplicación funciona correctamente mediante HTTP;
- [ ] la IP elástica sigue asociada a la instancia;
- [ ] el Security Group permite el tráfico HTTP necesario.

Puedes comprobar Apache con:

```bash
sudo systemctl status apache2
```

Y acceder desde el navegador mediante:

```text
http://IP_ELASTICA
```

> No continúes hasta que la aplicación funcione correctamente por HTTP.

---

## 3. Antes de empezar: ¿qué estamos haciendo?

Hasta ahora el navegador accedía al servidor mediante HTTP. Ahora vamos a configurar HTTPS.

HTTPS utiliza **TLS** para proteger la comunicación entre el navegador y el servidor.

Apache necesita:

```text
una clave privada
        +
un certificado
```

En esta práctica ambos se crearán con **OpenSSL**.

### ¿Qué es un certificado autofirmado?

Normalmente, un certificado utilizado en una web pública es emitido por una **autoridad de certificación (CA)** reconocida.

En este Sprint simplificaremos el proceso creando nosotros mismos un **certificado autofirmado**.

Esto nos permitirá trabajar con HTTPS y entender su configuración, pero el navegador mostrará una advertencia indicando que el certificado **no es de confianza**.

---

## 4. Crear el certificado autofirmado

Utilizaremos la herramienta `openssl`.

Ejecuta:

```bash
sudo openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt
```

Durante el proceso tendrás que introducir información para identificar el certificado:

- país;
- provincia;
- localidad;
- organización;
- unidad organizativa;
- nombre común o **Common Name**;
- correo electrónico.

Para esta práctica puedes utilizar datos identificativos del proyecto.

### ¿Qué significa cada opción?

| Opción | Función |
|---|---|
| `req` | Permite crear solicitudes de certificado y certificados autofirmados. |
| `-x509` | Indica que queremos crear directamente un certificado autofirmado. |
| `-nodes` | La clave privada no estará protegida mediante contraseña. |
| `-days 365` | El certificado tendrá una validez de 365 días. |
| `-newkey rsa:2048` | Crea una nueva clave privada RSA de 2048 bits. |
| `-keyout` | Indica dónde se guardará la clave privada. |
| `-out` | Indica dónde se guardará el certificado. |

Al terminar tendremos:

```text
/etc/ssl/private/apache-selfsigned.key
```

y:

```text
/etc/ssl/certs/apache-selfsigned.crt
```

> La **clave privada** no debe publicarse ni copiarse al repositorio de GitHub.

---

## 5. Consultar la información del certificado

Comprueba el sujeto del certificado:

```bash
openssl x509 -in /etc/ssl/certs/apache-selfsigned.crt -noout -subject
```

Comprueba también sus fechas de validez:

```bash
openssl x509 -in /etc/ssl/certs/apache-selfsigned.crt -noout -dates
```

Debes ser capaz de comprobar:

- para quién se ha creado;
- cuándo empieza su validez;
- cuándo caduca.

---

## 6. Configurar Apache para HTTPS

Apache dispone de una configuración SSL por defecto:

```text
/etc/apache2/sites-available/default-ssl.conf
```

Edita el archivo:

```bash
sudo nano /etc/apache2/sites-available/default-ssl.conf
```

Comprueba que el VirtualHost del puerto 443 contiene la configuración necesaria.

Una versión simplificada sería:

```apache
<VirtualHost *:443>

    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html

    SSLEngine on

    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

</VirtualHost>
```

### ¿Qué significa esta configuración?

| Directiva | Función |
|---|---|
| `<VirtualHost *:443>` | Este VirtualHost atenderá conexiones HTTPS. |
| `DocumentRoot` | Indica dónde se encuentra la aplicación web. |
| `DirectoryIndex` | Define los archivos que Apache buscará como página inicial. |
| `SSLEngine on` | Activa SSL/TLS para este VirtualHost. |
| `SSLCertificateFile` | Ruta del certificado. |
| `SSLCertificateKeyFile` | Ruta de la clave privada. |

---

## 7. Habilitar SSL en Apache

Habilita el módulo SSL:

```bash
sudo a2enmod ssl
```

Habilita también el sitio SSL:

```bash
sudo a2ensite default-ssl.conf
```

Reinicia Apache:

```bash
sudo systemctl restart apache2
```

Comprueba que continúa activo:

```bash
sudo systemctl status apache2
```

---

## 8. Permitir HTTPS en AWS

HTTPS utiliza el puerto:

```text
443/TCP
```

En el **Security Group** de la EC2 añade la regla necesaria para permitir tráfico HTTPS.

Al finalizar deberías tener abiertos únicamente los accesos necesarios para el proyecto.

| Servicio | Puerto |
|---|---:|
| SSH | 22 |
| HTTP | 80 |
| HTTPS | 443 |

> No abras rangos de puertos que no necesites.

---

## 9. Probar HTTPS

Accede desde el navegador:

```text
https://IP_ELASTICA
```

El navegador mostrará una advertencia porque el certificado es **autofirmado**. Esto es esperado.

Acepta la advertencia únicamente porque estamos trabajando en un entorno educativo controlado.

Después comprueba que:

- la aplicación se carga;
- PHP sigue funcionando;
- la aplicación continúa accediendo a MySQL;
- estás accediendo mediante `https://`.

---

## 10. Redirigir HTTP hacia HTTPS

Edita el VirtualHost HTTP:

```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

La configuración puede quedar así:

```apache
<VirtualHost *:80>

    DocumentRoot /var/www/html

    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

</VirtualHost>
```

### ¿Qué hace esta regla?

```apache
RewriteEngine On
```

Activa el motor de reescritura.

```apache
RewriteCond %{HTTPS} off
```

Comprueba si la petición no utiliza HTTPS.

```apache
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

Redirige la petición hacia la misma dirección utilizando HTTPS.

El código `301` indica una redirección permanente.

---

## 11. Habilitar el módulo rewrite

```bash
sudo a2enmod rewrite
```

Reinicia Apache:

```bash
sudo systemctl restart apache2
```

---

## 12. Comprobaciones finales

Realiza estas dos pruebas:

```text
https://IP_ELASTICA
```

La aplicación debe funcionar mediante HTTPS.

Después:

```text
http://IP_ELASTICA
```

La petición debe terminar redirigida a HTTPS.

Antes de dar el Sprint por terminado comprueba:

| Comprobación | Resultado |
|---|:---:|
| ¿Apache continúa activo? | ☐ |
| ¿El puerto 443 está permitido en AWS? | ☐ |
| ¿Existe la clave privada? | ☐ |
| ¿Existe el certificado? | ☐ |
| ¿Puedo consultar sus fechas de validez? | ☐ |
| ¿La aplicación funciona mediante HTTPS? | ☐ |
| ¿El navegador avisa de que el certificado es autofirmado? | ☐ |
| ¿HTTP redirige hacia HTTPS? | ☐ |
| ¿No he publicado la clave privada? | ☐ |

---

## 13. Si algo falla

### Apache no inicia después de modificar la configuración

Comprueba:

```bash
sudo systemctl status apache2
```

Revisa especialmente:

- la ruta del certificado;
- la ruta de la clave privada;
- la sintaxis del VirtualHost.

### HTTP funciona pero HTTPS no

Comprueba:

```text
1. ¿Está habilitado el módulo SSL?
2. ¿Está habilitado default-ssl.conf?
3. ¿Apache está activo?
4. ¿Existe el certificado?
5. ¿Existe la clave privada?
6. ¿El Security Group permite el puerto 443?
```

### HTTPS funciona pero HTTP no redirige

Comprueba:

```text
1. ¿Está habilitado mod_rewrite?
2. ¿La regla está en el VirtualHost del puerto 80?
3. ¿Has reiniciado Apache después del cambio?
```

---

## 14. Entrega

Continúa utilizando el repositorio del **Proyecto 1**.

No crees un repositorio nuevo.

Utiliza la carpeta:

```text
05-Sprint-05-Protegir-HTTPS/
```

Dentro puedes mantener una estructura sencilla:

```text
05-Sprint-05-Protegir-HTTPS/
├── README.md
├── imatges/
└── conf/
```

> No subas la clave privada al repositorio.

### Evidencia 1 · Certificado creado

Incluye una captura o salida donde se vea la información básica del certificado.

Puedes utilizar:

```bash
openssl x509 -in /etc/ssl/certs/apache-selfsigned.crt -noout -subject -dates
```

Explica brevemente:

> ¿Por qué el navegador no considera de confianza este certificado?

### Evidencia 2 · HTTPS funcionando

Incluye una captura del navegador mostrando la aplicación mediante:

```text
https://IP_ELASTICA
```

Explica:

> ¿Qué hemos añadido a nuestra infraestructura para poder utilizar HTTPS?

### Evidencia 3 · Configuración de Apache

Incluye únicamente la parte relevante de la configuración de:

```text
default-ssl.conf
```

y:

```text
000-default.conf
```

No copies configuraciones completas si no aportan información útil.

Explica:

> ¿Qué función tienen `SSLCertificateFile` y `SSLCertificateKeyFile`?

### Evidencia 4 · Redirección HTTP → HTTPS

Demuestra que al acceder por HTTP acabas utilizando HTTPS.

Explica brevemente:

> ¿Qué hace la regla de redirección que hemos configurado?

---

## 15. Antes de entregar

```text
[ ] Mi aplicación funciona mediante HTTPS.
[ ] HTTP redirige hacia HTTPS.
[ ] Sé diferenciar certificado y clave privada.
[ ] Sé por qué el navegador muestra una advertencia.
[ ] Sé para qué sirve el puerto 443.
[ ] No he publicado la clave privada.
[ ] No he publicado credenciales de AWS.
[ ] Mi README contiene evidencias útiles y explicaciones propias.
```

---

## Qué debes llevarte de este Sprint

No necesitas memorizar cada parámetro de OpenSSL.

Lo importante es entender este proceso:

```text
OpenSSL
   ↓
crea clave privada + certificado
   ↓
Apache los utiliza en el VirtualHost :443
   ↓
AWS permite el puerto 443
   ↓
el navegador accede mediante HTTPS
```

Y también entender que:

```text
certificado autofirmado
≠
certificado emitido por una CA reconocida
```

Por eso podemos trabajar con HTTPS durante la práctica aunque el navegador muestre una advertencia.
