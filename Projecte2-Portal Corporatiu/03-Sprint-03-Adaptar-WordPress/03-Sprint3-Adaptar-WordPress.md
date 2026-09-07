# 🎨 Sprint 3 · Adaptar WordPress

## 🎯 Objectiu

PorçonsTech ja té el seu portal WordPress instal·lat i administrat.

Ara realitzaràs una **adaptació mínima del gestor de continguts modificant codi**, sense tocar directament el tema original.

Crearàs un **tema fill** que inclourà:

- una modificació visual senzilla;
- una funcionalitat pròpia molt xicoteta;
- comprovacions del resultat;
- documentació breu dels canvis.

> ⏱️ **Duració aproximada: 3 hores**

---

# 📚 Resultat d'aprenentatge

Aquest Sprint treballa el **RA7**:

> Realitza modificacions en gestors de continguts adaptant la seua aparença i funcionalitats.

Treballarem els criteris:

- **RA7.a** · Identificar l'estructura de directoris del gestor.
- **RA7.b** · Reconéixer la funció i naturalesa dels fitxers.
- **RA7.c** · Seleccionar les funcionalitats que cal adaptar o incorporar.
- **RA7.d** · Identificar els recursos afectats per les modificacions.
- **RA7.e** · Modificar el codi per incorporar o adaptar funcionalitats.
- **RA7.f** · Verificar el funcionament dels canvis.
- **RA7.g** · Documentar les modificacions realitzades.

---

# 1. Explorar l'estructura de WordPress

Connecta't per SSH al servidor de PorçonsTech i situa't en el directori de WordPress.

Per exemple:

```bash
cd /var/www/html
```

Observa l'estructura principal:

```bash
ls
```

Localitza especialment:

```text
wp-admin
wp-content
wp-includes
wp-config.php
```

Ara entra en:

```bash
cd wp-content
ls
```

Localitza:

```text
plugins
themes
uploads
```

### 🧠 Identifica

Completa breument:

| Element | Funció |
|---|---|
| `wp-content/themes` | |
| `wp-content/plugins` | |
| `wp-content/uploads` | |
| `wp-config.php` | |

---

# 2. Identificar el tema actiu

Torna al directori principal de WordPress:

```bash
cd /var/www/html
```

Executa:

```bash
wp theme list
```

Identifica el tema que apareix com:

```text
active
```

Anota el seu **slug**.

Exemple:

```text
twentytwentyfive
```

> ⚠️ Necessitaràs el nom exacte del tema pare per crear el tema fill.

---

# 3. Planificar l'adaptació

Abans de modificar res, completa:

| Modificació | Fitxer afectat | Què volem aconseguir? |
|---|---|---|
| Canvi visual | `style.css` | Destacar visualment un missatge de PorçonsTech |
| Nova funcionalitat | `functions.php` | Crear el shortcode `[porconstech]` |

Així sabem **què modificarem abans de tocar el codi**.

---

# 4. Crear el tema fill

Entra en el directori de temes:

```bash
cd /var/www/html/wp-content/themes
```

Crea el directori:

```bash
mkdir porconstech-child
```

Entra:

```bash
cd porconstech-child
```

Crea:

```bash
nano style.css
```

Afig:

```css
/*
Theme Name: PorçonsTech Child
Description: Tema fill del portal corporatiu de PorçonsTech
Template: TEMA_PARE
Version: 1.0
*/
```

Substitueix:

```text
TEMA_PARE
```

pel **slug exacte** del tema actiu que has identificat abans.

Per exemple:

```css
Template: twentytwentyfive
```

> ⚠️ No copies el nom visible del tema. Utilitza el seu slug.

---

# 5. Afegir una modificació visual

En el mateix `style.css`, després de la capçalera, afig:

```css
.porconstech-destacat {
    border: 2px solid;
    padding: 1rem;
    font-weight: 600;
    margin: 1rem 0;
}
```

Aquesta classe s'utilitzarà després en la funcionalitat que crearem.

---

# 6. Crear `functions.php`

Crea:

```bash
nano functions.php
```

Afig:

```php
<?php

function porconstech_child_styles() {
    wp_enqueue_style(
        'porconstech-child',
        get_stylesheet_uri()
    );
}

add_action('wp_enqueue_scripts', 'porconstech_child_styles');


function porconstech_missatge() {
    return '<div class="porconstech-destacat">
                Plataforma tecnològica desenvolupada per PorçonsTech.
            </div>';
}

add_shortcode('porconstech', 'porconstech_missatge');
```

Guarda el fitxer.

---

# 7. Entendre què hem modificat

Observa ara el tema:

```text
porconstech-child/
├── style.css
└── functions.php
```

Respon breument:

### `style.css`

Quina part del lloc modifica?

### `functions.php`

Quina nova funcionalitat incorpora?

### Tema fill

Per què no hem modificat directament els fitxers del tema pare?

---

# 8. Activar el tema fill

Des del directori principal de WordPress:

```bash
cd /var/www/html
```

Comprova que WordPress detecta el tema:

```bash
wp theme list
```

Activa'l:

```bash
wp theme activate porconstech-child
```

Torna a comprovar:

```bash
wp theme list
```

`porconstech-child` ha d'aparéixer com:

```text
active
```

---

# 9. Utilitzar la nova funcionalitat

Accedeix al panell d'administració de WordPress.

Edita una pàgina del portal de PorçonsTech o crea una pàgina de prova.

Afig:

```text
[porconstech]
```

Publica o actualitza la pàgina.

Obri-la des del navegador.

Hauria d'aparéixer el missatge:

```text
Plataforma tecnològica desenvolupada per PorçonsTech.
```

amb l'estil que has definit en `style.css`.

---

# 10. Verificar els canvis

Comprova:

- [ ] WordPress continua funcionant.
- [ ] El tema fill està actiu.
- [ ] El contingut anterior del portal continua visible.
- [ ] El shortcode `[porconstech]` funciona.
- [ ] El missatge mostra l'estil definit en `style.css`.
- [ ] No has modificat directament els fitxers del tema pare.

---

# 11. Petita modificació pròpia

Ara realitza **una modificació mínima** sobre el que ja tens.

Pots triar una d'aquestes opcions:

- canviar el text del missatge;
- modificar el marge o la vora;
- afegir una segona línia al missatge;
- canviar el text que retorna el shortcode.

Després:

1. guarda el canvi;
2. recarrega la pàgina;
3. comprova que la modificació és visible.

> No cal crear una funcionalitat nova. L'objectiu és demostrar que identifiques quin fitxer has de modificar i que pots verificar-ne el resultat.

---

# 12. Evidències

Entrega evidències que demostren:

1. estructura de `wp-content`;
2. tema pare identificat;
3. directori `porconstech-child`;
4. contingut principal de `style.css`;
5. contingut principal de `functions.php`;
6. tema fill actiu;
7. shortcode funcionant;
8. modificació pròpia aplicada.

> No cal capturar totes les ordres. Les evidències han de demostrar **resultats i modificacions**.

---

# 13. Preguntes finals

Respon breument.

### 1.

Quina diferència hi ha entre `themes`, `plugins` i `uploads` dins de `wp-content`?

### 2.

Quina funció té `style.css` en el nostre tema fill?

### 3.

Quina funció té `functions.php`?

### 4.

Quins dos fitxers hem identificat com a afectats per la nostra adaptació?

### 5.

Què fa el shortcode `[porconstech]`?

### 6.

Per què és millor realitzar aquesta modificació en un tema fill que modificar directament el tema pare?

---

# ✅ Checklist final

- [ ] He identificat l'estructura principal de WordPress.
- [ ] He identificat el tema pare.
- [ ] He creat `porconstech-child`.
- [ ] He creat `style.css`.
- [ ] He creat `functions.php`.
- [ ] He incorporat una modificació visual.
- [ ] He incorporat el shortcode `[porconstech]`.
- [ ] He activat el tema fill.
- [ ] He verificat el funcionament.
- [ ] He realitzat una modificació pròpia.
- [ ] He documentat els canvis.
- [ ] He contestat les preguntes finals.

---

# 🏁 Sprint completat

Has passat de:

**implantar WordPress → administrar WordPress → adaptar WordPress**

El portal de PorçonsTech disposa ara d'una personalització pròpia creada mitjançant codi sense modificar directament el tema original.
