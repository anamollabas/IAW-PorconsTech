# ⚙️ Administració de WordPress amb WP-CLI

> [!NOTE]
> Aquesta pràctica està basada en el material de **José Juan Sánchez Hernández**, adaptat a la metodologia **PorçonsTech**.

> [!IMPORTANT]
> Aquest Sprint continua sobre el WordPress implantat al **Sprint 1**.
>
> Treballarem sobre el **mateix servidor** i la mateixa instal·lació de WordPress.
>
> Abans de començar comprova que:
>
> - Apache està operatiu.
> - PHP funciona correctament.
> - MariaDB està operativa.
> - WordPress funciona.
> - Pots accedir al panell `/wp-admin`.

---

## 🎯 Objectiu

En aquest Sprint aprendràs a administrar WordPress des del terminal mitjançant **WP-CLI**.

WP-CLI permet realitzar des de la línia de comandaments moltes de les tasques que habitualment es fan des del panell d'administració de WordPress.

Al llarg del Sprint aprendràs a:

- instal·lar i configurar WP-CLI;
- consultar la configuració de WordPress;
- administrar plugins;
- administrar temes;
- gestionar usuaris i perfils;
- actualitzar WordPress;
- gestionar continguts;
- realitzar còpies de seguretat;
- importar i exportar informació;
- consultar informació del sistema;
- automatitzar tasques habituals d'administració.

---

# 📝 Pas 1 · Instal·lar WP-CLI

## 1.1 Què és WP-CLI?

**WP-CLI (WordPress Command Line Interface)** és una eina que permet administrar WordPress directament des del terminal.

En lloc d'utilitzar sempre el panell web, podrem executar ordres com:

```bash
wp plugin list
```

```bash
wp theme list
```

```bash
wp core check-update
```

Açò és especialment útil quan administrem servidors de forma remota o volem automatitzar tasques repetitives.

---

## 1.2 Descarregar WP-CLI

Descarrega el fitxer executable oficial:

```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
```

El fitxer descarregat és un paquet PHP executable amb extensió `.phar`.

---

## 1.3 Assignar permisos d'execució

Executa:

```bash
chmod +x wp-cli.phar
```

---

## 1.4 Instal·lar el comandament `wp`

Mou el fitxer al directori `/usr/local/bin` i canvia-li el nom a `wp`:

```bash
sudo mv wp-cli.phar /usr/local/bin/wp
```

A partir d'aquest moment podràs executar WP-CLI des de qualsevol directori utilitzant simplement:

```bash
wp
```

---

## 1.5 Comprovar la instal·lació

Executa:

```bash
wp --info
```

Hauries d'obtenir informació sobre:

- el sistema operatiu;
- la versió de PHP;
- la ruta de PHP;
- la versió de WP-CLI;
- els fitxers de configuració utilitzats.

![Comprovació de WP-CLI](imatges/01-wp-cli-info.png)

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] `wp` està instal·lat.
- [ ] `wp --info` funciona correctament.
- [ ] WP-CLI detecta correctament PHP.


---

# 🔐 Preparar els permisos per treballar amb WP-CLI

Al Sprint anterior els fitxers de WordPress es van configurar perquè Apache (`www-data`) poguera treballar amb ells.

Ara també necessitem que l'usuari amb què ens connectem per SSH puga administrar WordPress mitjançant WP-CLI.

Assigna l'usuari actual com a propietari dels fitxers i mantín `www-data` com a grup:

```bash
sudo chown -R $USER:www-data /var/www/html
```

Configura els permisos dels directoris:

```bash
sudo find /var/www/html -type d -exec chmod 775 {} \;
```

Configura els permisos dels fitxers:

```bash
sudo find /var/www/html -type f -exec chmod 664 {} \;
```

Accedeix al directori de WordPress:

```bash
cd /var/www/html
```

Comprova els permisos:

```bash
ls -la
```

---

## ✅ Comprovació

Executa:

```bash
wp core version
```

Si WP-CLI mostra la versió instal·lada de WordPress sense errors de permisos, ja pots continuar amb la pràctica.

> [!IMPORTANT]
> A partir d'aquest moment tots els comandaments `wp` del Sprint s'executaran des de:
>
> ```text
> /var/www/html
> ```
>
> No és necessari utilitzar `sudo` ni `--allow-root` per als comandaments habituals de WP-CLI.
---

# 📝 Pas 2 · Explorar WordPress amb WP-CLI

Abans de començar a modificar la instal·lació, utilitzarem WP-CLI per consultar l'estat actual de WordPress.

L'objectiu és comprovar que WP-CLI reconeix correctament la instal·lació creada al Sprint anterior.

> [!IMPORTANT]
> Executa els comandaments des del directori on està instal·lat WordPress:
>
> ```bash
> cd /var/www/html
> ```

---

## 2.1 Consultar la configuració de WordPress

Executa:

```bash
wp config get
```

Aquest comandament mostra la configuració definida al fitxer `wp-config.php`.

Entre altres dades podràs identificar:

- `DB_NAME`
- `DB_USER`
- `DB_HOST`
- `DB_CHARSET`
- les Security Keys

