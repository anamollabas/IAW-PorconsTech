# 🧩 Sprint 3 · Evolució mínima de l'aplicació PHP + MySQL

## 0. Què farem?

Continuarem sobre la infraestructura del **Sprint 2**:

```text
porconstech-docker
└── Docker Compose
    ├── app · Apache + PHP
    ├── mysql · MySQL
    └── phpmyadmin
```

No canviarem l'arquitectura.

Ara modificarem el codi que hi ha en:

```text
~/porconstech-docker/app/
```

Afegirem unes poques pàgines:

```text
app/
├── ... fitxers originals del CRUD ...
├── salutacio.php
├── usuaris.php
├── funcions.php
├── login.php
├── zona.php
├── logout.php
└── setup.php        ← només temporal
```

> 🎯 La idea no és convertir-te en programador/a PHP. La idea és entendre què està fent una aplicació web de servidor i ser capaç de realitzar modificacions controlades.

---

# 1. Comprovar el punt de partida

Connecta't a la EC2 del Sprint 2:

```bash
ssh -i clau.pem ubuntu@IP_PUBLICA
```

Entra en el projecte:

```bash
cd ~/porconstech-docker
```

Comprova:

```bash
docker compose ps
```

Has de tindre actius:

```text
app
mysql
phpmyadmin
```

Obri també:

```text
http://IP_PUBLICA
```

i comprova que el CRUD original funciona.

### ✅ Comprovació 1

- [ ] Els tres serveis estan actius.
- [ ] L'aplicació original es carrega.
- [ ] Pots consultar els registres.

> Si açò no funciona, no comences a modificar PHP encara.

---

# 2. PHP és un llenguatge de servidor

Abans de programar, completa aquesta taula amb una frase breu:

| Tecnologia | Pot executar-se al servidor web? | Exemple d'ús |
|---|---|---|
| PHP | | |
| Python | | |
| JavaScript amb Node.js | | |

En aquest projecte utilitzarem **PHP**.

### Idea clau

Quan el navegador demana:

```text
salutacio.php
```

passa açò:

```text
Navegador
    │ petició HTTP
    ▼
Apache + PHP
    │ executa el codi PHP
    │ genera HTML
    ▼
Navegador
```

El navegador **no necessita rebre el codi PHP original**.

---

# 3. Primera modificació: PHP + HTML

Entra en:

```bash
cd ~/porconstech-docker/app
```

Crea:

```bash
nano salutacio.php
```

Escriu:

```php
<?php

$empresa = 'PorçonsTech';
$hora = (int) date('H');

function salutacio(int $hora): string
{
    if ($hora < 14) {
        return 'Bon dia';
    }

    return 'Bona vesprada';
}

?>
<!doctype html>
<html lang="ca">
<head>
    <meta charset="utf-8">
    <title>PorçonsTech</title>
</head>
<body>
    <h1><?php echo $empresa; ?></h1>

    <p>
        <?php echo salutacio($hora); ?>.
        Aquesta pàgina ha sigut generada amb PHP.
    </p>

    <p>Hora del servidor: <?php echo $hora; ?></p>
</body>
</html>
```

## 3.1. Què acabes d'utilitzar?

Localitza:

```text
$empresa             → variable
$hora                → variable
function salutacio   → funció
if                   → estructura de control
return               → retorna un valor
echo                 → genera contingut
```

A més, en el mateix document conviuen:

```text
PHP + HTML
```

---

# 4. Reconstruir l'aplicació

Recorda que el Dockerfile copia `app/` dins de la imatge.

Torna al directori del projecte:

```bash
cd ~/porconstech-docker
```

Reconstrueix només l'aplicació:

```bash
docker compose up -d --build app
```

Comprova:

```bash
docker compose ps
```

Obri:

```text
http://IP_PUBLICA/salutacio.php
```

### ✅ Comprovació 2

Has de veure:

- `PorçonsTech`;
- una salutació;
- l'hora del servidor.

## 4.1. Mira el codi font des del navegador

Utilitza l'opció del navegador **Veure el codi font de la pàgina**.

Busca:

```text
$empresa
function salutacio
if ($hora < 14)
```

### 🧠 Què observes?

El navegador veu l'HTML resultant, però no el codi PHP que s'ha executat al servidor.

📸 **Evidència 1:** pàgina `salutacio.php` funcionant.

