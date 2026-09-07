# ☁️ Sprint 1 · Implantar Nextcloud

## 🎯 Objectiu

PorçonsTech necessita una plataforma pròpia per compartir fitxers i treballar de manera col·laborativa.

En aquest Sprint implantaràs **Nextcloud** sobre la infraestructura web que ja has creat durant els projectes anteriors.

En acabar hauràs de disposar d'una plataforma que permeta:

- gestionar usuaris;
- compartir fitxers;
- establir diferents permisos;
- treballar de manera cooperativa;
- controlar l'accés als recursos.

---

## ⏱️ Duració

**6-8 hores aproximadament**

---

## 🖥️ Infraestructura

Continuarem utilitzant el servidor de PorçonsTech.

Ja disposes de:

- Ubuntu Server;
- Apache;
- PHP;
- MySQL;
- HTTPS;
- WordPress.

> ⚠️ **No elimines ni substituïsques WordPress.**

Nextcloud s'instal·larà de manera independent:

```text
https://EL_TEU_DOMINI/nextcloud
```

---

## 🧩 Què faràs?

Durant el Sprint:

1. Analitzaràs breument diferents plataformes d'ofimàtica web.
2. Comprovaràs la infraestructura existent.
3. Prepararàs PHP per a Nextcloud.
4. Crearàs una base de dades específica.
5. Instal·laràs Nextcloud.
6. Configuraràs Apache.
7. Completaràs la instal·lació.
8. Crearàs usuaris i grups.
9. Configuraràs compartició i permisos.
10. Comprovaràs el treball cooperatiu.
11. Verificaràs HTTPS i la convivència amb WordPress.
12. Documentaràs el resultat.

---

# 1. Abans de començar

PorçonsTech vol disposar d'una plataforma pròpia per gestionar documentació i compartir fitxers entre els seus treballadors.

Abans d'implantar-la, completa breument aquesta taula:

| Plataforma | Funció principal | On s'allotgen les dades? | Avantatge principal |
|---|---|---|---|
| Nextcloud | | | |
| Google Workspace | | | |
| Microsoft 365 | | | |

### 💭 Reflexiona

Per què pot interessar a una empresa disposar d'una plataforma col·laborativa pròpia?

No necessites realitzar una investigació extensa.  
**3-4 línies són suficients.**

---

# 2. Comprovar el servidor

Connecta't per SSH al servidor de PorçonsTech.

Comprova les versions instal·lades:

```bash
apache2 -v
```

```bash
php -v
```

```bash
mysql --version
```

Comprova també que Apache i MySQL estan funcionant:

```bash
sudo systemctl status apache2
```

```bash
sudo systemctl status mysql
```

> 💡 No estem creant un servidor nou. Estem ampliant la infraestructura de PorçonsTech.

---

# 3. Preparar PHP

Nextcloud necessita alguns mòduls PHP addicionals.

Actualitza la informació dels repositoris:

```bash
sudo apt update
```

Instal·la els mòduls necessaris:

```bash
sudo apt install php-curl php-gd php-mbstring php-intl php-gmp php-xml php-imagick php-zip unzip -y
```

Reinicia Apache:

```bash
sudo systemctl restart apache2
```

Comprova que continua funcionant:

```bash
sudo systemctl status apache2
```

---

# 4. Crear la base de dades

Nextcloud guardarà la seua informació en MySQL.

Abans d'entrar a MySQL i crear la base de dades, configurarem el nivell d'aïllament que necessita Nextcloud.

Edita la configuració de MySQL:

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Dins de la secció `[mysqld]`, comprova o afig:

```ini
transaction_isolation = READ-COMMITTED
binlog_format = ROW
```

Guarda el fitxer i reinicia MySQL:

```bash
sudo systemctl restart mysql
```

Comprova que el servei continua actiu:

```bash
sudo systemctl status mysql
```

Torna a entrar:

```bash
sudo mysql
```

Verifica la configuració:

```sql
SELECT @@transaction_isolation;
SHOW VARIABLES LIKE 'binlog_format';
```

Hauries d'obtindre:

```text
READ-COMMITTED
ROW
```

> 💡 Nextcloud necessita `READ COMMITTED` quan treballa amb MySQL. També requereix que, si s'utilitza binary logging, el format siga `ROW`.