![Configuració de WordPress amb WP-CLI](imatges/02-wp-config-get.png)

> [!CAUTION]
> No publiques captures on apareguen contrasenyes, claus o informació sensible.
>
> Si fas una captura per a la documentació, oculta qualsevol dada privada.

---

## 2.2 Comprovar si WordPress necessita actualitzacions

Executa:

```bash
wp core check-update
```

Aquest comandament comprova si existeix una nova versió del nucli de WordPress.

De moment **no actualitzes res**. Només consulta l'estat del sistema.

![Comprovació del core](imatges/03-core-check.png)

---

## 2.3 Consultar els plugins instal·lats

Executa:

```bash
wp plugin list
```

WP-CLI mostrarà informació sobre els plugins instal·lats, incloent:

- nom;
- estat;
- versió;
- disponibilitat d'actualitzacions.

![Plugins instal·lats](imatges/04-plugin-list.png)

Observa especialment la columna **status**.

Un plugin pot estar, per exemple:

- actiu;
- inactiu.

---

## 2.4 Consultar els temes instal·lats

Executa:

```bash
wp theme list
```

Obtindràs una llista dels temes disponibles a la instal·lació.

![Temes instal·lats](imatges/05-theme-list.png)

Identifica:

- quin tema està actiu;
- quins temes estan inactius;
- quina versió té cadascun.

---

## 💡 Què estem fent realment?

Fins ara administraves WordPress principalment des del navegador.

WP-CLI et permet consultar la mateixa instal·lació directament des del servidor.

Per exemple:

| Panell de WordPress | WP-CLI |
|---|---|
| Veure plugins | `wp plugin list` |
| Veure temes | `wp theme list` |
| Comprovar actualitzacions | `wp core check-update` |
| Consultar configuració | `wp config get` |

A partir d'ara començarem a **modificar i administrar WordPress des del terminal**.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] `wp config get` mostra la configuració de WordPress.
- [ ] `wp core check-update` funciona correctament.
- [ ] `wp plugin list` mostra els plugins instal·lats.
- [ ] `wp theme list` mostra els temes instal·lats.
- [ ] Has identificat el tema actiu.
- [ ] Has comprovat si existeixen actualitzacions disponibles.

---

# 📝 Pas 3 · Administrar plugins amb WP-CLI

Els plugins permeten ampliar les funcionalitats de WordPress.

Amb WP-CLI podem administrar-los completament des del terminal, sense necessitat d'accedir al panell web.

---

## 3.1 Consultar els plugins instal·lats

Executa:

```bash
wp plugin list
```

Aquest comandament mostra informació sobre els plugins instal·lats:

- nom;
- estat;
- versió;
- actualitzacions disponibles.

---

## 3.2 Instal·lar i activar un plugin

Instal·larem el plugin `wps-hide-login`.

Aquest plugin permet modificar l'adreça habitual d'accés al panell d'administració de WordPress.

Executa:

```bash
wp plugin install wps-hide-login --activate
```

Comprova després que està actiu:

```bash
wp plugin list
```

---

## 3.3 Configurar el plugin

Una vegada instal·lat, podem modificar la seua configuració directament des de WP-CLI.

Executa:

```bash
wp option update whl_page "acces-porconstech"
```

Amb aquesta configuració, l'accés al panell d'administració deixarà d'utilitzar l'adreça habitual `/wp-admin`.

Comprova al navegador que la nova URL funciona.

> [!IMPORTANT]
> Recorda la nova ruta configurada abans de continuar.

---

## 3.4 Consultar una opció de WordPress

Podem comprovar el valor que acabem de modificar amb:

```bash
wp option get whl_page
```

Hauria d'aparéixer:

```text
acces-porconstech
```

---

## 3.5 Desactivar el plugin

Executa:

```bash
wp plugin deactivate wps-hide-login
```

Comprova el seu estat:

```bash
wp plugin list
```

---

## 3.6 Tornar a activar-lo

Executa:

```bash
wp plugin activate wps-hide-login
```

---

## 3.7 Actualitzar els plugins

Comprova primer si existeixen actualitzacions:

```bash
wp plugin list
```

Per actualitzar tots els plugins:

```bash
wp plugin update --all
```

---

## 3.8 Eliminar un plugin

Per eliminar un plugin primer és recomanable desactivar-lo:

```bash
wp plugin deactivate wps-hide-login
```

Després elimina'l:

```bash
wp plugin delete wps-hide-login
```

Comprova que ja no apareix:

```bash
wp plugin list
```

---

## 💡 Què acabes de fer?

Has administrat el cicle de vida complet d'un plugin des del terminal:

```text
Instal·lar
   ↓
Activar
   ↓
Configurar
   ↓
Actualitzar
   ↓
Desactivar
   ↓
Eliminar
```