---

# 5. Preparar dos usuaris de prova

Ara afegirem un login molt xicotet.

> ⚠️ Els usuaris següents són **usuaris de l'aplicació**, no usuaris de Linux ni de MySQL.

Crea:

```bash
nano ~/porconstech-docker/app/usuaris.php
```

Copia:

```php
<?php

return [
    'anna' => [
        'nom' => 'Anna',
        'rol' => 'administradora',
        'hash' => '$2y$12$IeLqi1oVY.kBxwU.oMTrzuAYc8ZcQMe9g5Tyd/6cVRie3JKRRNo92'
    ],
    'marc' => [
        'nom' => 'Marc',
        'rol' => 'tecnic',
        'hash' => '$2y$12$S2FGZ4si3YiZ9nCa4AoiLunFRO4cd3DTM80b7s9Y49F2TGTMg/sW.'
    ]
];
```

Per a la pràctica utilitzarem:

```text
anna / Anna2026!
marc / Marc2026!
```

Les contrasenyes **no estan guardades en text pla** en el fitxer: hi ha un hash.

### 🧠 Important

Més avant utilitzarem:

```php
password_verify(...)
```

per comprovar la contrasenya introduïda.

---

# 6. Crear una funció reutilitzable

Crea:

```bash
nano ~/porconstech-docker/app/funcions.php
```

Escriu:

```php
<?php

function neteja(string $valor): string
{
    return htmlspecialchars($valor, ENT_QUOTES, 'UTF-8');
}

function missatge_benvinguda(string $nom, string $rol): string
{
    return "Benvingut/da $nom. El teu rol és $rol.";
}
```

## 6.1. Què tenim?

Dues funcions:

```text
neteja()
missatge_benvinguda()
```

`neteja()` evitarà mostrar directament text sense escapar-lo en l'HTML.

---

# 7. Crear el formulari de login

Crea:

```bash
nano ~/porconstech-docker/app/login.php
```

Escriu:

```php
<?php

session_start();

$usuaris = require 'usuaris.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuari = $_POST['usuari'] ?? '';
    $contrasenya = $_POST['contrasenya'] ?? '';

    if (
        isset($usuaris[$usuari]) &&
        password_verify($contrasenya, $usuaris[$usuari]['hash'])
    ) {
        session_regenerate_id(true);

        $_SESSION['usuari'] = $usuari;
        $_SESSION['nom'] = $usuaris[$usuari]['nom'];
        $_SESSION['rol'] = $usuaris[$usuari]['rol'];

        header('Location: zona.php');
        exit;
    }

    $error = 'Usuari o contrasenya incorrectes.';
}

?>
<!doctype html>
<html lang="ca">
<head>
    <meta charset="utf-8">
    <title>Login · PorçonsTech</title>
</head>
<body>

<h1>Accés a PorçonsTech</h1>

<?php if ($error !== ''): ?>
    <p><?php echo htmlspecialchars($error, ENT_QUOTES, 'UTF-8'); ?></p>
<?php endif; ?>

<form method="post">
    <label>
        Usuari:
        <input type="text" name="usuari" required>
    </label>

    <br><br>

    <label>
        Contrasenya:
        <input type="password" name="contrasenya" required>
    </label>

    <br><br>

    <button type="submit">Entrar</button>
</form>

</body>
</html>
```

## 7.1. Identifica

Localitza:

```text
<form method="post">       → formulari HTML
$_POST                     → dades enviades pel formulari
if                         → decisió
password_verify()          → comprovació de contrasenya
$_SESSION                  → informació que volem conservar
header(...)                → redirecció
```

---

# 8. Crear una pàgina protegida

Crea:

```bash
nano ~/porconstech-docker/app/zona.php
```

Escriu:

```php
<?php

session_start();
require_once 'funcions.php';

if (!isset($_SESSION['usuari'])) {
    header('Location: login.php');
    exit;
}

$nom = neteja($_SESSION['nom']);
$rol = neteja($_SESSION['rol']);

$tasques = [
    'Revisar el desplegament',
    'Comprovar MySQL',
    'Documentar els canvis'
];

?>
<!doctype html>
<html lang="ca">
<head>
    <meta charset="utf-8">
    <title>Zona privada · PorçonsTech</title>
</head>
<body>

<h1>Zona privada</h1>

<p><?php echo missatge_benvinguda($nom, $rol); ?></p>

<?php if ($rol === 'administradora'): ?>
    <p><strong>Opció especial:</strong> pots revisar la configuració general.</p>
<?php else: ?>
    <p>Disposes de les opcions tècniques habituals.</p>
<?php endif; ?>

<h2>Tasques</h2>

<ul>
<?php foreach ($tasques as $tasca): ?>
    <li><?php echo neteja($tasca); ?></li>
<?php endforeach; ?>
</ul>

<p><a href="logout.php">Tancar sessió</a></p>

</body>
</html>
```

## 8.1. Què acabes de treballar?

```text
if / else       → estructura de control
foreach         → repetició
funcions        → codi reutilitzable
$_SESSION       → persistència entre pàgines
```

---

# 9. Crear el logout

Crea:

```bash
nano ~/porconstech-docker/app/logout.php
```

Escriu:

```php
<?php

session_start();

$_SESSION = [];
session_destroy();

header('Location: login.php');
exit;
```

---

# 10. Reconstruir i provar el login

Torna a:

```bash
cd ~/porconstech-docker
```

Executa:

```bash
docker compose up -d --build app
```

Obri directament:

```text
http://IP_PUBLICA/zona.php
```

### ✅ Comprovació 3

Com que encara no has iniciat sessió, t'ha de redirigir a:

```text
/login.php
```

Ara prova una contrasenya incorrecta.

Després entra amb:

```text
anna
Anna2026!
```

Has de veure:

```text
Anna
administradora
```

Tanca sessió i comprova que ja no pots entrar directament a `zona.php`.

📸 **Evidència 2:** login correcte i zona privada d'Anna.

---

# 11. Comprovar sessions independents

Aquesta prova és important.

## Navegador normal

Entra com:

```text
anna
Anna2026!
```

## Finestra d'incògnit o un altre navegador

Entra com:

```text
marc
Marc2026!
```

Comprova al mateix temps:

```text
sessió 1 → Anna / administradora
sessió 2 → Marc / tecnic
```

### 🧠 Què demostra?

Les dues peticions arriben al mateix servidor PHP, però cadascun dels navegadors manté la seua pròpia sessió.

### ✅ Comprovació 4

- [ ] Anna continua identificada com Anna.
- [ ] Marc continua identificat com Marc.
- [ ] El contingut condicionat pel rol és diferent.
- [ ] Una sessió no substitueix l'altra.

📸 **Evidència 3:** dues sessions amb usuaris diferents.

---

# 12. Crear una base de dades i una taula des de PHP

Ara completarem una tasca molt concreta de RA6.

Fins ara les bases de dades s'han creat:

- amb SQL;
- amb scripts d'inicialització;
- o durant el desplegament.

Ara farem que siga **PHP qui execute `CREATE DATABASE` i `CREATE TABLE`**.

## 12.1. Donar temporalment el privilegi necessari

Entra a MySQL com a administrador:

```bash
cd ~/porconstech-docker
docker compose exec mysql mysql -uroot -p
```

Escriu `DB_ROOT_PASSWORD`.

Primer comprova l'usuari:

```sql
SELECT User, Host
FROM mysql.user
WHERE User = 'lamp_user';
```

Anota el valor de `Host`.

En el desplegament Docker habitual serà:

```text
%
```

Si és així, executa:

```sql
GRANT CREATE ON *.* TO 'lamp_user'@'%';
```

Comprova:

```sql
SHOW GRANTS FOR 'lamp_user'@'%';
```

> ⚠️ Si el valor de `Host` és diferent de `%`, utilitza exactament el valor que t'ha mostrat la consulta.

Ix:

```sql
EXIT;
```

### 🧠 Per què el privilegi és temporal?

L'usuari que utilitza una aplicació no ha de conservar més permisos dels que necessita.

---

# 13. Crear `setup.php`

Crea:

```bash
nano ~/porconstech-docker/app/setup.php
```

Escriu:

```php
<?php

require_once 'config.php';

$missatges = [];

$sqlDatabase = "
    CREATE DATABASE IF NOT EXISTS porconstech_demo
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci
";

if (mysqli_query($mysqli, $sqlDatabase)) {
    $missatges[] = 'Base de dades porconstech_demo creada o ja existent.';
} else {
    $missatges[] = 'Error BD: ' . mysqli_error($mysqli);
}

$sqlTable = "
    CREATE TABLE IF NOT EXISTS porconstech_demo.proves_php (
        id INT AUTO_INCREMENT PRIMARY KEY,
        missatge VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
";

if (mysqli_query($mysqli, $sqlTable)) {
    $missatges[] = 'Taula proves_php creada o ja existent.';
} else {
    $missatges[] = 'Error taula: ' . mysqli_error($mysqli);
}

?>
<!doctype html>
<html lang="ca">
<head>
    <meta charset="utf-8">
    <title>Setup PHP</title>
</head>
<body>

<h1>Preparació de la BD des de PHP</h1>

<ul>
<?php foreach ($missatges as $missatge): ?>
    <li><?php echo htmlspecialchars($missatge, ENT_QUOTES, 'UTF-8'); ?></li>
<?php endforeach; ?>
</ul>

</body>
</html>
```

Reconstrueix:

```bash
cd ~/porconstech-docker
docker compose up -d --build app
```

Obri **una sola vegada**:

```text
http://IP_PUBLICA/setup.php
```

### ✅ Comprovació 5

Has de veure dos missatges:

```text
Base de dades porconstech_demo creada o ja existent.
Taula proves_php creada o ja existent.
```

---

# 14. Verificar que PHP ha creat realment els objectes

Entra en MySQL:

```bash
docker compose exec mysql mysql -uroot -p
```

Executa:

```sql
SHOW DATABASES LIKE 'porconstech_demo';
```

Després:

```sql
SHOW TABLES FROM porconstech_demo;
```

Ha d'aparéixer:

```text
proves_php
```

📸 **Evidència 4:** BD i taula creades.

---

# 15. Retirar el privilegi temporal

Encara dins de MySQL:

```sql
REVOKE CREATE ON *.* FROM 'lamp_user'@'%';
```

Comprova:

```sql
SHOW GRANTS FOR 'lamp_user'@'%';
```

> Si el `Host` del teu usuari no era `%`, utilitza el valor correcte també en `REVOKE`.

Ix:

```sql
EXIT;
```

## 15.1. Eliminar `setup.php`

Ja ha complit la seua funció.

```bash
rm ~/porconstech-docker/app/setup.php
```

Reconstrueix:

```bash
cd ~/porconstech-docker
docker compose up -d --build app
```

Comprova:

```text
http://IP_PUBLICA/setup.php
```

Ja no ha d'estar disponible.

### ✅ Comprovació 6

- [ ] El privilegi global `CREATE` s'ha retirat.
- [ ] `setup.php` s'ha eliminat de l'aplicació desplegada.
- [ ] La BD i la taula creades continuen existint.

### 🧠 Idea clau

Hem aplicat:

```text
donar permís
    ↓
realitzar una tasca administrativa
    ↓
comprovar-la
    ↓
retirar el permís
```

---

# 16. Comprovar que el CRUD original continua funcionant

Torna a:

```text
http://IP_PUBLICA/
```

Prova:

```text
CREATE
READ
UPDATE
DELETE
```

No hem de trencar l'aplicació original per afegir noves funcionalitats.

### ✅ Comprovació 7

- [ ] El CRUD original continua funcionant.
- [ ] `/login.php` funciona.
- [ ] `/zona.php` està protegida.
- [ ] `/logout.php` tanca la sessió.

---

# 17. Comprovació bàsica de funcionament i rendiment

Des de la EC2 executa:

```bash
for i in {1..5}; do
  curl -o /dev/null -s     -w "peticio $i -> HTTP %{http_code} · %{time_total} s
"     http://localhost/
done
```

Hauries d'obtindre cinc respostes amb:

```text
HTTP 200
```

i un temps per a cada petició.

Ara executa:

```bash
docker stats --no-stream
```

Observa l'ús de recursos dels contenidors.

## 17.1. Interpreta

Anota:

```text
Temps més ràpid:
Temps més lent:
Totes les peticions han retornat HTTP 200?:
Contenidor amb més memòria en la comprovació:
```

> No busquem fer un benchmark professional. Busquem comprovar que l'aplicació respon i observar una mesura bàsica del seu comportament.

📸 **Evidència 5:** comprovació de les peticions i `docker stats --no-stream`.

