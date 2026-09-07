# 🐳 Sprint 2 · Docker + Docker Compose

## 0. Què construirem?

En el Sprint 1 l'aplicació estava distribuïda entre dues màquines:

```text
EC2 WEB ───────── EC2 BD
Apache + PHP       MySQL
```

Ara desplegarem **la mateixa aplicació** en una única EC2, però separant els components en contenidors.

```text
                          Internet
                              │
                              ▼
                    EC2 porconstech-docker
                              │
                 ┌────────────┴────────────┐
                 │      Docker Compose     │
                 │                         │
                 │  ┌───────────────────┐  │
        :80 ─────┼─►│ app               │  │
                 │  │ Apache + PHP      │  │
                 │  └─────────┬─────────┘  │
                 │            │            │
                 │     backend-network     │
                 │            │            │
                 │  ┌─────────▼─────────┐  │
                 │  │ mysql             │  │
                 │  │ MySQL 8.4         │  │
                 │  └───────────────────┘  │
                 │            ▲            │
                 │            │            │
        :8080 ───┼─► phpMyAdmin ──────────┘
                 │
                 └─────────────────────────┘
```

### Idea clau

En Docker, l'aplicació **no es connectarà a `localhost`**.

Es connectarà a:

```text
mysql
```

perquè `mysql` serà el **nom del servei** de la base de dades dins de Docker Compose.

---

# 1. Crear una EC2 per a Docker

Crea una nova instància.

```text
Nom: porconstech-docker
SO: Ubuntu Server LTS
Tipus: el permés/recomanat en AWS Academy
```

Utilitzarem una màquina nova perquè pugues comparar el resultat del Sprint 1 amb el desplegament Docker sense destruir l'arquitectura anterior.

## 1.1. Security Group

Crea o associa un grup de seguretat amb:

| Tipus | Port | Origen |
|---|---:|---|
| SSH | 22 | My IP |
| HTTP | 80 | Anywhere IPv4 |
| Custom TCP | 8080 | My IP |

### 🧠 Per què 8080 només des de `My IP`?

El port 8080 serà per a **phpMyAdmin**, una eina d'administració. No necessitem deixar-la oberta a tot Internet.

> ⚠️ No obris el port `3306` en AWS. El contenidor MySQL no publicarà eixe port en l'host.

### ✅ Comprovació 1

- [ ] La instància està `Running`.
- [ ] Pots connectar per SSH.
- [ ] El port 80 està permés.
- [ ] El port 8080 només està permés des de la teua IP.
- [ ] No has obert el port 3306.

---

# 2. Instal·lar Docker Engine

Connecta't per SSH:

```bash
ssh -i clau.pem ubuntu@IP_PUBLICA
```

Utilitzarem el repositori oficial de Docker.

## 2.1. Eliminar paquets que puguen entrar en conflicte

```bash
sudo apt remove -y docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc
```

Si algun paquet no estava instal·lat, no passa res.

## 2.2. Preparar el repositori oficial

Actualitza els paquets:

```bash
sudo apt update
```

Instal·la les eines necessàries:

```bash
sudo apt install -y ca-certificates curl
```

Crea el directori per a la clau:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Descarrega la clau oficial:

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
```

Dona permisos de lectura:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Afig el repositori:

```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

Actualitza:

```bash
sudo apt update
```

## 2.3. Instal·lar Docker i Compose