Crea una base de dades:

```sql
CREATE DATABASE nextcloud
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;
```

Crea un usuari específic:

```sql
CREATE USER 'nextcloud_user'@'localhost'
IDENTIFIED BY 'CONTRASENYA_SEGURA';
```

> ⚠️ Substitueix `CONTRASENYA_SEGURA` per una contrasenya pròpia.

Concedeix permisos només sobre la base de dades de Nextcloud:

```sql
GRANT ALL PRIVILEGES
ON nextcloud.*
TO 'nextcloud_user'@'localhost';
```

Aplica els canvis:

```sql
FLUSH PRIVILEGES;
```

Ix de MySQL:

```sql
EXIT;
```

### 💭 Pensa

Per què hem creat un usuari específic per a Nextcloud en lloc d'utilitzar `root`?

---

# 5. Descarregar Nextcloud

Canvia al directori temporal:

```bash
cd /tmp
```

Descarrega l'última versió estable:

```bash
wget https://download.nextcloud.com/server/releases/latest.zip
```

Descomprimeix-la:

```bash
unzip latest.zip
```

Comprova que s'ha creat el directori:

```bash
ls
```

Hauries de veure:

```text
nextcloud
```

Mou-lo a `/var/www`:

```bash
sudo mv /tmp/nextcloud /var/www/nextcloud
```

---

# 6. Configurar els permisos

Apache treballa habitualment amb l'usuari `www-data`.

Assigna-li la instal·lació de Nextcloud:

```bash
sudo chown -R www-data:www-data /var/www/nextcloud
```

Crearem també el directori on s'emmagatzemaran les dades dels usuaris:

```bash
sudo mkdir -p /var/nextcloud-data
```

```bash
sudo chown -R www-data:www-data /var/nextcloud-data
```

```bash
sudo chmod 750 /var/nextcloud-data
```

### 💭 Pensa

Per què és interessant que els fitxers dels usuaris no estiguen dins del directori públic del lloc web?

---

# 7. Configurar Apache

Crearem una configuració específica per a Nextcloud.

```bash
sudo nano /etc/apache2/sites-available/nextcloud.conf
```

Afig:

```apache
Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
        Dav off
    </IfModule>
</Directory>
```

Guarda el fitxer.

Activa la configuració:

```bash
sudo a2ensite nextcloud.conf
```

Activa els mòduls necessaris:

```bash
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime
```

Comprova que la configuració d'Apache és correcta:

```bash
sudo apache2ctl configtest
```

El resultat esperat és:

```text
Syntax OK
```

Reinicia Apache:

```bash
sudo systemctl restart apache2
```

---

# 8. Obrir Nextcloud

Des del navegador accedeix a:

```text
https://EL_TEU_DOMINI/nextcloud
```

Hauria d'aparéixer l'assistent d'instal·lació de Nextcloud.

---

# 9. Completar la instal·lació

Crea el compte administrador.

Per exemple:

```text
admin_porconstech
```

Utilitza una contrasenya segura.

En l'apartat d'emmagatzematge indica:

```text
/var/nextcloud-data
```

Selecciona **MySQL**.

Utilitza:

```text
Usuari: nextcloud_user
Contrasenya: la contrasenya que has creat
Base de dades: nextcloud
Servidor: localhost
```

Completa la instal·lació.

> ⏳ Pot tardar uns minuts.

---

# 10. Comprovació inicial

Quan aparega el panell de Nextcloud comprova:

- [ ] Pots iniciar sessió.
- [ ] Pots veure l'apartat de fitxers.
- [ ] Pots crear una carpeta.
- [ ] Pots pujar un fitxer.
- [ ] Pots tancar sessió i tornar a entrar.

---

# 11. Crear els usuaris de PorçonsTech

Crea aquests tres usuaris de prova:

```text
anna
marc
laura
```

Crea també el grup:

```text
projectes
```

Afig al grup:

```text
anna
marc
```

Deixa `laura` fora del grup.

### Comprovació

Comprova que existeixen:

```text
admin_porconstech
anna
marc
laura
```

---

# 12. Crear l'espai compartit

Inicia sessió com:

```text
anna
```

Crea una carpeta:

```text
Projecte PorçonsTech
```

Dins crea o puja un fitxer:

```text
necessitats.txt
```

Per exemple:

```text
Necessitats inicials del projecte PorçonsTech.
```

Comparteix la carpeta amb:

```text
projectes
```

Permet que els membres del grup puguen modificar el contingut.

---

# 13. Comprovar el treball cooperatiu

Tanca la sessió d'Anna.

Entra com:

```text
marc
```

Comprova que Marc pot:

- veure la carpeta;
- obrir el fitxer;
- afegir un fitxer nou.

Crea:

```text
proposta-marc.txt
```

Torna a iniciar sessió com Anna.

Comprova que pot veure el fitxer creat per Marc.

> ✅ Acabes de comprovar el treball cooperatiu.

---

# 14. Comprovar els permisos

Ara utilitzarem Laura.

Des d'Anna, comparteix:

```text
Projecte PorçonsTech
```

amb:

```text
laura
```

però deixa-li **només permís de lectura**.

Entra com Laura.

Comprova que:

- [ ] Pot veure el contingut.
- [ ] Pot obrir els fitxers.
- [ ] No pot modificar-los.
- [ ] No pot eliminar-los.
- [ ] No pot afegir nous fitxers.

### 💭 Reflexiona

Quina diferència hi ha entre els permisos de Marc i els de Laura?

Per què pot ser útil aquesta diferenciació en una empresa?

---

# 15. Comprovar HTTPS

Observa l'adreça del navegador.

Ha de començar per:

```text
https://
```

Per exemple:

```text
https://el-teu-domini/nextcloud
```

### 💭 Pensa

Per què és especialment important utilitzar HTTPS en una aplicació que conté:

- usuaris;
- contrasenyes;
- documents;
- informació interna?

---

# 16. Comprovar WordPress

Nextcloud s'ha afegit a la infraestructura existent.

Per tant, comprova també que:

```text
https://EL_TEU_DOMINI/
```

continua mostrant el portal WordPress de PorçonsTech.

I que:

```text
https://EL_TEU_DOMINI/nextcloud
```

mostra Nextcloud.

## 🎯 Arquitectura final

```text
                  Internet
                     │
                  HTTPS
                     │
                  Apache
               ┌─────┴─────┐
               │           │
          WordPress     Nextcloud
               │           │
               └─────┬─────┘
                     │
                  MySQL
```

Les dues aplicacions comparteixen la infraestructura del servidor però disposen de les seues pròpies configuracions i dades.

---

# 17. Evidències

Inclou en el teu lliurament evidències que demostren:

1. Nextcloud accessible.
2. Usuaris creats.
3. Grup `projectes`.
4. Carpeta `Projecte PorçonsTech`.
5. Accés de Marc.
6. Accés limitat de Laura.
7. Connexió HTTPS.
8. WordPress continua funcionant.

> No és necessari capturar cada ordre executada.

Les captures han de demostrar **resultats**, no simplement que has escrit comandaments.

---

# 18. Preguntes finals

Respon breument.

### 1. Quina funció té Apache en aquesta infraestructura?

### 2. Per què Nextcloud necessita MySQL?

### 3. Per què utilitzem un usuari de MySQL específic per a Nextcloud?

### 4. Quina diferència existeix entre els permisos de Marc i Laura?

### 5. Quin avantatge aporta HTTPS en aquesta plataforma?

### 6. Quin avantatge pot tindre per a PorçonsTech una plataforma pròpia com Nextcloud?

---

# ✅ Checklist final

Abans d'entregar comprova:

- [ ] WordPress continua funcionant.
- [ ] Nextcloud és accessible.
- [ ] Nextcloud utilitza HTTPS.
- [ ] La base de dades funciona.
- [ ] He creat els tres usuaris.
- [ ] He creat el grup `projectes`.
- [ ] Anna i Marc poden treballar de manera cooperativa.
- [ ] Laura té permisos limitats.
- [ ] He comprovat els accessos amb cada usuari.
- [ ] He documentat les evidències.
- [ ] He contestat les preguntes finals.

---

# 🏁 Sprint completat

PorçonsTech disposa ara de:

**portal corporatiu + plataforma col·laborativa**

Has ampliat la infraestructura existent sense crear un nou servidor i has implantat una aplicació web amb gestió d'usuaris, permisos i treball cooperatiu.
