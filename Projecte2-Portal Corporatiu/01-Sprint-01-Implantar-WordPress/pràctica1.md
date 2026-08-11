# 🧩 Implantació de WordPress

> [!NOTE]
> Aquesta pràctica està basada en el material de **José Juan Sánchez Hernández**, adaptat a la metodologia **PorçonsTech**.

> [!IMPORTANT]
> Aquest Sprint continua sobre el servidor configurat al **Projecte 1 · Infraestructura Web**.
>
> No cal tornar a instal·lar:
>
> - Ubuntu Server
> - Apache
> - PHP
> - MariaDB
> - HTTPS
>
> Es pressuposa que tots aquests serveis funcionen correctament abans de començar.
>
> Si el teu servidor no està preparat, completa primer el **Projecte 1**.

---

## 🎯 Objectiu

En aquesta pràctica implantaràs **WordPress** sobre la infraestructura web ja desplegada.

Aprendràs a:

- identificar què és un gestor de continguts;
- comprendre per a què serveix WordPress;
- descarregar i instal·lar WordPress;
- crear i configurar la base de dades;
- configurar el fitxer `wp-config.php`;
- preparar els enllaços permanents;
- aplicar mecanismes bàsics de seguretat;
- verificar que el CMS funciona correctament.

---

## 📚 Què és un CMS?

Un **Sistema de Gestió de Continguts (CMS, Content Management System)** és una aplicació que permet crear, editar, organitzar i publicar continguts web sense necessitat de programar tot el lloc des de zero.

Alguns exemples de CMS són:

- WordPress
- Joomla
- Drupal

En aquest projecte utilitzarem **WordPress**.

---

## 🌐 Què és WordPress?

WordPress és un gestor de continguts lliure i gratuït desenvolupat en PHP.

Permet crear i administrar llocs web de manera senzilla i disposa d'un gran ecosistema de:

- temes;
- plugins;
- plantilles;
- eines d'administració.

En aquest projecte l'utilitzarem per crear el **portal corporatiu de PorçonsTech**.

---

# 📝 Pas 1 · Descarregar WordPress

En aquest primer pas descarregarem l'última versió estable de **WordPress** i prepararem els fitxers per a la seua instal·lació.

## 1.1 Descarrega WordPress

Descarrega l'última versió estable de WordPress al directori temporal.

```bash
wget https://wordpress.org/latest.tar.gz -P /tmp
```

El paràmetre `-P` indica el directori on es guardarà el fitxer descarregat.



---

## 1.2 Descomprimeix el fitxer

Una vegada descarregat, descomprimeix el paquet.

```bash
tar -xzvf /tmp/latest.tar.gz -C /tmp
```

Aquest comandament crearà un directori anomenat `wordpress` dins de `/tmp`.



---

## 1.3 Copia els fitxers

En aquest projecte instal·larem WordPress al directori principal del servidor web.

```bash
mv -f /tmp/wordpress/* /var/www/html
```

Quan finalitze aquest pas, tots els fitxers de WordPress hauran quedat copiats al directori del servidor web.



---

## ✅ Comprovació

Comprova que el contingut del directori `/var/www/html` correspon als fitxers de WordPress.

Pots utilitzar:

```bash
ls -la /var/www/html
```

Has de veure fitxers com:

- `index.php`
- `wp-admin`
- `wp-content`
- `wp-includes`
- `wp-config-sample.php`

Si és així, pots continuar amb el següent pas.

---

# 📝 Pas 2 · Crear la base de dades

Abans de poder utilitzar WordPress és necessari crear una base de dades i un usuari amb permisos sobre aquesta.

WordPress utilitzarà aquesta base de dades per emmagatzemar tota la informació del lloc web: pàgines, entrades, usuaris, configuració, comentaris, etc.

---

## 2.1 Crear la base de dades

Executa les ordres necessàries per crear una nova base de dades.

```bash
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
```

---

## 2.2 Crear l'usuari

Ara crea un usuari específic per a WordPress.

