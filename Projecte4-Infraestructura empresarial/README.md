# 🚀 Projecte 4 · Desplegament i evolució d'una aplicació web

## 🎯 Repte

PorçonsTech ja sap desplegar serveis web, implantar i administrar un CMS i treballar amb una plataforma col·laborativa.

Ara arriba l'últim repte del curs: **desplegar, automatitzar, conteneritzar i evolucionar una aplicació web PHP amb accés a base de dades**.

Treballarem amb una aplicació PHP + MariaDB senzilla i veurem com pot evolucionar la seua arquitectura:

```text
1. Infraestructura tradicional
   WEB ───────── BD

2. Desplegament amb contenidors
   APP ───────── MYSQL

3. Evolució del codi
   PHP + formularis + sessions + autenticació + BD
```

---

## ⏱️ Duració

**14-16 hores aproximadament**

---

## 📚 Resultats d'aprenentatge

### RA5

**Genera documents web utilitzant llenguatges de guions de servidor.**

En aquest projecte treballarem:

- **RA5.a** · Identificació dels llenguatges de guions de servidor més rellevants.
- **RA5.b** · Relació entre el llenguatge de guions de servidor i el llenguatge de marques.
- **RA5.c** · Sintaxi bàsica del llenguatge.
- **RA5.d** · Estructures de control.
- **RA5.e** · Funcions.
- **RA5.f** · Formularis.
- **RA5.g** · Persistència de la informació entre documents web relacionats.
- **RA5.h** · Identificació i autenticació d'usuaris.
- **RA5.i** · Aïllament de l'entorn específic de cada usuari.

### RA6

**Genera documents web amb accés a bases de dades utilitzant llenguatges de guions de servidor.**

En aquest projecte treballarem:

- **RA6.a** · Identificació dels SGBD més utilitzats en entorns web.
- **RA6.b** · Integració entre el SGBD i el llenguatge de guions.
- **RA6.c** · Configuració de la connexió amb la base de dades.
- **RA6.d** · Creació de bases de dades i taules des del llenguatge de guions.
- **RA6.e** · Obtenció i actualització d'informació emmagatzemada.
- **RA6.f** · Aplicació de criteris de seguretat en l'accés dels usuaris.
- **RA6.g** · Verificació del funcionament i rendiment.

---

# 🧩 Organització del projecte

## Sprint 1 · Arquitectura de dues capes + Bash

Partirem d'una infraestructura nova.

```text
        Internet
            │
            ▼
      SERVIDOR WEB
      Apache + PHP
            │
            │ xarxa privada
            ▼
       SERVIDOR BD
         MariaDB
```

Treballarem a partir d'una adaptació de la pràctica 1.9 de José Juan Sánchez.

Crearàs:

- una EC2 per al servidor web;
- una EC2 per al servidor de base de dades;
- comunicació privada entre els dos servidors;
- configuració de MariaDB per acceptar la connexió necessària;
- usuari de base de dades amb permisos adequats;
- connexió PHP → MariaDB;
- desplegament d'una aplicació CRUD;
- scripts Bash i variables d'entorn per automatitzar part del desplegament.

### Idea clau

Passarem de:

**instal·lació manual → desplegament automatitzat**

---

## Sprint 2 · Docker + Docker Compose

Desplegarem la mateixa aplicació amb contenidors.

```text
Docker Compose

┌──────────────────────────────┐
│                              │
│   APP / APACHE + PHP         │
│           │                  │
│           ▼                  │
│         MYSQL                │
│                              │
└──────────────────────────────┘
```

Treballarem a partir d'una adaptació de la pràctica 5.5 de José Juan Sánchez.

Utilitzaràs:

- Docker;
- Dockerfile;
- Docker Compose;
- contenidors;
- xarxes;
- volums;
- `.env`;
- persistència de dades;
- connexió entre serveis.

### Idea clau

Compararem:

```text
Infraestructura tradicional          Docker

EC2 WEB ─── EC2 BD                   APP ─── MYSQL
IP privada                           nom del servei
scripts Bash                         Dockerfile + Compose
```

---

## Sprint 3 · Evolució de l'aplicació PHP

En l'últim Sprint deixaràs de centrar-te només en la infraestructura.

Ara hauràs d'entendre i modificar el **codi PHP de l'aplicació**.

Treballarem de manera guiada:

- PHP i HTML;
- variables i sintaxi;
- condicionals i bucles;
- funcions;
- formularis;
- sessions;
- login i logout;
- protecció de pàgines;
- sessions independents per usuari;
- creació d'una taula des de PHP;
- consulta, inserció, modificació i eliminació de dades;
- comprovacions de funcionament i seguretat.

### Idea clau

Passarem de:

**desplegar una aplicació → entendre-la → modificar-la**

---

# ⭐ Ampliació

Si disposem de temps, podrem ampliar la infraestructura amb un balancejador de càrrega:

```text
             Internet
                │
          LOAD BALANCER
           ┌────┴────┐
           │         │
         WEB1       WEB2
           │         │
           └────┬────┘
                │
                BD
```

Aquesta ampliació estarà basada en una versió reduïda de la pràctica 1.10.

> No serà necessària per superar el projecte.

---

# ✅ Resultat final

En acabar el projecte hauràs de ser capaç de:

- desplegar una arquitectura web de dues capes;
- explicar com es comuniquen el servidor web i la base de dades;
- automatitzar part del desplegament amb Bash;
- desplegar la mateixa aplicació amb Docker Compose;
- explicar per què canvia `DB_HOST` segons l'arquitectura;
- interpretar i modificar codi PHP;
- processar formularis;
- utilitzar funcions i estructures de control;
- mantindre informació entre pàgines mitjançant sessions;
- autenticar usuaris;
- restringir l'accés a determinades pàgines;
- treballar amb dades emmagatzemades en MariaDB;
- crear una estructura de BD des de PHP;
- verificar el funcionament i la seguretat de l'aplicació.

---

# 📊 Avaluació

| Instrument | Pes |
|---|---:|
| Sprint 1 · Arquitectura + Bash | 15 % |
| Sprint 2 · Docker | 15 % |
| Sprint 3 · PHP + BD | 10 % |
| Technical Review | 60 % |

Cada Sprint disposarà de la seua pròpia rúbrica.

La **Technical Review** serà:

- individual;
- realitzada en Moodle;
- sense ús d'Intel·ligència Artificial;
- basada exclusivament en activitats, configuracions, comprovacions i decisions treballades en les pràctiques.

> Per superar el projecte serà necessari obtindre almenys **4/10 en la Technical Review**.

---

# 🤖 Ús de la Intel·ligència Artificial

Durant els Sprints pots utilitzar eines d'IA com a suport per:

- interpretar errors;
- entendre scripts Bash;
- comprendre fitxers Docker;
- analitzar codi PHP;
- revisar configuracions;
- documentar el treball.

Però hauràs de ser capaç d'explicar què has fet, per què funciona i com has comprovat el resultat.

---

# 🏁 Projecte final

Aquest projecte tanca l'evolució tècnica del curs:

```text
SERVIDOR WEB
      ↓
CMS
      ↓
PLATAFORMA COL·LABORATIVA
      ↓
ARQUITECTURA + AUTOMATITZACIÓ + DOCKER + PHP + BD
```

L'objectiu final és que no sols sàpies executar ordres, sinó **entendre com es desplega, es connecta i evoluciona una aplicació web real**.