```bash
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

---

# 3. Comprovar Docker

## 3.1. Servei

```bash
sudo systemctl status docker --no-pager
```

Ha de mostrar:

```text
active (running)
```

## 3.2. Versió

```bash
sudo docker version
```

## 3.3. Docker Compose

```bash
sudo docker compose version
```

> 💡 Utilitzarem `docker compose` amb espai. No l'antic executable independent `docker-compose`.

## 3.4. Primer contenidor

```bash
sudo docker run --rm hello-world
```

Si apareix el missatge de confirmació de Docker, la instal·lació és correcta.

### ✅ Comprovació 2

- [ ] Docker està actiu.
- [ ] `docker version` respon.
- [ ] `docker compose version` respon.
- [ ] `hello-world` funciona.

📸 **Evidència 1:** versions de Docker i Docker Compose.

---

# 4. Permetre que `ubuntu` utilitze Docker

Per no haver d'escriure `sudo` en totes les ordres:

```bash
sudo usermod -aG docker ubuntu
```

Tanca la sessió SSH:

```bash
exit
```

i torna a connectar.

Comprova:

```bash
docker ps
```

> ⚠️ El canvi de grup no s'aplica a la sessió SSH que ja estava oberta.

---

# 5. Preparar la carpeta del projecte

Crea:

```bash
mkdir -p ~/porconstech-docker
cd ~/porconstech-docker
```

Copia dins d'aquesta carpeta el contingut de la carpeta `docker/` proporcionada en el Sprint.

Hauries de tindre:

```text
porconstech-docker/
├── Dockerfile
├── compose.yaml
├── .env.example
├── .gitignore
└── prepare_app.sh
```

Dona permís al script:

```bash
chmod +x prepare_app.sh
```

Abans d'executar-lo, llig-lo:

```bash
cat prepare_app.sh
```

Executa:

```bash
./prepare_app.sh
```

El resultat serà:

```text
porconstech-docker/
├── app/
│   ├── config.php
│   ├── index.php
│   └── ...
├── sql/
│   └── database.sql
├── Dockerfile
├── compose.yaml
├── .env.example
├── .gitignore
└── prepare_app.sh
```

El script **no redistribueix l'aplicació**: descarrega una còpia de treball des del repositori original.

### ✅ Comprovació 3

```bash
ls app
```

i:

```bash
ls sql
```

Has de veure el codi PHP i `database.sql`.

---

# 6. Analitzar el Dockerfile

Visualitza:

```bash
cat Dockerfile
```

El fitxer és:

```dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
       apache2 \
       php \
       libapache2-mod-php \
       php-mysql \
       mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /var/www/html/index.html

COPY app/ /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
```

## 6.1. Què fa cada instrucció?

Completa:

| Instrucció | Funció |
|---|---|
| `FROM` | |
| `RUN` | |
| `COPY` | |
| `EXPOSE` | |
| `CMD` | |

### 🧠 Idea important

El `Dockerfile` **crea la imatge de l'aplicació**.

Encara no crea MySQL ni phpMyAdmin.

---

# 7. Modificar `config.php`

En el Sprint 1 teníem:

```text
DB_HOST = IP privada del servidor BD
```

Ara no volem posar secrets ni adreces directament dins del codi.

Obri:

```bash
nano app/config.php
```

Localitza la configuració de la BD.

Substitueix les constants de connexió per:

```php
define('DB_HOST', getenv('DB_HOST'));
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));

$mysqli = mysqli_connect(
    DB_HOST,
    DB_USER,
    DB_PASSWORD,
    DB_NAME
);
```

Guarda.

### 🧠 Què ha canviat?

Ara PHP obtindrà la configuració de **variables d'entorn del contenidor**.

No deixarem la contrasenya escrita directament en `config.php`.

### ✅ Comprovació 4

```bash
grep "DB_" app/config.php
```

Has de veure `getenv(...)`.

---

# 8. Preparar `.env`

Copia:

```bash
cp .env.example .env
```

Obri:

```bash
nano .env
```

Exemple:

```env
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASSWORD=CanviaAquestaContrasenya2026
DB_ROOT_PASSWORD=CanviaTambéRoot2026
```

No utilitzes aquestes contrasenyes literals: crea les teues.

Comprova:

```bash
cat .gitignore
```

Ha d'incloure:

```text
.env
```

### ✅ Comprovació 5

- [ ] `.env` existeix.
- [ ] `.env` conté les quatre variables.
- [ ] `.env` està en `.gitignore`.

---

# 9. Analitzar `compose.yaml`

Visualitza:

```bash
cat compose.yaml
```

El projecte té tres serveis:

```text
app
mysql
phpmyadmin
```

i dues xarxes:

```text
frontend-network
backend-network
```

## 9.1. `app`

```text
app
├── es construeix amb el Dockerfile
├── publica 80:80
├── rep les variables DB_...
├── frontend-network
└── backend-network
```

Està en **dues xarxes**:

- frontend, perquè rep peticions web;
- backend, perquè necessita comunicar-se amb MySQL.

## 9.2. `mysql`

```text
mysql
├── image: mysql:8.4
├── NO publica 3306 a l'host
├── usa un volum
├── importa ./sql
└── backend-network
```

## 9.3. `phpmyadmin`

```text
phpmyadmin
├── image: phpmyadmin:5.2.3-apache
├── publica 8080:80
├── PMA_HOST=mysql
├── frontend-network
└── backend-network
```

phpMyAdmin necessita la xarxa backend perquè ha de comunicar-se amb MySQL.

---

# 10. Entendre `DB_HOST=mysql`

En `compose.yaml` existeix un servei:

```yaml
mysql:
```

Docker Compose proporciona resolució de noms dins de la xarxa.

Per això:

```text
app ─────────────► mysql
                   ↑
             nom del servei