```bash
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
```

---

## 2.3 Assignar permisos

Finalment assigna tots els permisos sobre la base de dades creada.

```bash
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
```

---

## 💡 Per què no utilitzem l'usuari root?

Per motius de seguretat.

Cada aplicació ha de disposar del seu propi usuari de base de dades amb únicament els permisos necessaris.

Aquesta és una bona pràctica molt habitual en entorns professionals.

---

## ✅ Comprovació

Comprova que la base de dades i l'usuari s'han creat correctament.

Pots utilitzar:

```bash
mysql -u root
```

Una vegada dins de MariaDB:

```sql
SHOW DATABASES;

SELECT user, host FROM mysql.user;
```

Has de comprovar que:

- existeix la base de dades de WordPress;
- existeix l'usuari creat;
- l'usuari disposa de permisos sobre la base de dades.



---

# 📝 Pas 3 · Configurar `wp-config.php`

El fitxer `wp-config.php` és un dels fitxers més importants de WordPress.

En ell es defineixen els paràmetres necessaris perquè el CMS puga connectar-se a la base de dades i funcionar correctament.

---

## 3.1 Crear el fitxer de configuració

WordPress inclou un fitxer d'exemple anomenat `wp-config-sample.php`.

Copia'l amb el nom `wp-config.php`.

```bash
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```


---

## 3.2 Configurar la connexió amb la base de dades

Edita el fitxer `wp-config.php`.

```bash
nano /var/www/html/wp-config.php
```

Modifica les següents línies:

```php
define('DB_NAME', 'nom_base_de_dades');
define('DB_USER', 'usuari');
define('DB_PASSWORD', 'contrasenya');
define('DB_HOST', 'localhost');
```

Substitueix aquests valors pels que has creat en el pas anterior.

![Configuració de la base de dades](imatges/07-db-config.png)

---

## 💡 Què significa cada variable?

| Variable | Funció |
|----------|--------|
| DB_NAME | Nom de la base de dades |
| DB_USER | Usuari que utilitzarà WordPress |
| DB_PASSWORD | Contrasenya de l'usuari |
| DB_HOST | Servidor on es troba MariaDB |

---

## 3.3 Guardar els canvis

Guarda el fitxer.

Si utilitzes **nano**:

- `Ctrl + O`
- Intro
- `Ctrl + X`

---

## ✅ Comprovació

Comprova que el fitxer existeix.

```bash
ls -l /var/www/html/wp-config.php
```

També pots revisar les primeres línies.

```bash
head -30 /var/www/html/wp-config.php
```

Comprova que les dades coincideixen amb la base de dades creada anteriorment.
---

# 📝 Pas 4 · Millorar la seguretat de WordPress

Una vegada configurada la connexió amb la base de dades, és convenient reforçar la seguretat de la instal·lació.

WordPress incorpora un conjunt de **Security Keys** que s'utilitzen per protegir les sessions dels usuaris i generar cookies segures.

Cada instal·lació ha de disposar d'unes claus úniques.

---

## 4.1 Obtenir unes noves Security Keys

Accedeix a la següent adreça:

https://api.wordpress.org/secret-key/1.1/salt/

Es mostraran unes claus semblants a aquestes:

```php
define('AUTH_KEY',         '...');
define('SECURE_AUTH_KEY',  '...');
define('LOGGED_IN_KEY',    '...');
...
```

Copia tot aquest bloc.

![Security Keys](imatges/08-security-keys-api.png)

---

## 4.2 Actualitzar el fitxer de configuració

Obri de nou el fitxer:

```bash
nano /var/www/html/wp-config.php
```

Busca el bloc de **Authentication Unique Keys and Salts**.

Substitueix totes les claus que apareixen per les noves claus generades a la web oficial de WordPress.

![Editar wp-config.php](imatges/09-security-keys-config.png)

---

## 💡 Per què és important?

Aquestes claus permeten:

- protegir les sessions dels usuaris;
- generar cookies més segures;
- dificultar possibles atacs sobre les credencials.