---

# 18. Diagnòstic d'errors

## El PHP nou no apareix

Recorda:

```bash
docker compose up -d --build app
```

El Dockerfile copia els fitxers quan construeix la imatge.

## `zona.php` no redirigeix

Comprova que:

```php
session_start();
```

està abans de generar HTML.

## El login sempre falla

Revisa:

- nom d'usuari;
- contrasenya;
- hash copiat complet;
- `password_verify()`.

## `setup.php` mostra error de permisos

Comprova:

```sql
SHOW GRANTS FOR 'lamp_user'@'%';
```

i confirma que encara té temporalment:

```text
CREATE ON *.*
```

## El CRUD ha deixat de funcionar

Comprova:

```bash
docker compose ps
docker compose logs app --tail=50
docker compose logs mysql --tail=50
```

---

# 19. Evidències del Sprint

Entrega evidències de:

1. `salutacio.php` funcionant.
2. login correcte.
3. pàgina protegida.
4. Anna i Marc en dues sessions independents.
5. `porconstech_demo` creada des de PHP.
6. taula `proves_php` creada des de PHP.
7. retirada del privilegi temporal `CREATE`.
8. eliminació de `setup.php`.
9. CRUD original funcionant.
10. comprovació bàsica de rendiment.

> No publiques contrasenyes ni el contingut del fitxer `.env`.

---

# 20. Preguntes finals

### 1.
Quina part de `salutacio.php` executa el servidor i quina part rep finalment el navegador?

### 2.
Per a què serveix una variable com `$empresa`?

### 3.
Què fa l'estructura `if` utilitzada en la pràctica?

### 4.
Quin avantatge té crear una funció com `neteja()` o `missatge_benvinguda()`?

### 5.
Com arriben al servidor les dades del formulari de `login.php`?

### 6.
Per a què utilitzem `$_SESSION`?

### 7.
Per què `zona.php` comprova si existeix `$_SESSION['usuari']`?

### 8.
Què demostra la prova amb Anna en un navegador i Marc en una finestra d'incògnit?

### 9.
Quines dues instruccions SQL ha executat PHP en `setup.php` per crear estructura en MySQL?

### 10.
Per què retirem el privilegi `CREATE` i eliminem `setup.php` després de la comprovació?

---

# ✅ Checklist final

- [ ] El Sprint 2 funcionava abans de començar.
- [ ] He identificat llenguatges de servidor.
- [ ] He creat `salutacio.php`.
- [ ] He utilitzat variables.
- [ ] He utilitzat una funció.
- [ ] He utilitzat `if`.
- [ ] He comprovat la relació PHP + HTML.
- [ ] He creat un formulari.
- [ ] He processat dades amb `POST`.
- [ ] He utilitzat `password_verify()`.
- [ ] He utilitzat sessions.
- [ ] He protegit `zona.php`.
- [ ] He implementat logout.
- [ ] He comprovat dues sessions independents.
- [ ] PHP ha creat una base de dades.
- [ ] PHP ha creat una taula.
- [ ] He retirat el privilegi temporal.
- [ ] He eliminat `setup.php`.
- [ ] El CRUD original continua funcionant.
- [ ] He realitzat la comprovació bàsica de rendiment.
- [ ] He contestat les preguntes finals.

---

# 🏁 Projecte completat

En aquest projecte has passat per tres formes de treball:

```text
1. Arquitectura tradicional
   EC2 WEB ───── EC2 MySQL

2. Contenidors
   Docker Compose
   ├── app
   ├── mysql
   └── phpmyadmin

3. Evolució de l'aplicació
   PHP
   ├── variables
   ├── control
   ├── funcions
   ├── formularis
   ├── sessions
   ├── autenticació
   └── MySQL
```

Ara no només has desplegat una aplicació: també has comprovat com funciona i has realitzat modificacions sobre el seu codi.

---

## Fonts i atribució

L'aplicació base utilitzada durant el Projecte 4 és `josejuansanchez/iaw-practica-lamp`, una aplicació PHP + MySQL senzilla per practicar operacions CRUD.

Per a les funcionalitats afegides s'han seguit els mecanismes documentats oficialment per PHP per a sessions i verificació de contrasenyes, i la documentació oficial de MySQL 8.4 per a la creació de bases de dades i gestió de privilegis.