```

La configuració és:

```text
DB_HOST=mysql
```

No:

```text
DB_HOST=localhost
```

### 🧠 Compara

| Sprint 1 | Sprint 2 |
|---|---|
| MySQL en altra EC2 | MySQL en altre contenidor |
| `DB_HOST=IP_PRIVADA_BD` | `DB_HOST=mysql` |
| Security Group per 3306 | xarxa Docker backend |
| instal·lació al SO | imatge/contenidor |

---

# 11. Validar la configuració abans d'arrancar

Executa:

```bash
docker compose config
```

Aquesta ordre interpreta el fitxer Compose i les variables.

> ⚠️ La seua eixida pot mostrar els valors substituïts. No publiques captures que mostren contrasenyes.

Si hi ha un error YAML o una variable incorrecta, resol-lo abans de continuar.

---

# 12. Construir i arrancar

Executa:

```bash
docker compose up -d --build
```

La primera vegada tardarà més perquè ha de:

- descarregar imatges;
- construir la imatge `app`;
- crear xarxes;
- crear el volum;
- crear els contenidors;
- inicialitzar MySQL;
- importar `database.sql`.

---

# 13. Comprovar els contenidors

Executa:

```bash
docker compose ps
```

Hauries de veure:

```text
app
mysql
phpmyadmin
```

en execució.

Comprova també:

```bash
docker ps
```

### Si MySQL encara està arrancant

Espera uns segons i repeteix:

```bash
docker compose ps
```

La configuració inclou un `healthcheck` i `app` espera que MySQL estiga preparat.

### ✅ Comprovació 6

- [ ] `app` està actiu.
- [ ] `mysql` està actiu i saludable.
- [ ] `phpmyadmin` està actiu.

📸 **Evidència 2:** `docker compose ps`.

---

# 14. Comprovar els logs

Mostra:

```bash
docker compose logs --tail=30
```

Per veure només MySQL:

```bash
docker compose logs mysql --tail=30
```

Per veure l'aplicació:

```bash
docker compose logs app --tail=30
```

### 🧠 Per què són útils?

Amb contenidors, els logs són una de les primeres eines de diagnòstic.

---

# 15. Comprovar la comunicació APP → MySQL

Entra al contenidor de l'aplicació:

```bash
docker compose exec app bash
```

Des de dins:

```bash
mysql -h mysql -u lamp_user -p lamp_db
```

Escriu la contrasenya de `.env`.

En MySQL:

```sql
SHOW TABLES;
```

Després:

```sql
EXIT;
```

i ix del contenidor:

```bash
exit
```

### ✅ Comprovació 7

Aquesta prova demostra:

```text
contenidor app
       │
       │ backend-network
       ▼