Aquestes mateixes operacions es poden realitzar des del panell web de WordPress, però WP-CLI permet fer-les de forma més ràpida i facilita la seua futura automatització.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Saps consultar els plugins instal·lats.
- [ ] Has instal·lat un plugin amb WP-CLI.
- [ ] Has activat i desactivat un plugin.
- [ ] Has modificat una opció de configuració.
- [ ] Saps comprovar si existeixen actualitzacions.
- [ ] Has eliminat correctament el plugin.


---

# 📝 Pas 4 · Administrar temes amb WP-CLI

Els temes controlen l'aparença visual d'un lloc WordPress.

Amb WP-CLI podem consultar, instal·lar, activar, actualitzar i eliminar temes directament des del terminal.

---

## 4.1 Consultar els temes instal·lats

Executa:

```bash
wp theme list
```

Observa:

- quin tema està actiu;
- quins temes estan inactius;
- la versió de cada tema;
- si hi ha actualitzacions disponibles.

---

## 4.2 Instal·lar un nou tema

Busca un tema disponible al repositori oficial de WordPress i instal·la'l.

Per exemple:

```bash
wp theme install twentytwentyfour
```

> [!NOTE]
> Si aquest tema ja està instal·lat, pots utilitzar-ne un altre disponible al repositori oficial.

Comprova que apareix a la llista:

```bash
wp theme list
```

---

## 4.3 Activar el tema

Executa:

```bash
wp theme activate twentytwentyfour
```

Comprova de nou:

```bash
wp theme list
```

El tema activat haurà d'aparéixer amb l'estat:

```text
active
```

Accedeix també al lloc web i comprova que l'aparença ha canviat.

---

## 4.4 Actualitzar els temes

Comprova si hi ha actualitzacions disponibles:

```bash
wp theme list
```

Per actualitzar tots els temes:

```bash
wp theme update --all
```

---

## 4.5 Tornar al tema original

Abans d'eliminar el tema de prova, activa de nou el tema que utilitzaves anteriorment.

Consulta els temes:

```bash
wp theme list
```

I activa el que corresponga:

```bash
wp theme activate NOM_DEL_TEMA
```

Substitueix `NOM_DEL_TEMA` pel nom real del tema.

---

## 4.6 Eliminar el tema de prova

Ara ja pots eliminar el tema que has instal·lat per a la pràctica:

```bash
wp theme delete twentytwentyfour
```

Comprova que s'ha eliminat:

```bash
wp theme list
```

---

## 💡 Què acabes de fer?

Has gestionat el cicle de vida d'un tema des de WP-CLI:

```text
Consultar
   ↓
Instal·lar
   ↓
Activar
   ↓
Actualitzar
   ↓
Canviar
   ↓
Eliminar
```

Aquesta gestió permet modificar l'aparença del lloc WordPress sense necessitat d'utilitzar el panell d'administració.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Saps consultar els temes instal·lats.
- [ ] Has instal·lat un nou tema.
- [ ] Has activat el tema.
- [ ] Has comprovat el canvi visual al lloc web.
- [ ] Saps actualitzar els temes.
- [ ] Has tornat a activar el tema original.
- [ ] Has eliminat el tema de prova.


---

# 📝 Pas 5 · Actualitzar WordPress i gestionar l'idioma

Mantindre WordPress actualitzat és una tasca essencial d'administració.

Les actualitzacions poden incorporar:

- correccions d'errors;
- millores de funcionament;
- noves funcionalitats;
- correccions de seguretat.

Amb WP-CLI podem comprovar i aplicar aquestes actualitzacions directament des del terminal.

---

## 5.1 Consultar la versió instal·lada

Executa:

```bash
wp core version
```

Anota la versió de WordPress que tens instal·lada.

---

## 5.2 Comprovar si existeixen actualitzacions

Executa:

```bash
wp core check-update
```

Si existeix una versió nova, WP-CLI mostrarà la informació corresponent.

> [!IMPORTANT]
> Abans d'actualitzar un sistema en producció és recomanable disposar d'una còpia de seguretat.
>
> En aquesta pràctica aprendrem a crear-la en un pas posterior.

---

## 5.3 Actualitzar WordPress

Si existeix una actualització disponible, executa:

```bash
wp core update
```

Torna a comprovar la versió:

```bash
wp core version
```

---

## 5.4 Comprovar l'idioma actual

Executa:

```bash
wp language core list
```

Observa:

- els idiomes disponibles;
- els idiomes instal·lats;
- quin idioma està actiu.

---

## 5.5 Instal·lar i activar un idioma

Per exemple, podem instal·lar i activar l'anglés:

```bash
wp language core install en_US --activate
```

Comprova de nou:

```bash
wp language core list
```

Accedeix al panell d'administració de WordPress i comprova el canvi.

---

## 5.6 Tornar a l'idioma anterior

Finalment, torna a configurar l'idioma utilitzat al lloc PorçonsTech.

Consulta primer els idiomes disponibles:

```bash
wp language core list
```

I activa el que corresponga:

```bash
wp site switch-language CODI_IDIOMA
```

Substitueix `CODI_IDIOMA` pel codi corresponent.

---

## 💡 Què acabes de fer?

Has utilitzat WP-CLI per administrar dos elements importants de WordPress:

```text
WordPress
├── Core
│   ├── Consultar versió
│   ├── Comprovar actualitzacions
│   └── Actualitzar
│
└── Idioma
    ├── Consultar
    ├── Instal·lar
    └── Activar
```

Mantindre actualitzat el gestor de continguts forma part de les tasques habituals d'administració d'un servidor web.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Saps consultar la versió de WordPress.
- [ ] Saps comprovar si existeixen actualitzacions.
- [ ] Has actualitzat WordPress si era necessari.
- [ ] Saps consultar els idiomes disponibles.
- [ ] Has canviat temporalment l'idioma.
- [ ] Has tornat a configurar l'idioma original.

---

# 📝 Pas 6 · Gestionar usuaris i perfils amb WP-CLI

WordPress permet treballar amb diferents tipus d'usuaris segons les tasques que poden realitzar dins del lloc web.

Els rols principals són:

- Administrador
- Editor
- Autor
- Col·laborador
- Subscriptor

Amb WP-CLI podem crear, consultar, modificar i eliminar usuaris directament des del terminal.

---

## 6.1 Consultar els usuaris existents

Executa:

```bash
wp user list
```

Observa especialment:

- nom d'usuari;
- correu electrònic;
- rol assignat.

---

## 6.2 Crear un usuari editor

Crea un nou usuari amb rol d'editor:

```bash
wp user create editor_porconstech editor@porconstech.local \
  --role=editor \
  --user_pass='ContrasenyaSegura123!'
```

Comprova que s'ha creat:

```bash
wp user list
```

---

## 6.3 Crear un usuari autor

Crea ara un segon usuari amb rol d'autor:

```bash
wp user create autor_porconstech autor@porconstech.local \
  --role=author \
  --user_pass='ContrasenyaSegura123!'
```

Torna a consultar els usuaris:

```bash
wp user list
```

---

## 6.4 Comprovar les diferències entre rols

Inicia sessió al panell de WordPress amb cadascun dels usuaris creats.

Comprova quines opcions pot veure cada perfil.

Completa la taula següent:

| Acció | Administrador | Editor | Autor |
|---|---|---|---|
| Crear entrades | | | |
| Editar entrades pròpies | | | |
| Editar entrades d'altres usuaris | | | |
| Instal·lar plugins | | | |
| Gestionar usuaris | | | |
| Modificar temes | | | |

---

## 6.5 Modificar el rol d'un usuari

Canvia el rol de l'usuari `autor_porconstech` a editor:

```bash
wp user set-role autor_porconstech editor
```

Comprova el canvi:

```bash
wp user list
```

---

## 6.6 Modificar informació d'un usuari

Podem modificar altres dades utilitzant:

```bash
wp user update editor_porconstech \
  --display_name="Editor PorçonsTech"
```

Comprova el resultat:

```bash
wp user get editor_porconstech
```

---

## 6.7 Eliminar un usuari

Abans d'eliminar un usuari hem de comprovar si té contingut associat.

Consulta els usuaris:

```bash
wp user list
```

Identifica l'ID de l'administrador.

Elimina l'usuari de prova reassignant el seu contingut a l'administrador:

```bash
wp user delete autor_porconstech --reassign=ID_ADMIN
```

Substitueix `ID_ADMIN` per l'identificador real de l'usuari administrador.

> [!IMPORTANT]
> En un entorn real no s'ha d'eliminar un usuari sense decidir abans què passarà amb el contingut que té associat.

---

## 💡 Principi de mínim privilegi

No tots els usuaris han de ser administradors.

Cada persona ha de disposar únicament dels permisos necessaris per realitzar la seua feina.

Això es coneix com a **principi de mínim privilegi**.

Per exemple:

```text
Administrador
    ↓
gestiona tot el lloc

Editor
    ↓
gestiona continguts

Autor
    ↓
gestiona principalment les seues entrades
```

Assignar correctament els rols redueix el risc de modificacions accidentals o accessos indeguts.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Saps consultar els usuaris de WordPress.
- [ ] Has creat usuaris amb rols diferents.
- [ ] Has comprovat les diferències entre els seus permisos.
- [ ] Has modificat el rol d'un usuari.
- [ ] Has modificat informació d'un usuari.
- [ ] Saps eliminar un usuari.
- [ ] Entens el principi de mínim privilegi.

---

# 📝 Pas 7 · Realitzar còpies de seguretat

Un lloc WordPress està format principalment per dos elements:

```text
WordPress
├── Fitxers
│   ├── Temes
│   ├── Plugins
│   ├── Imatges
│   └── Configuració
│
└── Base de dades
    ├── Usuaris
    ├── Entrades
    ├── Pàgines
    └── Configuració del lloc
```

Per tant, una còpia de seguretat completa ha d'incloure **els fitxers i la base de dades**.

---

## 7.1 Crear un directori per als backups

Crea un directori fora de l'arrel pública del servidor:

```bash
mkdir -p ~/backups-wordpress
```

---

## 7.2 Fer una còpia dels fitxers de WordPress

Comprimeix tot el directori de WordPress:

```bash
sudo tar -czf ~/backups-wordpress/wordpress-files.tar.gz /var/www/html
```

Comprova que el fitxer s'ha creat:

```bash
ls -lh ~/backups-wordpress
```

---

## 7.3 Identificar la base de dades

Abans de fer la còpia de la base de dades, consulta la configuració de WordPress:

```bash
wp config get DB_NAME
```

Consulta també l'usuari:

```bash
wp config get DB_USER
```

> [!IMPORTANT]
> No mostres ni publiques la contrasenya de la base de dades.

---

## 7.4 Exportar la base de dades amb WP-CLI

WP-CLI permet exportar la base de dades de WordPress directament:

```bash
wp db export ~/backups-wordpress/wordpress-db.sql
```

Comprova que el fitxer existeix:

```bash
ls -lh ~/backups-wordpress
```

Ara hauràs de tindre:

```text
backups-wordpress/
├── wordpress-files.tar.gz
└── wordpress-db.sql
```

---

## 7.5 Comprovar la còpia dels fitxers

Abans de considerar vàlid un backup hem de comprovar que es pot llegir.

Executa:

```bash
tar -tzf ~/backups-wordpress/wordpress-files.tar.gz | head
```

Hauries de veure els primers fitxers inclosos dins de l'arxiu comprimit.

---

## 7.6 Comprovar la còpia de la base de dades

Consulta les primeres línies del fitxer SQL:

```bash
head ~/backups-wordpress/wordpress-db.sql
```

Hauries de veure sentències SQL corresponents a l'exportació de la base de dades.

> [!CAUTION]
> Una còpia de seguretat que no s'ha comprovat no es pot considerar una còpia fiable.

---

## 💡 Què hauríem de recuperar en cas d'avaria?

Imagina que el servidor de PorçonsTech deixa de funcionar.

Respon:

1. Per què no seria suficient guardar només `/var/www/html`?
2. Quina informació perdríem si no tinguérem la base de dades?
3. Quina informació perdríem si només tinguérem la base de dades però no els fitxers?
4. Per què és millor guardar els backups fora de `/var/www/html`?

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Has creat un directori específic per als backups.
- [ ] Has realitzat una còpia dels fitxers de WordPress.
- [ ] Has exportat la base de dades.
- [ ] Has comprovat que els dos fitxers existeixen.
- [ ] Has verificat que l'arxiu comprimit es pot llegir.
- [ ] Has verificat que l'exportació SQL conté informació.
- [ ] Entens per què un backup complet necessita fitxers i base de dades.

--

# 📝 Pas 8 · Importar i exportar continguts

WordPress permet exportar continguts d'un lloc i importar-los posteriorment.

Aquesta funcionalitat és útil, per exemple, quan volem:

- migrar continguts entre llocs WordPress;
- copiar entrades o pàgines;
- traslladar contingut a un nou servidor;
- conservar una exportació dels continguts publicats.

> [!IMPORTANT]
> Una **exportació de continguts no és el mateix que una còpia de seguretat completa**.
>
> El backup del pas anterior inclou els fitxers i la base de dades.
>
> L'exportació que realitzarem ara està pensada principalment per traslladar continguts entre instal·lacions WordPress.

---

## 8.1 Crear contingut de prova

Abans d'exportar, crea des del panell de WordPress:

- una pàgina anomenada `Serveis PorçonsTech`;
- una entrada anomenada `Benvinguts a PorçonsTech`.

Publica els dos continguts.

---

## 8.2 Identificar els continguts

Consulta les entrades i pàgines existents:

```bash
wp post list --post_type=post,page --fields=ID,post_title,post_type,post_status
```

Localitza:

- `Serveis PorçonsTech`
- `Benvinguts a PorçonsTech`

Anota l'**ID** de cadascun.

Per exemple:

```text
Pàgina: ID 15
Entrada: ID 16
```

> [!IMPORTANT]
> Els identificadors del teu WordPress seran diferents dels de l'exemple.

---

## 8.3 Exportar els continguts amb WP-CLI

Crea un directori per guardar l'exportació:

```bash
mkdir -p ~/exports-wordpress
```

Exporta únicament els dos continguts creats:

```bash
wp export --post__in=ID_PAGINA,ID_ENTRADA --dir=~/exports-wordpress
```

Substitueix `ID_PAGINA` i `ID_ENTRADA` pels identificadors reals.

Per exemple:

```bash
wp export --post__in=15,16 --dir=~/exports-wordpress
```

Comprova el fitxer generat:

```bash
ls -lh ~/exports-wordpress
```

WordPress generarà un fitxer en format **WXR (WordPress eXtended RSS)**, basat en XML.

---

## 8.4 Consultar l'exportació

Consulta les primeres línies del fitxer:

```bash
head ~/exports-wordpress/*.xml
```

No és necessari entendre tota l'estructura XML.

Identifica informació relacionada amb:

- el lloc WordPress;
- entrades;
- pàgines;
- autors;
- dates de publicació.

---

## 8.5 Comparar exportació i backup

Completa la taula:

| Característica | Backup | Exportació WordPress |
|---|---|---|
| Inclou la base de dades completa | | |
| Inclou plugins | | |
| Inclou temes | | |
| Inclou entrades i pàgines | | |
| Permet traslladar continguts | | |
| Serveix per recuperar tot el lloc després d'una avaria | | |

---

## 8.6 Preparar la importació

Per poder importar un fitxer WXR des de WP-CLI necessitem el plugin **WordPress Importer**.

Instal·la'l i activa'l:

```bash
wp plugin install wordpress-importer --activate
```

Comprova que està actiu:

```bash
wp plugin list
```

---

## 8.7 Eliminar els continguts de prova

Ara eliminarem els dos continguts que acabem d'exportar.

> [!WARNING]
> Elimina únicament els continguts de prova creats en aquest apartat.

Executa:

```bash
wp post delete ID_PAGINA ID_ENTRADA --force
```

Per exemple:

```bash
wp post delete 15 16 --force
```

Comprova que ja no existeixen:

```bash
wp post list --post_type=post,page --fields=ID,post_title,post_type
```

---

## 8.8 Importar els continguts

Consulta primer el nom exacte del fitxer exportat:

```bash
ls ~/exports-wordpress
```

Ara importa el fitxer WXR:

```bash
wp import ~/exports-wordpress/NOM_DEL_FITXER.xml --authors=create
```

Substitueix `NOM_DEL_FITXER.xml` pel nom real del fitxer generat.

---

## 8.9 Comprovar la importació

Consulta de nou els continguts:

```bash
wp post list --post_type=post,page --fields=ID,post_title,post_type,post_status
```

Comprova que han tornat a aparéixer:

- `Serveis PorçonsTech`;
- `Benvinguts a PorçonsTech`.

Accedeix també al lloc web i verifica que els continguts es visualitzen correctament.

---

## 💡 Backup o exportació?

Davant de cadascuna de les situacions següents indica què utilitzaries:

**A.** El servidor s'ha avariat i necessites recuperar completament WordPress.

**B.** Volem traslladar les entrades del blog a una altra instal·lació WordPress.

**C.** Volem conservar plugins, temes, configuració i base de dades.

**D.** Volem copiar només determinats continguts a un altre WordPress.

Justifica breument cada resposta.

---

## 8.10 Treballar amb altres formats

WP-CLI també permet obtindre informació dels continguts en diferents formats.

Exporta informació de les entrades en format **CSV**:

```bash
wp post list \
  --post_type=post \
  --fields=ID,post_title,post_content,post_status \
  --format=csv > ~/exports-wordpress/entrades.csv
```

Comprova el contingut:

```bash
head ~/exports-wordpress/entrades.csv
```

Ara genera la mateixa informació en format **JSON**:

```bash
wp post list \
  --post_type=post \
  --fields=ID,post_title,post_content,post_status \
  --format=json > ~/exports-wordpress/entrades.json
```

Comprova el resultat:

```bash
head ~/exports-wordpress/entrades.json
```

Compara els formats treballats:

- WXR/XML
- CSV
- JSON

Indica quin consideres més adequat per:

- migrar continguts entre instal·lacions WordPress;
- analitzar dades en un full de càlcul;
- consumir informació des d'una aplicació.

> [!NOTE]
> WXR és el format que hem utilitzat per importar i exportar continguts entre instal·lacions WordPress.
>
> CSV i JSON els utilitzem ací per comprovar com WP-CLI pot representar i exportar la informació del gestor en altres formats.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Has creat contingut de prova.
- [ ] Has identificat els seus ID.
- [ ] Has exportat els continguts en format WXR/XML.
- [ ] Has identificat el fitxer XML generat.
- [ ] Entens la diferència entre una exportació de continguts i un backup.
- [ ] Has instal·lat el plugin necessari per realitzar la importació.
- [ ] Has eliminat els continguts de prova.
- [ ] Has importat el fitxer WXR.
- [ ] Has comprovat que els continguts s'han recuperat correctament.
- [ ] Has generat informació en CSV i JSON.
- [ ] Saps diferenciar la utilitat de WXR/XML, CSV i JSON.


---

# 📝 Pas 9 · Sindicació de continguts amb RSS

La **sindicació de continguts** permet que altres aplicacions o llocs web reben automàticament les noves publicacions d'un lloc.

Un dels formats més utilitzats és **RSS (Really Simple Syndication)**.

WordPress genera automàticament un canal RSS amb les entrades publicades.

---

## 9.1 Localitzar el canal RSS de WordPress

El canal principal d'un lloc WordPress està disponible habitualment en:

```text
https://NOM_DEL_DOMINI/feed/
```

Accedeix a aquesta adreça des del navegador.

Hauries de trobar un document XML amb informació de les entrades publicades.

> [!TIP]
> Si el navegador no mostra el contingut de forma visual, no significa que el feed no funcione. RSS està pensat perquè el consumisquen altres aplicacions.

---

## 9.2 Comprovar el feed des del servidor

També podem comprovar-lo des del terminal:

```bash
curl https://NOM_DEL_DOMINI/feed/
```

