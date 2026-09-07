# 🧱 Sprint 1 · Arquitectura de dues capes + automatització Bash

## 0. Què construirem?

Fins ara has treballat amb diversos serveis en una mateixa màquina. En aquest Sprint separarem la capa web i la base de dades.

```text
                         AWS

                ┌─────────────────┐
Internet ──────►│ porconstech-web │
 HTTP 80        │ Apache + PHP    │
                └────────┬────────┘
                         │
                         │ IP privada
                         │ TCP 3306
                         ▼
                ┌─────────────────┐
                │ porconstech-db  │
                │ MySQL         │
                └─────────────────┘
```

La base de dades **no estarà oberta a Internet**. El port 3306 només acceptarà trànsit procedent del servidor WEB.

> 🎯 Objectiu del Sprint: entendre la comunicació WEB → BD i automatitzar el desplegament amb Bash.

---

# 1. Abans de començar

Necessites:

- accés a AWS Academy;
- una clau SSH que pugues utilitzar amb les dues instàncies;
- Git;
- un editor de text;
- els fitxers de la carpeta `scripts/`.

Treballarem amb una imatge **Ubuntu Server LTS disponible en AWS Academy**.

## 1.1. Identifica els SGBD

Completa aquesta taula amb una frase molt breu:

| SGBD | Relacional? | L'has utilitzat abans? |
|---|---|---|
| MySQL | | |
| MySQL | | |
| PostgreSQL | | |

En aquest projecte utilitzarem **MySQL**.

**Pregunta:** per què una aplicació web necessita un SGBD?

---

# 2. Crear els grups de seguretat

Crearem dos grups de seguretat diferents.

## 2.1. `sg-web`

Crea:

```text
Nom: sg-web
```

Regles d'entrada:

| Tipus | Port | Origen |
|---|---:|---|
| SSH | 22 | My IP |
| HTTP | 80 | Anywhere IPv4 |

> Si la teua IP pública canvia i deixes de poder connectar per SSH, actualitza la regla `My IP`.

## 2.2. `sg-db`

Crea:

```text
Nom: sg-db
```

Regles d'entrada:

| Tipus | Port | Origen |
|---|---:|---|
| SSH | 22 | My IP |
| MYSQL/Aurora o Custom TCP | 3306 | `sg-web` |

### 🧠 Què significa?

La regla del port `3306` no diu «accepta connexions des de qualsevol lloc».

Diu:

> accepta connexions des de les instàncies associades a `sg-web`.

Així el servidor WEB podrà parlar amb la BD mitjançant la seua **IP privada**.

### ✅ Comprovació 1

Abans de continuar:

- [ ] Existeix `sg-web`.
- [ ] Existeix `sg-db`.
- [ ] `sg-db` **no** té el port 3306 obert a `0.0.0.0/0`.

📸 **Evidència 1:** captura de les regles d'entrada de `sg-web` i `sg-db`.

---

# 3. Crear les dues instàncies EC2

Crea dues instàncies en la **mateixa VPC**.

## 3.1. Servidor WEB

```text
Nom: porconstech-web
SO: Ubuntu Server LTS
Tipus: el permés/recomanat en AWS Academy
Security Group: sg-web
```

## 3.2. Servidor BD

```text
Nom: porconstech-db
SO: Ubuntu Server LTS
Tipus: el permés/recomanat en AWS Academy
Security Group: sg-db
```

Utilitza la mateixa clau SSH si és possible.

## 3.3. Anota les adreces

Completa:

```text
WEB_PUBLIC_IP=
WEB_PRIVATE_IP=
DB_PRIVATE_IP=
```

> ⚠️ Per connectar PHP amb MySQL utilitzarem **DB_PRIVATE_IP**, no la IP pública.

### ✅ Comprovació 2

- [ ] Les dues instàncies estan en estat `Running`.
- [ ] Les dues estan en la mateixa VPC.
- [ ] Coneixes la IP privada de cada instància.
- [ ] Pots connectar per SSH a les dues.

Exemple:

```bash
ssh -i clau.pem ubuntu@IP_PUBLICA
```

---

# 4. Preparar les variables del desplegament

En la carpeta `scripts/` tens:

```text
.env.example
.gitignore
install_backend.sh
install_frontend.sh
deploy_app.sh
```

## 4.1. Crea `.env`

Fes una còpia:

```bash
cp .env.example .env
```

Edita `.env`:

```bash
nano .env
```

Exemple:

