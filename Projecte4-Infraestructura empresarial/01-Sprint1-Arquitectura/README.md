# 🧱 Sprint 1 · Arquitectura de dues capes + Bash

## 🎯 Objectiu

Desplegar la mateixa aplicació LAMP que utilitzarem durant el Projecte 4, però separant-la en **dos servidors**:

```text
Internet
   │
   ▼
WEB
Apache + PHP
   │
   │ xarxa privada · port 3306
   ▼
BD
MySQL
```

A més, automatitzarem el desplegament amb **scripts Bash**.

## ⏱️ Duració orientativa

**5-6 hores**

## 📚 RA treballat

Principalment **RA6**:

- RA6.a · SGBD utilitzats en entorns web.
- RA6.b · Integració PHP + MySQL.
- RA6.c · Configuració de la connexió.
- RA6.e · Consulta i modificació de dades.
- RA6.f · Seguretat en l'accés.
- RA6.g · Verificació del funcionament.

> RA6.d es completarà en el Sprint 3.

## 📁 Fitxers

```text
01-Sprint-01-Arquitectura-Bash/
├── README.md
├── Sprint1-Arquitectura-Bash.md
└── scripts/
    ├── .env.example
    ├── .gitignore
    ├── install_backend.sh
    ├── install_frontend.sh
    └── deploy_app.sh
```

## 🧭 Ordre de treball

1. Llig `Sprint1-Arquitectura-Bash.md`.
2. Crea les dues EC2 i els grups de seguretat.
3. Anota les IP privades i la IP pública del servidor WEB.
4. Crea el teu `.env` a partir de `.env.example`.
5. Executa i comprova el backend.
6. Executa i comprova el frontend.
7. Desplega l'aplicació.
8. Verifica la connexió WEB → BD.
9. Prova el CRUD.
10. Entrega les evidències indicades.

> ⚠️ No avances al pas següent si la comprovació del pas actual falla.