O mostrar només les primeres línies:

```bash
curl -s https://NOM_DEL_DOMINI/feed/ | head
```

Busca elements XML relacionats amb:

```xml
<rss>
<channel>
<title>
<item>
```

Cada element `<item>` representa normalment una entrada publicada.

---

## 9.3 Consultar la configuració RSS amb WP-CLI

Consulta quantes entrades mostra WordPress al feed:

```bash
wp option get posts_per_rss
```

---

## 9.4 Modificar la configuració

Configura el canal perquè mostre, per exemple, les últimes 5 entrades:

```bash
wp option update posts_per_rss 5
```

Comprova el canvi:

```bash
wp option get posts_per_rss
```

---

## 9.5 Comprovar la sindicació

Publica una nova entrada:

```text
Actualitat PorçonsTech
```

Accedeix de nou a:

```text
https://NOM_DEL_DOMINI/feed/
```

Comprova que la nova publicació apareix al canal RSS.

---

## 💡 Per a què serveix RSS?

Imagina que una altra aplicació vol mostrar automàticament les últimes notícies de PorçonsTech.

En lloc de copiar-les manualment, pot consultar:

```text
PorçonsTech
      │
      │ publica
      ▼
  Canal RSS
      │
      ├────► Lector RSS
      │
      ├────► Altre lloc web
      │
      └────► Aplicació
```

Quan PorçonsTech publica una nova entrada, els sistemes subscrits poden detectar-la automàticament.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Has localitzat el canal RSS de WordPress.
- [ ] Has comprovat que el feed conté informació en XML.
- [ ] Has consultat la configuració RSS amb WP-CLI.
- [ ] Has modificat el nombre d'entrades mostrades.
- [ ] Has publicat contingut i comprovat que apareix al feed.
- [ ] Entens per a què serveix la sindicació de continguts.


---

# 📝 Pas 10 · Analitzar els accessos al lloc web

Un administrador no només ha de configurar WordPress.

També ha de poder comprovar **qui accedeix al servidor, quins recursos es consulten i quines respostes està retornant el servidor web**.

Apache registra aquesta informació als seus fitxers de log.

---

## 10.1 Consultar el registre d'accessos

En Ubuntu, el registre d'accessos d'Apache es troba habitualment en:

```text
/var/log/apache2/access.log
```

Consulta les últimes peticions:

```bash
sudo tail -n 20 /var/log/apache2/access.log
```

Ara accedeix diverses vegades al lloc WordPress des del navegador i torna a executar el comandament.

Hauries de veure noves línies al registre.

---

## 10.2 Interpretar una línia del log

Una entrada del registre conté informació com:

```text
IP_CLIENT - - [data] "GET / HTTP/1.1" 200 ...
```

Identifica:

- IP del client;
- data i hora;
- mètode HTTP;
- recurs sol·licitat;
- codi de resposta HTTP.

Per exemple:

```text
GET /wp-admin/
```

indica que un client ha intentat accedir al panell d'administració.

---

## 10.3 Obtindre les IP amb més accessos

Executa:

```bash
sudo awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -nr | head
```

El resultat mostrarà les IP que més peticions han realitzat.

---

## 10.4 Analitzar els codis HTTP

Executa:

```bash
sudo awk '{print $9}' /var/log/apache2/access.log | sort | uniq -c | sort -nr
```

Identifica codis com:

```text
200
301
302
404
```

Investiga què significa cadascun.

---

## 10.5 Consultar els recursos més sol·licitats

Executa:

```bash
sudo awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -nr | head
```

Observa quines URL del lloc han rebut més peticions.

---

## 10.6 Crear un informe d'accés

Crea un fitxer:

```bash
nano ~/informe-accessos.txt
```

Inclou:

### Informe d'accessos PorçonsTech

**1. IP amb més peticions**

Indica la IP i el nombre d'accessos.

**2. Recursos més sol·licitats**

Indica les URL més consultades.

**3. Codis HTTP detectats**

Explica el significat dels principals codis trobats.

**4. Errors**

Indica si has detectat respostes `404` o altres errors.

**5. Conclusions**

Explica breument què podem conéixer sobre l'activitat del servidor analitzant els logs.

---

## 💡 Per què són importants els logs?

Els registres d'accés poden ajudar-nos a:

- detectar errors;
- investigar problemes;
- analitzar l'ús del lloc web;
- detectar accessos sospitosos;
- conéixer els recursos més sol·licitats.

> [!IMPORTANT]
> Els logs poden contindre informació relacionada amb els usuaris, com adreces IP.
>
> En un entorn real cal gestionar aquesta informació d'acord amb la normativa de protecció de dades.

---

## ✅ Comprovació

Abans de continuar verifica que:

- [ ] Saps localitzar el registre d'accessos d'Apache.
- [ ] Saps interpretar els elements principals d'una petició.
- [ ] Has identificat les IP amb més accessos.
- [ ] Has analitzat els codis HTTP.
- [ ] Has identificat els recursos més sol·licitats.
- [ ] Has elaborat un breu informe d'accessos.


---

