# Pas 1 · Preparar l'entorn de treball

> [!NOTE]
> Aquest és el primer pas del **Projecte 1 - Infraestructura Web**.
>
> Abans de començar a desplegar aplicacions web hem de preparar el nostre entorn de treball.

---

# 🎯 Objectius

En finalitzar aquest pas seràs capaç de:

- Accedir a AWS Academy.
- Iniciar el laboratori (Learner Lab).
- Comprendre com funciona el laboratori i el seu pressupost.
- Instal·lar AWS CLI.
- Configurar les credencials d'AWS.
- Verificar que la configuració és correcta.

---

# 📚 Abans de començar

Durant aquest curs treballarem sobre **AWS Academy Learner Lab**.

Cada alumne disposa d'un laboratori amb un pressupost limitat.

> [!WARNING]
> Si deixes recursos engegats (instàncies EC2, bases de dades, etc.) continuaran consumint pressupost encara que no estigues treballant.

És molt important **aturar o eliminar els recursos** quan acabes cada sessió.

---

# 1. Accedir a AWS Academy

Rebràs un correu electrònic amb una invitació d'AWS Academy.

1. Obri el correu.
2. Prem **Comenzar**.
3. Crea el teu compte de Canvas o inicia sessió si ja en tens un.
4. Accedeix al curs assignat.

![Invitació AWS](Imatges/aws-academy-email.png)

---

# 2. Accedir al Learner Lab

Una vegada dins del curs:

1. Entra al teu curs.
2. Selecciona **Contenidos**.
3. Obri **Lanzamiento del laboratorio para el alumnado de AWS Academy**.

![Canvas](Imatges/canvas.png)

---

# 3. Llançar el laboratori

Accepta els termes d'ús.

Prem:

**Start Lab**

El laboratori començarà a preparar-se.

> [!IMPORTANT]
> Cada sessió té una duració aproximada de **4 hores**.
>
> Pots tornar a prémer **Start Lab** abans que finalitze la sessió per continuar treballant.

Espera fins que el cercle aparega en color verd.

Quan aparega en verd podràs accedir a la consola d'AWS.

![Start Lab](Imatges/start-lab.png)

---

# 4. Instal·lar AWS CLI

Treballarem tant des de la consola web com des del terminal.

Per això hem d'instal·lar **AWS CLI**.

Segueix la documentació oficial:

https://docs.aws.amazon.com/es_es/cli/latest/userguide/getting-started-install.html

Quan finalitze la instal·lació comprova que funciona:

```bash
aws --version
```

Hauries d'obtenir una eixida semblant a:

```text
aws-cli/2.x.x
```

---

# 5. Configurar AWS CLI

Obri el panell del laboratori.

Prem:

**AWS Details**

Després:

**Show**

Copia les credencials proporcionades.

Ara executa:

```bash
aws configure
```

Introdueix:

- Access Key
- Secret Key
- Region
- Output format

---

# 6. Verificar la configuració

Executa:

```bash
aws sts get-caller-identity
```

Si apareix la informació del teu usuari, la configuració és correcta.

---

## Si apareix un error

En els laboratoris d'AWS Academy és habitual que aparega un error relacionat amb el **Session Token**.

Si ocorre:

1. Accedeix a:

```text
~/.aws/credentials
```

2. Esborra el contingut del fitxer.

3. Copia íntegrament el contingut que apareix a **AWS Details**.

4. Guarda el fitxer.

5. Torna a executar:

```bash
aws sts get-caller-identity
```

Ara ja hauria de funcionar.

> [!TIP]
> Aquest procés s'haurà de repetir sempre que AWS Academy genere un nou token de sessió.

---

# ✅ Checklist

Abans de continuar comprova que:

- [ ] He accedit a AWS Academy.
- [ ] He iniciat el Learner Lab.
- [ ] He accedit a la consola AWS.
- [ ] He instal·lat AWS CLI.
- [ ] `aws --version` funciona.
- [ ] He configurat les credencials.
- [ ] `aws sts get-caller-identity` funciona correctament.

---

# 📸 Evidències

Inclou al README del Sprint les següents captures:

- AWS Academy.
- Learner Lab en funcionament.
- Consola AWS.
- Resultat de `aws --version`.
- Resultat de `aws sts get-caller-identity`.

---

# 🚀 Següent pas

Quan hages completat totes les comprovacions, continua amb:

➡️ **Pas 2 · Primera connexió a una instància EC2**