```bash
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASSWORD=CanviaAquestaContrasenya2026
WEB_PRIVATE_IP=172.31.X.X
DB_PRIVATE_IP=172.31.X.X
APP_REPO=https://github.com/josejuansanchez/iaw-practica-lamp.git
```

Substitueix les IP per les teues.

> ⚠️ En aquesta pràctica evita utilitzar una cometa simple `'` dins de `DB_PASSWORD`, perquè la variable s'utilitzarà també en una sentència SQL del script.

## 4.2. No publiques secrets

Comprova el contingut de `.gitignore`:

```bash
cat .gitignore
```

Ha d'incloure:

```text
.env
```

Per tant:

```text
.env.example  → sí que pot estar en GitHub
.env          → NO s'ha de pujar a GitHub
```

### 🧠 Pensa

Quina informació sensible conté `.env`?

---

# 5. Entendre l'automatització abans d'executar-la

En aquest Sprint **no executarem scripts sense mirar-los**.

Primer els llegirem.

Visualitza:

```bash
cat install_backend.sh
cat install_frontend.sh
cat deploy_app.sh
```

Localitza en els scripts:

- `apt update`;
- instal·lació de paquets;
- `systemctl`;
- `bind-address`;
- creació de la base de dades;
- creació de l'usuari;
- `GRANT`;
- instal·lació d'Apache/PHP;
- clonació del repositori;
- modificació de `config.php`.

## 5.1. Tres scripts, tres responsabilitats

```text
install_backend.sh
└── prepara MySQL

install_frontend.sh
└── prepara Apache + PHP

deploy_app.sh
└── desplega i configura l'aplicació
```

**Pregunta:** per què pot ser útil separar instal·lació i desplegament en scripts diferents?

---

# 6. Preparar el servidor BD

Connecta't a:

```text
porconstech-db
```

## 6.1. Copia els fitxers necessaris

Al servidor BD necessites:

```text
.env
install_backend.sh
```

Pots copiar-los amb `scp` des del teu equip:

```bash
scp -i clau.pem .env install_backend.sh ubuntu@IP_PUBLICA_DB:/home/ubuntu/
```

> Si el servidor BD no té IP pública, utilitza el mètode d'accés que indique la professora dins del laboratori AWS.

## 6.2. Dona permís d'execució

En el servidor BD:

```bash
chmod +x install_backend.sh
```

## 6.3. Executa

```bash
./install_backend.sh
```

El script:

1. actualitza els repositoris;
2. instal·la MySQL i Git;
3. arranca MySQL;
4. configura `bind-address` amb la IP privada del servidor BD;
5. crea `lamp_db`;
6. crea `lamp_user` restringit a la IP privada del servidor WEB;
7. assigna permisos sobre `lamp_db`;
8. importa les dades inicials de l'aplicació.

---

# 7. Comprovar MySQL

No continues fins que aquestes comprovacions funcionen.

## 7.1. Servei actiu

```bash
sudo systemctl status mysql --no-pager
```

Has de veure:

```text
active (running)
```

## 7.2. Port 3306

```bash
sudo ss -ltnp | grep 3306
```

Has de veure MySQL escoltant en la IP configurada.

## 7.3. Base de dades

```bash
sudo mysql
```

Executa:

```sql
SHOW DATABASES;
```

Ha d'aparéixer:

```text
lamp_db
```

Comprova l'usuari:

```sql
SELECT User, Host
FROM mysql.user
WHERE User='lamp_user';
```

El `Host` ha de correspondre a la **IP privada del servidor WEB**.

Ix:

```sql
EXIT;
```

### ✅ Comprovació 3

- [ ] MySQL està actiu.
- [ ] `lamp_db` existeix.
- [ ] `lamp_user` existeix.
- [ ] `lamp_user` està restringit al servidor WEB.
- [ ] MySQL escolta en el port 3306.

📸 **Evidència 2:** `SHOW DATABASES;` i la consulta `User, Host`.

---

# 8. Preparar el servidor WEB

Connecta't a:

```text
porconstech-web
```

Copia:

```text
.env
install_frontend.sh
deploy_app.sh
```

Exemple:

```bash
scp -i clau.pem .env install_frontend.sh deploy_app.sh ubuntu@WEB_PUBLIC_IP:/home/ubuntu/
```

## 8.1. Permisos

```bash
chmod +x install_frontend.sh deploy_app.sh
```

## 8.2. Instal·la el frontend

```bash
./install_frontend.sh
```

El script instal·larà:

- Apache;
- PHP;
- mòdul PHP per a MySQL;
- client de MySQL;
- Git;
- utilitats de xarxa.

---

# 9. Comprovar Apache i PHP

