# 🐳 Sprint 2 · Docker + Docker Compose

## 🎯 Objectiu

Desplegar **la mateixa aplicació PHP + MySQL del Sprint 1**, però ara dins de contenidors Docker.

Passarem de:

```text
Sprint 1
EC2 WEB ───────── EC2 BD
```

a:

```text
Sprint 2
una EC2
└── Docker Compose
    ├── app · Apache + PHP
    ├── mysql · MySQL
    └── phpmyadmin
```

## ⏱️ Duració orientativa

**5 hores aproximadament**

## 📚 RA treballat

Principalment **RA6**:

- RA6.b · Integració PHP + MySQL.
- RA6.c · Configuració de la connexió.
- RA6.e · Obtenció i actualització de dades.
- RA6.f · Seguretat en l'accés.
- RA6.g · Verificació del funcionament.

## 📁 Fitxers

```text
02-Sprint-02-Docker/
├── README.md
├── Sprint2-Docker-Compose.md
└── docker/
    ├── Dockerfile
    ├── compose.yaml
    ├── .env.example
    ├── .gitignore
    └── prepare_app.sh
```

## 🧭 Ordre de treball

1. Crea una EC2 nova per al desplegament Docker.
2. Instal·la Docker Engine i Docker Compose.
3. Comprova la instal·lació.
4. Prepara el projecte.
5. Analitza el `Dockerfile`.
6. Modifica `config.php` perquè use variables d'entorn.
7. Analitza `compose.yaml`.
8. Crea `.env`.
9. Desplega amb `docker compose up -d --build`.
10. Comprova contenidors, xarxes i volum.
11. Prova l'aplicació i phpMyAdmin.
12. Comprova el CRUD.
13. Para i torna a iniciar el projecte.
14. Verifica que les dades persisteixen.

> ⚠️ No avances si la comprovació del pas actual falla.
