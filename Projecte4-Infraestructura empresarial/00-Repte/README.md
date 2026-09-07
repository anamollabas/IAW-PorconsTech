# 🏢 El repte · Evolucionar l'aplicació de PorçonsTech

# 🏢 El repte · Evolucionar l'aplicació de PorçonsTech

PorçonsTech necessita professionalitzar el desplegament de les seues aplicacions.

Fins ara l'empresa ha treballat amb serveis instal·lats i configurats de manera relativament manual.

Ara vol comprovar tres coses:

1. si pot separar els serveis web i de base de dades;
2. si pot automatitzar i reproduir els desplegaments;
3. si el seu equip és capaç d'entendre i evolucionar el codi de l'aplicació.

---

# 🎯 La missió

Treballaràs amb una aplicació web PHP + MySQL.

La mateixa aplicació passarà per tres fases.

---

## Fase 1 · Separar i automatitzar

Construiràs:

```text
SERVIDOR WEB
Apache + PHP
      │
      │ xarxa privada
      ▼
SERVIDOR BD
MySQL
```

Els dos serveis funcionaran en màquines independents.

A més, automatitzaràs part de la instal·lació amb **scripts Bash**.

---

## Fase 2 · Conteneritzar

Desplegaràs la mateixa aplicació mitjançant:

- Docker;
- Dockerfile;
- Docker Compose;
- xarxes;
- volums;
- variables d'entorn.

La connexió entre aplicació i base de dades ja no dependrà d'una IP privada, sinó de la xarxa i els serveis definits en Docker Compose.

---

## Fase 3 · Evolucionar el codi

Finalment, hauràs de treballar directament amb PHP.

L'aplicació evolucionarà per incorporar:

- formularis;
- funcions;
- estructures de control;
- sessions;
- autenticació;
- restricció d'accés;
- treball amb dades;
- creació d'estructures de BD des de PHP.

---

# 🔎 Preguntes que hauràs de poder respondre

En acabar el projecte hauràs de poder explicar:

- Per què podem separar servidor web i base de dades?
- Per què `DB_HOST` no sempre és `localhost`?
- Quina diferència hi ha entre una IP privada i el nom d'un servei Docker?
- Què automatitza un script Bash?
- Quina diferència hi ha entre una EC2 i un contenidor?
- Quina funció té Docker Compose?
- Com es comuniquen els serveis dins d'una xarxa Docker?
- Com genera PHP contingut HTML?
- Com processa PHP un formulari?
- Com podem conservar informació entre diferents pàgines?
- Com podem saber quin usuari ha iniciat sessió?
- Com podem impedir que un usuari no autenticat accedisca a una pàgina?
- Com es connecta PHP amb MySQL?
- Com podem consultar i modificar dades des de PHP?

---

# ✅ Producte final

Hauràs de demostrar:

- arquitectura WEB + BD funcional;
- connexió privada entre serveis;
- automatització amb Bash;
- aplicació CRUD funcionant;
- desplegament amb Docker Compose;
- persistència de dades;
- codi PHP modificat;
- formularis funcionals;
- sessions i autenticació;
- accés a BD;
- comprovacions finals.

---

# 🏁 Objectiu final

En aquest projecte farem el pas de:

**separar → automatitzar → conteneritzar → programar**

És l'última evolució de PorçonsTech durant el curs.