## 9.1. Apache

```bash
sudo systemctl status apache2 --no-pager
```

Ha de mostrar:

```text
active (running)
```

## 9.2. PHP

```bash
php -v
```

## 9.3. Navegador

Obri:

```text
http://WEB_PUBLIC_IP
```

Abans de desplegar l'aplicació és suficient que el servidor responga per HTTP.

### ✅ Comprovació 4

- [ ] Apache està actiu.
- [ ] PHP està instal·lat.
- [ ] El port 80 respon.

---

# 10. Provar WEB → BD abans de desplegar

Aquest pas és molt important.

Des del **servidor WEB**:

```bash
nc -vz DB_PRIVATE_IP 3306
```

Substitueix `DB_PRIVATE_IP`.

Si la xarxa està bé, la connexió al port ha de ser possible.

Ara prova MySQL:

```bash
mysql -h DB_PRIVATE_IP -u lamp_user -p lamp_db
```

Escriu la contrasenya de `.env`.

Una vegada dins:

```sql
SHOW TABLES;
```

Ix:

```sql
EXIT;
```

### ✅ Comprovació 5

Si aquesta prova funciona, ja sabem que:

```text
WEB
 │
 └──────── TCP 3306 ────────► BD
```

funciona **abans** de posar PHP pel mig.

📸 **Evidència 3:** connexió remota a MySQL des del WEB i resultat de `SHOW TABLES;`.

---

# 11. Desplegar l'aplicació

En el servidor WEB:

```bash
./deploy_app.sh
```

Aquest script:

1. clona el repositori de l'aplicació;
2. copia `src/` al directori publicat per Apache;
3. modifica `config.php`;
4. configura:

```text
DB_HOST     → IP privada del servidor BD
DB_NAME     → lamp_db
DB_USER     → lamp_user
DB_PASSWORD → la teua contrasenya
```

## 11.1. Comprova `config.php`

```bash
grep "DB_" /var/www/html/config.php
```

> ⚠️ No publiques una captura on es veja la contrasenya.

Has de comprovar sobretot que:

```text
DB_HOST != localhost
```

En aquesta arquitectura:

```text
DB_HOST = DB_PRIVATE_IP
```

### 🧠 Pregunta clau

Per què `localhost` ja no és correcte?

---

# 12. Comprovar l'aplicació

Obri:

```text
http://WEB_PUBLIC_IP
```

L'aplicació de pràctiques permet realitzar un CRUD.

Has de comprovar:

## CREATE

Crea un registre.

## READ

Comprova que apareix en la llista.

## UPDATE

Edita el registre.

## DELETE

Elimina'l.

### ✅ Comprovació 6

- [ ] La pàgina carrega.
- [ ] CREATE funciona.
- [ ] READ funciona.
- [ ] UPDATE funciona.
- [ ] DELETE funciona.
- [ ] Després de recarregar la pàgina, els canvis continuen existint.

📸 **Evidència 4:** aplicació funcionant i una evidència del CRUD.

---

# 13. Comprovar que la BD no està oberta a Internet

Revisa de nou `sg-db`.

El port 3306 ha de tindre com a origen:

```text
sg-web
```

i **no**:

```text
0.0.0.0/0
```

A més, l'usuari de MySQL s'ha creat com:

```text
'lamp_user'@'WEB_PRIVATE_IP'
```

Per tant tenim dues mesures:

```text
AWS Security Group
        +
usuari/host de MySQL
```

### 🧠 Pregunta

Què protegeix cadascuna?

---

# 14. Diagnòstic d'errors

Si l'aplicació no funciona, **no canvies coses a l'atzar**.

Segueix aquest ordre.

## PAS 1 · Les dues EC2 estan en execució?

Comprova AWS.

## PAS 2 · MySQL funciona?

En BD:

```bash
sudo systemctl status mysql --no-pager
```

## PAS 3 · MySQL escolta en 3306?

En BD:

```bash
sudo ss -ltnp | grep 3306
```

## PAS 4 · `sg-db` permet WEB → 3306?

Revisa AWS.

## PAS 5 · El WEB arriba al port?

En WEB:

```bash
nc -vz DB_PRIVATE_IP 3306
```

## PAS 6 · L'usuari pot connectar?

En WEB:

```bash
mysql -h DB_PRIVATE_IP -u lamp_user -p lamp_db
```

## PAS 7 · `config.php` té les dades correctes?

En WEB:

```bash
grep "DB_" /var/www/html/config.php
```

## PAS 8 · Apache funciona?

```bash
sudo systemctl status apache2 --no-pager
```