# 🏢 Tasques finals · PorçonsTech

Has assumit l'administració del portal corporatiu de **PorçonsTech**.

A partir de les tasques realitzades durant aquest Sprint, respon breument les qüestions següents.

## 1. Administració amb WP-CLI

Explica dos avantatges d'utilitzar **WP-CLI** en lloc de realitzar totes les tasques des del panell web de WordPress.

---

## 2. Plugins

PorçonsTech necessita incorporar una nova funcionalitat al portal.

Explica quin procés seguiries per:

1. instal·lar el plugin;
2. activar-lo;
3. comprovar que funciona;
4. actualitzar-lo;
5. eliminar-lo si ja no és necessari.

---

## 3. Usuaris i permisos

PorçonsTech incorpora tres persones:

- una administradora del sistema;
- una persona responsable de revisar i publicar continguts;
- una persona que només publicarà les seues pròpies entrades.

Assigna el rol de WordPress més adequat a cadascuna i justifica la decisió.

---

## 4. Actualitzacions

Explica per què és important mantindre actualitzats:

- WordPress;
- els plugins;
- els temes.

Què comprovaries abans de realitzar una actualització important?

---

## 5. Backup i exportació

Explica la diferència entre:

- una còpia de seguretat completa;
- una exportació WXR/XML;
- una exportació de dades en CSV o JSON.

Indica un cas d'ús adequat per a cadascuna.

---

## 6. Sindicació

Explica què és un canal RSS i com podria utilitzar-lo una altra aplicació per consultar automàticament les novetats publicades per PorçonsTech.

---

## 7. Anàlisi d'accessos

Indica quina informació pots obtindre del registre:

```text
/var/log/apache2/access.log
```

Explica com aquesta informació pot ajudar una persona administradora del sistema.

---
# ✅ Checklist final

Abans de donar el Sprint per finalitzat comprova que:

## WP-CLI

- [ ] WP-CLI està instal·lat i funciona correctament.
- [ ] Saps consultar la configuració i l'estat de WordPress.

## Plugins

- [ ] Saps llistar plugins.
- [ ] Has instal·lat i activat plugins.
- [ ] Has modificat la configuració d'un plugin.
- [ ] Saps actualitzar, desactivar i eliminar plugins.

## Temes

- [ ] Saps consultar els temes instal·lats.
- [ ] Has instal·lat i activat un tema.
- [ ] Saps actualitzar i eliminar temes.

## Usuaris

- [ ] Has creat usuaris amb diferents perfils.
- [ ] Has comprovat les diferències entre els seus permisos.
- [ ] Has modificat el rol d'un usuari.
- [ ] Saps eliminar un usuari preservant el seu contingut.

## Manteniment

- [ ] Saps consultar la versió de WordPress.
- [ ] Saps comprovar i aplicar actualitzacions.
- [ ] Has gestionat l'idioma del lloc.

## Còpies i continguts

- [ ] Has realitzat una còpia dels fitxers.
- [ ] Has exportat la base de dades.
- [ ] Has verificat les còpies creades.
- [ ] Has exportat continguts en WXR/XML.
- [ ] Has importat continguts.
- [ ] Has treballat amb informació en CSV i JSON.
- [ ] Entens la diferència entre backup i exportació de continguts.

## Sindicació i monitorització

- [ ] Has comprovat el canal RSS.
- [ ] Has modificat la configuració de sindicació.
- [ ] Has consultat els logs d'Apache.
- [ ] Has obtingut informació sobre els accessos al portal.
- [ ] Has elaborat un breu informe d'accessos.

## Documentació

- [ ] Has completat les tasques PorçonsTech.
- [ ] El repositori GitHub està actualitzat.
- [ ] Has documentat les incidències importants trobades durant el Sprint.


# 🎯 Criteris d'avaluació treballats

Aquest Sprint treballa el **RA3 · Administra gestors de continguts adaptant-los als requeriments i garantint la integritat de la informació**.

| CE | Criteri d'avaluació | Activitat principal |
|---|---|---|
| **RA3.a** | S'han adaptat i configurat els mòduls del gestor de continguts. | Configuració de plugins |
| **RA3.b** | S'han creat i gestionat usuaris amb diferents perfils. | Usuaris i rols |
| **RA3.c** | S'han integrat mòduls atenent requeriments de funcionalitat. | Instal·lació i activació de plugins |
| **RA3.d** | S'han realitzat còpies de seguretat dels continguts. | Backup de fitxers i base de dades |
| **RA3.e** | S'han importat i exportat continguts en diferents formats. | WXR/XML, CSV i JSON |
| **RA3.f** | S'han gestionat plantilles. | Gestió de temes |
| **RA3.g** | S'han integrat funcionalitats de sindicació. | RSS |
| **RA3.h** | S'han realitzat actualitzacions. | Core, plugins i temes |
| **RA3.i** | S'han obtingut informes d'accés. | Logs d'Apache |

> [!IMPORTANT]
> Els criteris d'avaluació d'aquest Sprint seran valorats mitjançant les evidències del projecte i la **Technical Review individual**.