És recomanable que cada instal·lació utilitze unes claus diferents.

---

## ✅ Comprovació

Guarda els canvis.

Comprova que el fitxer `wp-config.php` conté les noves claus generades.
---

# 📝 Pas 5 · Configurar els permisos dels fitxers

Perquè WordPress funcione correctament, els fitxers han de pertànyer a l'usuari amb què s'executa el servidor web.

En Ubuntu, aquest usuari és normalment **www-data**.

---

## 5.1 Assignar el propietari

Executa el següent comandament:

```bash
chown -R www-data:www-data /var/www/html
```

Aquest comandament assigna la propietat de tots els fitxers de WordPress a l'usuari i grup **www-data**.

---

## 5.2 Configurar els permisos

Assigna els permisos recomanats.

```bash
find /var/www/html -type d -exec chmod 755 {} \;
```

```bash
find /var/www/html -type f -exec chmod 644 {} \;
```

---

## 💡 Per què és important?

Uns permisos incorrectes poden provocar:

- errors durant la instal·lació;
- problemes amb les actualitzacions;
- riscos de seguretat.

Els permisos **755** per als directoris i **644** per als fitxers són els més habituals en servidors Linux.

---

## ✅ Comprovació

Executa:

```bash
ls -la /var/www/html
```

Comprova que el propietari és **www-data**.

![Permisos dels fitxers](imatges/10-permissions.png)
---

# 📝 Pas 6 · Finalitzar la instal·lació

Ja tenim WordPress preparat.

Ara només queda completar l'assistent d'instal·lació des del navegador.

## 6.1 Accedir al lloc web

Obri el navegador i accedeix a la IP pública o al nom de domini del teu servidor.

Per exemple:

```text
https://IP-publica
```

o bé

```text
https://nom-del-domini
```

Si tot és correcte apareixerà l'assistent d'instal·lació de WordPress.

![Pantalla inicial de WordPress](imatges/11-installation.png)

---

## 6.2 Configurar el lloc web

Completa les dades de configuració inicial:

- Nom del lloc web.
- Nom d'usuari administrador.
- Contrasenya.
- Correu electrònic.
- Idioma.

Quan hages revisat totes les dades, prem **Instal·la WordPress**.

---

## 6.3 Iniciar sessió

Una vegada finalitzada la instal·lació, accedeix al panell d'administració.

```text
https://IP-publica/wp-admin
```

o bé

```text
https://nom-del-domini/wp-admin
```

Introduïx les credencials creades durant la instal·lació.