contenidor mysql
```

📸 **Evidència 3:** connexió des del contenidor `app` i `SHOW TABLES;`.

---

# 16. Accedir a l'aplicació

Obri:

```text
http://IP_PUBLICA_EC2
```

Ha d'aparéixer l'aplicació PHP.

Si no carrega:

```bash
docker compose logs app --tail=50
```

---

# 17. Provar el CRUD

Comprova:

## CREATE

Crea un registre.

## READ

Comprova que apareix.

## UPDATE

Modifica'l.

## DELETE

Elimina'l.

### ✅ Comprovació 8

- [ ] CREATE funciona.
- [ ] READ funciona.
- [ ] UPDATE funciona.
- [ ] DELETE funciona.

📸 **Evidència 4:** aplicació funcionant i evidència del CRUD.

---

# 18. Accedir a phpMyAdmin

Obri:

```text
http://IP_PUBLICA_EC2:8080
```

Utilitza:

```text
Usuari: lamp_user
Contrasenya: la de DB_PASSWORD
```

El servidor MySQL és:

```text
mysql
```

Comprova:

- base de dades `lamp_db`;
- taules;
- registres creats des de l'aplicació.

> ⚠️ phpMyAdmin és una eina d'administració. Per això el port 8080 només s'ha obert a la teua IP.

---

# 19. Comprovar les xarxes

Executa:

```bash
docker network ls
```

Localitza les xarxes creades pel projecte.

Pots inspeccionar-les amb:

```bash
docker network inspect NOM_XARXA
```

Comprova conceptualment:

```text
frontend-network
├── app
└── phpmyadmin

backend-network
├── app
├── mysql
└── phpmyadmin
```

### 🧠 Pregunta

Per què `mysql` no necessita estar en `frontend-network`?

---

# 20. Comprovar que MySQL no publica el port 3306

Executa:

```bash
docker compose ps
```

En la columna de ports:

- `app` ha de publicar el 80;
- `phpmyadmin` ha de publicar el 8080;
- `mysql` **no** ha de publicar `3306:3306`.

També pots comprovar:

```bash
docker port $(docker compose ps -q mysql)
```

No ha d'aparéixer un port 3306 publicat en l'host.

### ✅ Comprovació 9

MySQL és accessible pels serveis de `backend-network`, però no està exposat directament a Internet.

---

# 21. Comprovar el volum

Executa:

```bash
docker volume ls
```

Localitza el volum de MySQL.

Ara crea un registre nou en l'aplicació i recorda el seu valor.

Para els contenidors:

```bash
docker compose down
```

Torna a arrancar:

```bash
docker compose up -d
```

Obri l'aplicació.

### ✅ Comprovació 10

El registre continua existint.

Això demostra que:

```text
contenidor ≠ dades persistents

MySQL container
       │
       ▼
mysql_data
```

📸 **Evidència 5:** registre existent després de `down` + `up -d`.

---

# 22. Atenció amb `down -v`

Aquesta ordre:

```bash
docker compose down
```

elimina contenidors i xarxes del projecte, però conserva el volum.

En canvi:

```bash
docker compose down -v
```

elimina també els volums.

Per tant, **esborrarà les dades MySQL d'aquesta pràctica**.

A més, els scripts de:

```text
/docker-entrypoint-initdb.d
```

s'executen quan MySQL inicialitza **un directori de dades buit**.

Si canvies `database.sql` però mantens el volum existent, no s'importarà de nou automàticament.

---

# 23. Diagnòstic d'errors

Si l'aplicació no funciona, segueix aquest ordre.

## PAS 1 · Docker funciona?

```bash
systemctl status docker --no-pager
```

## PAS 2 · Compose interpreta el fitxer?

```bash
docker compose config
```

## PAS 3 · Els contenidors estan actius?

```bash
docker compose ps
```

## PAS 4 · Què diuen els logs?

```bash
docker compose logs --tail=50
```

## PAS 5 · MySQL està saludable?

```bash
docker compose ps
```

## PAS 6 · APP arriba a MySQL?

```bash
docker compose exec app \
  mysql -h mysql -u lamp_user -p lamp_db