### Regla

```text
EC2
 ↓
servei
 ↓
port
 ↓
Security Group
 ↓
usuari BD
 ↓
config.php
 ↓
aplicació
```

Comprova de baix nivell a alt nivell.

---

# 15. Llegir els scripts després d'executar-los

Ara que la infraestructura funciona, torna a obrir els scripts.

## `install_backend.sh`

Identifica la línia que:

- instal·la MySQL;
- canvia `bind-address`;
- crea la BD;
- crea l'usuari;
- concedeix permisos;
- importa `database.sql`.

## `install_frontend.sh`

Identifica la línia que:

- instal·la Apache;
- instal·la PHP;
- instal·la el connector PHP-MySQL;
- arranca Apache.

## `deploy_app.sh`

Identifica la línia que:

- clona l'aplicació;
- copia `src`;
- substitueix `DB_HOST`;
- deixa els fitxers editables per l'usuari `ubuntu`.

> Aquesta última decisió serà útil en el Sprint 3, quan modificarem el codi PHP.

---

# 16. Modificació mínima de Bash

Fes **una única modificació** en un dels scripts.

Afig al final un missatge com:

```bash
echo "✅ PorçonsTech: desplegament completat"
```

o:

```bash
echo "Servidor configurat: $(hostname)"
```

### 🧠 Pregunta

Quin avantatge té que un script puga executar-se més d'una vegada sense deixar el sistema en un estat incorrecte?

---

# 17. Evidències del Sprint

Entrega un document breu amb:

1. arquitectura final WEB → BD;
2. regles de `sg-web` i `sg-db`;
3. IP privada de WEB i BD;
4. comprovació de MySQL;
5. connexió remota des del WEB;
6. `DB_HOST` correcte **sense mostrar la contrasenya**;
7. CRUD funcionant;
8. scripts Bash utilitzats;
9. modificació mínima realitzada;
10. incidència trobada i com l'has diagnosticada, si n'hi ha hagut.

> No cal fer una captura de cada ordre. Les evidències han de demostrar que el sistema funciona i que entens les decisions importants.

---

# 18. Preguntes finals

Respon de manera breu.

### 1.
Quina funció té el servidor WEB?

### 2.
Quina funció té el servidor BD?

### 3.
Per què utilitzem les IP privades per comunicar WEB i BD?

### 4.
Per què MySQL no pot quedar limitat a `127.0.0.1`?

### 5.
Per què `DB_HOST` ja no és `localhost`?

### 6.
Què impedeix que qualsevol màquina d'Internet es connecte al port 3306?

### 7.
Quina diferència hi ha entre `DB_USER` i l'usuari `ubuntu` del servidor?

### 8.
Per què `.env` no s'ha de pujar a GitHub?

### 9.
Quina diferència hi ha entre `install_frontend.sh` i `deploy_app.sh`?

### 10.
Quina comprovació faries primer si PHP mostra un error de connexió amb la BD?

---

# ✅ Checklist final

- [ ] He creat `sg-web`.
- [ ] He creat `sg-db`.
- [ ] El port 3306 només accepta trànsit de `sg-web`.
- [ ] He creat `porconstech-web`.
- [ ] He creat `porconstech-db`.
- [ ] He anotat les IP privades.
- [ ] He creat `.env` sense publicar-lo.
- [ ] MySQL està actiu.
- [ ] `lamp_db` existeix.
- [ ] `lamp_user` està restringit al WEB.
- [ ] Apache està actiu.
- [ ] PHP està instal·lat.
- [ ] WEB pot connectar amb BD.
- [ ] `DB_HOST` utilitza la IP privada de BD.
- [ ] El CRUD funciona.
- [ ] He revisat els scripts Bash.
- [ ] He realitzat una modificació mínima.
- [ ] He contestat les preguntes finals.

---

# 🏁 Sprint completat

Has passat de:

```text
WEB + BD en una mateixa màquina
```

a:

```text
WEB ───────── BD
```

i has automatitzat el procés amb Bash.

En el pròxim Sprint desplegarem **la mateixa aplicació** amb Docker i Docker Compose.

---

## Fonts i atribució

Pràctica adaptada a partir de la pràctica d'arquitectura LAMP en dos nivells del curs *Implantación de Aplicaciones Web* de José Juan Sánchez Hernández, distribuïda sota llicència CC BY-NC-SA 4.0.

També s'han tingut en compte la documentació oficial d'AWS sobre Security Groups, la documentació oficial de MySQL sobre connexions remotes i la documentació d'Ubuntu Server sobre PHP.