![Panell d'administració de WordPress](imatges/12-dashboard.png)

---

## ✅ Comprovació

La instal·lació s'ha completat correctament si:

- pots iniciar sessió al panell d'administració;
- no apareix cap missatge d'error;
- pots visualitzar tant el tauler d'administració com la pàgina principal del lloc web.
---

# 📝 Pas 7 · Configurar els enllaços permanents

Una vegada instal·lat WordPress configurarem els **enllaços permanents**.

Aquest tipus d'URL són més llegibles, més fàcils de compartir i milloren el posicionament en cercadors.

---

## 7.1 Accedir a la configuració

Des del panell d'administració ves a:

**Ajustos → Enllaços permanents**

---

## 7.2 Configurar els enllaços permanents

Selecciona l'opció:

**Nom de l'entrada**

Finalment, prem **Desa els canvis**.

![Configuració dels enllaços permanents](imatges/13-permalinks.png)

---

## 💡 Per què és recomanable?

Els enllaços permanents:

- són més fàcils de llegir;
- faciliten compartir contingut;
- milloren el posicionament SEO;
- ofereixen una estructura més professional.

Per exemple:

✅

```text
https://porconstech.com/serveis/
```

❌

```text
https://porconstech.com/?page_id=25
```

---

## ✅ Comprovació

Accedeix a qualsevol pàgina o entrada del teu lloc web.

Comprova que la URL utilitza el format **Nom de l'entrada** i no mostra paràmetres com `?p=123`.

---

# 📝 Pas 8 · Tasques PorçonsTech

A més de completar la instal·lació de WordPress, hauràs de demostrar que comprens què és un gestor de continguts i justificar les decisions tècniques adoptades durant aquest Sprint.

Aquestes activitats formaran part de la documentació del projecte i seran avaluades.

---

## Activitat 1 · Què és un CMS?

Explica amb les teues paraules:

- Què és un gestor de continguts (CMS).
- Quins avantatges ofereix respecte a una pàgina web desenvolupada completament des de zero.

> **Extensió orientativa:** entre 5 i 10 línies.

---

## Activitat 2 · Comparativa de gestors de continguts

Completa la taula següent.

| Característica | WordPress | Joomla | Drupal |
|---------------|-----------|---------|---------|
| Facilitat d'ús | | | |
| Comunitat | | | |
| Plugins / Extensions | | | |
| Dificultat d'administració | | | |
| Casos d'ús habituals | | | |

Finalitza indicant quin gestor de continguts consideres més adequat per al portal corporatiu de **PorçonsTech** i justifica la resposta.

---

## Activitat 3 · Arquitectura de la solució

Explica breument com es comuniquen els següents components durant el funcionament de WordPress.

```text
Navegador
      │
      ▼
Apache
      │
      ▼
PHP
      │
      ▼
MariaDB
```

Descriu la funció de cadascun d'ells.

---

## Activitat 4 · Reflexió tècnica

Respon les preguntes següents:

- Per què WordPress necessita una base de dades?
- Quina funció té el fitxer `wp-config.php`?
- Per què és important configurar les *Security Keys*?
- Per què és recomanable utilitzar un usuari específic de MariaDB en lloc de `root`?

---

## 🎯 Competències treballades

Amb aquestes activitats demostraràs que eres capaç de:

- comprendre el funcionament d'un gestor de continguts;
- justificar les decisions tècniques adoptades;
- interpretar l'arquitectura d'una aplicació web;
- documentar correctament una implantació professional.


---
---

# ✅ Checklist

Abans de donar aquest Sprint per finalitzat comprova que:

## Infraestructura

- [ ] El servidor continua funcionant correctament.
- [ ] Apache està operatiu.
- [ ] MariaDB està operativa.
- [ ] PHP funciona correctament.

---

## Implantació de WordPress

- [ ] WordPress està instal·lat.
- [ ] La base de dades està creada.
- [ ] L'usuari de MariaDB està configurat.
- [ ] `wp-config.php` està correctament configurat.
- [ ] Les Security Keys s'han actualitzat.
- [ ] Els permisos dels fitxers són correctes.

---

## Funcionament

- [ ] L'assistent d'instal·lació s'ha completat.
- [ ] Es pot iniciar sessió a `/wp-admin`.
- [ ] Els enllaços permanents estan configurats.

---

## Documentació

- [ ] Les captures estan incorporades.
- [ ] El README està complet.
- [ ] El repositori GitHub està actualitzat.
- [ ] S'ha realitzat l'últim commit.


Durant aquest Sprint es treballen els següents **criteris d'avaluació** del **RA2 - Implantació de gestors de continguts**:

Sprint1

| CE | Descripció |
|----|------------|
| **RA2.a** | Identifica la utilitat dels gestors de continguts i les seues aplicacions. |
| **RA2.b** | Diferencia els principals gestors de continguts existents i les seues característiques. |
| **RA2.c** | Instal·la i configura un gestor de continguts sobre una infraestructura web existent. |
| **RA2.d** | Identifica els components necessaris per al funcionament del gestor de continguts. |
| **RA2.e** | Configura els paràmetres bàsics del gestor de continguts. |
| **RA2.f** | Aplica configuracions bàsiques de seguretat durant la implantació del gestor de continguts. |
| **RA2.g** | Comprova el correcte funcionament del gestor de continguts una vegada implantat. |
| **RA2.h** | Documenta el procés d'implantació i verifica el funcionament del lloc web. |