```

## PAS 7 · PHP rep les variables?

```bash
docker compose exec app printenv | grep '^DB_'
```

> ⚠️ No captures ni publiques `DB_PASSWORD`.

## PAS 8 · `config.php` usa `getenv()`?

```bash
grep "getenv" app/config.php
```

## PAS 9 · Revisa Apache/PHP

```bash
docker compose logs app --tail=50
```

### Regla

```text
Docker
  ↓
Compose
  ↓
contenidors
  ↓
logs
  ↓
xarxes
  ↓
variables
  ↓
MySQL
  ↓
PHP
  ↓
navegador
```

---

# 24. Comparar Sprint 1 i Sprint 2

Completa:

| Aspecte | Sprint 1 | Sprint 2 |
|---|---|---|
| On s'executa Apache? | | |
| On s'executa MySQL? | | |
| Valor de `DB_HOST` | | |
| Com protegim MySQL? | | |
| Com despleguem? | | |
| On persisteixen les dades? | | |

---

# 25. Evidències del Sprint

Entrega evidències de:

1. Docker i Compose instal·lats.
2. `docker compose ps`.
3. connexió APP → MySQL.
4. CRUD funcionant.
5. phpMyAdmin mostrant `lamp_db`.
6. xarxes frontend/backend.
7. comprovació que 3306 no està publicat.
8. volum MySQL.
9. persistència després de `docker compose down` + `up -d`.
10. taula comparativa Sprint 1 / Sprint 2.

> No publiques `.env` ni captures amb contrasenyes.

---

# 26. Preguntes finals

### 1.
Quina diferència hi ha entre una imatge Docker i un contenidor?

### 2.
Quina funció té el `Dockerfile`?

### 3.
Quina funció té `compose.yaml`?

### 4.
Per què `DB_HOST` és `mysql`?

### 5.
Per què `DB_HOST=localhost` no funcionaria en aquesta arquitectura?

### 6.
Per què el servei MySQL no publica el port 3306?

### 7.
Quina funció té `backend-network`?

### 8.
Per què utilitzem un volum per a `/var/lib/mysql`?

### 9.
Quina diferència hi ha entre `docker compose down` i `docker compose down -v`?

### 10.
Quin avantatge aporta `.env` respecte d'escriure les contrasenyes dins de `compose.yaml` o `config.php`?

---

# ✅ Checklist final

- [ ] He creat `porconstech-docker`.
- [ ] Docker Engine funciona.
- [ ] Docker Compose funciona.
- [ ] `hello-world` funciona.
- [ ] He preparat el codi de l'aplicació.
- [ ] Entenc les instruccions principals del Dockerfile.
- [ ] `config.php` utilitza variables d'entorn.
- [ ] `.env` no es publica.
- [ ] `docker compose config` no mostra errors.
- [ ] Els tres serveis estan actius.
- [ ] MySQL està saludable.
- [ ] APP pot connectar amb `mysql`.
- [ ] El CRUD funciona.
- [ ] phpMyAdmin funciona.
- [ ] MySQL no publica el port 3306.
- [ ] He identificat les dues xarxes.
- [ ] He identificat el volum MySQL.
- [ ] Les dades persisteixen després de reiniciar els contenidors.
- [ ] He completat la comparació Sprint 1 / Sprint 2.
- [ ] He contestat les preguntes finals.

---

# 🏁 Sprint completat

Ara has desplegat **la mateixa aplicació** de dues maneres diferents:

```text
Sprint 1
infraestructura tradicional
EC2 WEB ───────── EC2 MySQL

Sprint 2
infraestructura amb contenidors
Docker Compose
├── app
├── mysql
└── phpmyadmin
```

En el Sprint 3 treballarem directament sobre el **codi PHP** de l'aplicació.

---

## Fonts i atribució

Pràctica adaptada a partir de «Dockerizar una aplicación LAMP» del curs *Implantación de Aplicaciones Web* de José Juan Sánchez Hernández, distribuïda sota CC BY-NC-SA 4.0.

Per actualitzar la pràctica s'han utilitzat també la documentació oficial de Docker per a la instal·lació de Docker Engine i Docker Compose, i les imatges oficials de MySQL i phpMyAdmin.
