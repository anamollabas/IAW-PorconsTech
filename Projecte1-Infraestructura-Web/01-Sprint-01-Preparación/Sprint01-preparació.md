# Pas 1 · Preparar l'entorn de treball

> [!NOTE]
> Aquest és el primer pas del **Sprint 1 · Preparació** del **Projecte 1 · Infraestructura Web**.
>
> Abans de començar a desplegar aplicacions web, prepararem l'entorn de treball que utilitzarem durant el projecte.

---

## 🎯 Objectius

En finalitzar aquest pas seràs capaç de:

- Accedir a AWS Academy.
- Iniciar el laboratori AWS Academy Learner Lab.
- Comprendre com funciona el laboratori i el seu pressupost.
- Instal·lar AWS CLI.
- Configurar les credencials del laboratori.
- Verificar que AWS CLI funciona correctament.

---

## 1. Accedir a AWS Academy

Rebràs al teu correu corporatiu una invitació d'**AWS Academy**.

Obri el correu i accedeix a l'enllaç d'invitació.

![Invitació a AWS Academy](Imatges/01-invitacio-aws-academy.png)

Si és la primera vegada que utilitzes AWS Academy, hauràs de crear el teu compte.  
Si ja disposes d'un compte, inicia sessió amb les teues credencials.

---

## 2. Accedir al curs i al Learner Lab

Una vegada registrat, accediràs al panell principal.

Selecciona el curs d'AWS Academy en el qual estàs matriculat.

![Panell d'AWS Academy](Imatges/02-panell-canvas.png)

Dins del curs, accedeix al contingut del **Learner Lab**.

Selecciona l'opció de llançament del laboratori.

![Accés al Learner Lab](Imatges/03-launch-lab.png)

---

## 3. Iniciar el laboratori

Abans d'utilitzar el laboratori hauràs d'acceptar les condicions d'ús.

Després, prem:

**Start Lab**

![Iniciar el laboratori](Imatges/04-start-lab.png)

Espera uns instants fins que el laboratori estiga preparat.

Quan l'indicador aparega en verd, prem sobre **AWS** per accedir a la consola.

> [!WARNING]
> El laboratori disposa d'un pressupost limitat.
>
> No deixes recursos en funcionament quan ja no els necessites. Les instàncies EC2, bases de dades i altres serveis poden continuar consumint pressupost encara que no estigues treballant.

---

## 4. Accedir a la consola d'AWS

Quan el laboratori estiga actiu, podràs accedir a la consola d'administració d'AWS.

![Consola d'AWS](Imatges/05-consola-aws.png)

Des d'aquesta consola podrem crear i administrar els diferents serveis que utilitzarem durant el curs.

---

## 5. Instal·lar AWS CLI

AWS també es pot administrar des del terminal mitjançant **AWS CLI (Command Line Interface)**.

AWS CLI ens permet executar ordres contra la infraestructura sense utilitzar la consola gràfica.

Consulta les instruccions oficials d'instal·lació d'AWS CLI i selecciona el teu sistema operatiu.

![Instal·lació d'AWS CLI](Imatges/06-install-aws-cli.png)

Quan finalitze la instal·lació, obri un terminal i executa:

```bash
aws --version