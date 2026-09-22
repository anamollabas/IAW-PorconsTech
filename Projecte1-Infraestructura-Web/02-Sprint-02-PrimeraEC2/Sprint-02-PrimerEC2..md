# 🌩️ Sprint pont · La nostra primera EC2

## 🎯 Objectiu

En l'Sprint anterior has preparat l'entorn d'AWS Academy i has comprovat que pots treballar amb AWS CLI.

Abans d'instal·lar un servidor LAMP necessitem una cosa més:

> **crear el nostre primer servidor virtual en AWS, connectar-nos-hi i comprovar que realment podem executar un servei.**

En acabar tindràs:

```text
Internet
   │
   │ SSH
   ▼
┌─────────────────────────────┐
│ EC2 · porconstech-web       │
│ Ubuntu Server               │
│                             │
│ IP pública  → accés extern  │
│ IP privada  → xarxa AWS     │
└─────────────────────────────┘
```

Aquesta **mateixa EC2** serà la que utilitzarem en l'Sprint següent per instal·lar Apache, PHP i MySQL.

---

# 1. Abans de començar

Comprova que:

- [ ] El Learner Lab està iniciat.
- [ ] L'indicador del laboratori està en verd.
- [ ] Pots accedir a la consola d'AWS.
- [ ] Tens AWS CLI instal·lada.
- [ ] Les credencials del laboratori estan actualitzades.
- [ ] `aws sts get-caller-identity` respon correctament.

Executa al teu ordinador:

```bash
aws sts get-caller-identity
```

### ✅ Comprovació 1

Si obtens informació de la identitat AWS, pots continuar.

Si apareix un error de credencials o token caducat, **no crees encara la instància**. Torna a AWS Details i actualitza les credencials del laboratori.

---

# 2. Què és una EC2?

**Amazon EC2 (Elastic Compute Cloud)** permet crear màquines virtuals en la infraestructura d'AWS.

Pensa en una EC2 com una màquina virtual que ja no està dins del teu ordinador:

```text
VirtualBox                         AWS

┌───────────────┐                 ☁️
│ Ubuntu Server │        →    ┌───────────────┐
│ dins del PC   │             │ Ubuntu Server │
└───────────────┘             │ en una EC2    │
                              └───────────────┘
```

Per crear-la haurem de prendre algunes decisions:

| Element | Què significa? |
|---|---|
| **AMI** | Plantilla a partir de la qual crearem la màquina. Inclou el sistema operatiu. |
| **Instance type** | Recursos de CPU i memòria assignats. |
| **Key pair** | Clau utilitzada per autenticar-nos quan accedim per SSH. |
| **Security Group** | Firewall d'AWS que controla el trànsit permés. |
| **IP privada** | Adreça utilitzada dins de la xarxa d'AWS. |
| **IP pública** | Adreça des de la qual podem arribar a la instància des d'Internet. |

> 🧠 **Idea important:** crear una EC2 no és només prémer *Launch*. També hem de pensar **com accedirem a ella i quins ports volem permetre**.

---

# 3. Crear la primera instància

En la consola d'AWS busca:

```text
EC2
```

Entra en:

```text
EC2 → Instances → Launch instances
```

## 3.1. Nom

Utilitza:

```text
porconstech-web
```

Aquest nom serà important perquè aquesta màquina continuarà utilitzant-se en el següent Sprint.

---

# 4. Triar la imatge del sistema

En **Application and OS Images (AMI)** selecciona:

```text
Ubuntu Server 24.04 LTS
64-bit (x86)
```

### 🧠 Què és l'AMI?

L'AMI és la plantilla de la màquina.

En aquest cas ens proporciona una instal·lació preparada d'Ubuntu Server.

### ✅ Comprovació 2

Abans de continuar comprova que has seleccionat **Ubuntu Server**, no Amazon Linux ni Windows.

---

# 5. Triar el tipus d'instància

Selecciona:

```text
t3.micro
```

si està disponible en el teu Learner Lab.

Si el laboratori no la permet, utilitza el **tipus micro autoritzat pel laboratori**.

### 🧠 Què determina l'Instance Type?

Principalment:

```text
CPU
RAM
capacitat de xarxa
cost
```

En aquest projecte no necessitem una màquina potent.

---

# 6. Clau d'accés

En **Key pair** selecciona la clau proporcionada pel Learner Lab.

Habitualment apareixerà com:

```text
vockey
```

Des d'**AWS Details** pots descarregar el fitxer privat associat al laboratori, habitualment:

```text
labuser.pem
```

Guarda'l en una ubicació que pugues localitzar.

> 🔐 **No publiques mai el fitxer `.pem` en GitHub, Moodle ni cap repositori.**

---

# 7. Configurar la xarxa i la seguretat

Ara arriba una de les parts més importants.

En **Network settings** utilitzarem la VPC i la subxarxa disponibles en el Learner Lab i comprovarem que la instància disposa d'IP pública.

Crea un nou Security Group:

```text
sg-porconstech-web
```

Descripció:

```text
Acces inicial a porconstech-web
```

## Regla d'entrada

Crea només:

| Tipus | Protocol | Port | Origen |
|---|---|---:|---|
| SSH | TCP | 22 | **My IP** |

> ⚠️ No utilitzes `0.0.0.0/0` per a SSH si no és necessari.

### 🧠 Què estem fent?

El Security Group actua com un firewall.

```text
Internet
   │
   │ port 22 permés des de la teua IP
   ▼
Security Group
   │
   ▼
EC2
```

Si un port **no està autoritzat**, AWS bloqueja el trànsit abans que arribe a la màquina.

---

# 8. Emmagatzematge

Per a aquesta pràctica pots mantindre l'emmagatzematge per defecte proposat per la instància.

No necessitem afegir discos nous.

---

# 9. Llançar la instància

Revisa el resum.

Has de tindre aproximadament:

```text
Nom:            porconstech-web
Sistema:        Ubuntu Server 24.04 LTS
Tipus:          micro
Key pair:       clau del Learner Lab
Security Group: sg-porconstech-web
SSH:            port 22 des de My IP
```

Prem:

```text
Launch instance
```

Després entra en:

```text
EC2 → Instances
```

Espera fins que aparega:

```text
Instance state: Running
Status check:   2/2 checks passed
```

> No intentes connectar-te fins que les comprovacions d'estat estiguen superades.

---

# 10. Identificar la màquina

Selecciona `porconstech-web` i localitza:

```text
Instance ID
Public IPv4 address
Private IPv4 address
Public IPv4 DNS
Security Group
Instance type
```

Anota:

```text
INSTANCE_ID =
IP_PUBLICA =
IP_PRIVADA =
DNS_PUBLIC =
```

### 🧠 Observa

Tenim **dues IP diferents**.

- La **IP pública** ens permet arribar a la màquina des d'Internet.
- La **IP privada** identifica la màquina dins de la xarxa d'AWS.

Més avant aquesta diferència serà molt important quan separem servidor WEB i servidor de base de dades.

📸 **Evidència 1:** detalls de la instància on es veja l'estat `Running`, l'IP pública i l'IP privada.

---

# 11. Comprovar la instància amb AWS CLI

Ara connectarem aquest Sprint amb allò que ja havies fet amb AWS CLI.

Al teu ordinador executa:

```bash
aws ec2 describe-instances \
  --instance-ids INSTANCE_ID \
  --query "Reservations[0].Instances[0].{State:State.Name,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,Type:InstanceType}" \
  --output table
```

Substitueix:

```text
INSTANCE_ID
```

pel valor real.

### ✅ Comprovació 3

La informació de la terminal ha de coincidir amb la que mostra la consola gràfica d'AWS.

### 🧠 Pensa

Acabes de consultar **el mateix recurs** de dues formes:

```text
Consola web AWS
      │
      ├──── mateixa EC2
      │
AWS CLI
```

📸 **Evidència 2:** resultat del `describe-instances`.

---

# 12. Preparar la clau SSH

## Linux / macOS

Situa't en la carpeta on tens la clau i executa:

```bash
chmod 400 labuser.pem
```

## Windows

Si utilitzes PowerShell, normalment podràs utilitzar directament la clau guardada dins de la teua carpeta d'usuari.

Si SSH mostra un error indicant que la clau privada té **massa permisos**, fes:

```text
Botó dret sobre labuser.pem
→ Propietats
→ Seguretat
→ Opcions avançades
→ Deshabilitar herència
→ mantindre accés únicament per al teu usuari
```

> El nom exacte del fitxer pot variar segons el Learner Lab. Utilitza el fitxer `.pem` que aparega en AWS Details.

---

# 13. Primera connexió SSH

La sintaxi serà:

```bash
ssh -i RUTA_CLAU.pem ubuntu@IP_PUBLICA
```

Per exemple, en PowerShell:

```powershell
ssh -i "$HOME\Downloads\labuser.pem" ubuntu@IP_PUBLICA
```

La primera vegada és possible que aparega:

```text
Are you sure you want to continue connecting?
```

Escriu:

```text
yes
```

Si tot funciona veuràs una terminal semblant a:

```text
ubuntu@ip-172-31-xx-xx:~$
```

### 🧠 Per què utilitzem `ubuntu`?

Perquè és l'usuari de connexió habitual de l'AMI d'Ubuntu que hem seleccionat.

Altres AMI poden utilitzar altres noms d'usuari.

### ✅ Comprovació 4

Executa:

```bash
whoami
```

Resultat esperat:

```text
ubuntu
```

📸 **Evidència 3:** terminal SSH mostrant `whoami`.

---

# 14. Conéixer el servidor

Executa una a una:

```bash
hostname
```

```bash
uname -a
```

```bash
ip -br a
```

```bash
hostname -I
```

```bash
uptime
```

```bash
free -h
```

```bash
df -h
```

## Què estem comprovant?

| Ordre | Què observem? |
|---|---|
| `hostname` | Nom intern de la màquina |
| `uname -a` | Informació del sistema |
| `ip -br a` | Interfaces i IP configurades |
| `hostname -I` | IP de la màquina dins d'AWS |
| `uptime` | Temps que porta en funcionament |
| `free -h` | Memòria RAM |
| `df -h` | Espai de disc |

### 🧠 Pregunta important

Compara:

```text
IP que mostra hostname -I
```

amb:

```text
Private IPv4 address de la consola AWS
```

Han de correspondre.

En canvi, és normal que la **IP pública no aparega configurada directament en la interfície de xarxa d'Ubuntu**.

---

# 15. Comprovar accés a Internet

Executa:

```bash
sudo apt update
```

No instal·larem encara LAMP.

Ara només volem comprovar que:

```text
EC2 → pot eixir a Internet → pot contactar amb els repositoris d'Ubuntu
```

### ✅ Comprovació 5

`apt update` ha de poder consultar els repositoris sense errors de connectivitat.

> Si apareixen paquets actualitzables, no és necessari instal·lar-los ara.

---

# 16. Una prova molt xicoteta: el nostre primer servei

Abans d'instal·lar Apache farem una prova temporal.

Comprova que Python està disponible:

```bash
python3 --version
```

Crea una carpeta:

```bash
mkdir -p ~/miniweb
cd ~/miniweb
```

Crea una pàgina:

```bash
cat > index.html <<'EOF'
<!doctype html>
<html lang="ca">
<head>
    <meta charset="utf-8">
    <title>PorçonsTech</title>
</head>
<body>
    <h1>La meua primera EC2 funciona 🚀</h1>
    <p>Servidor temporal de prova de PorçonsTech.</p>
</body>
</html>
EOF
```

Ara intenta iniciar:

```bash
python3 -m http.server 8000 --bind 0.0.0.0
```

Veuràs aproximadament:

```text
Serving HTTP on 0.0.0.0 port 8000
```

## Però encara falta una cosa

Si intentes obrir:

```text
http://IP_PUBLICA:8000
```

és possible que **no funcione**.

Per què?

Perquè el Security Group només permet actualment:

```text
22/TCP
```

---

# 17. Obrir temporalment el port 8000

En AWS:

```text
EC2
→ Security Groups
→ sg-porconstech-web
→ Inbound rules
→ Edit inbound rules
```

Afig:

| Tipus | Protocol | Port | Origen |
|---|---|---:|---|
| Custom TCP | TCP | 8000 | **My IP** |

Guarda els canvis.

Ara torna al navegador:

```text
http://IP_PUBLICA:8000
```

### ✅ Comprovació 6

Has de veure:

```text
La meua primera EC2 funciona 🚀
```

📸 **Evidència 4:** navegador mostrant la pàgina servida des de la teua EC2.

---

# 18. Què acaba de passar?

Perquè la pàgina arribara al teu navegador han hagut de funcionar diverses coses:

```text
Navegador
    │
    │ HTTP :8000
    ▼
IP pública EC2
    │
    ▼
Security Group
    │ port 8000 autoritzat
    ▼
Ubuntu Server
    │
    ▼
python3 http.server
    │
    ▼
index.html
```

Si una d'aquestes peces falla, no veuràs la pàgina.

Aquesta idea serà fonamental en el següent Sprint quan substituïm el servidor temporal de Python per **Apache**.

---

# 19. Tancar correctament la prova

Torna a la terminal on està executant-se Python i prem:

```text
Ctrl + C
```

El servidor temporal queda aturat.

Ara torna al Security Group i **elimina la regla del port 8000**.

Al final només ha de quedar la regla SSH que necessites.

### ✅ Comprovació 7

Després d'eliminar la regla, la URL:

```text
http://IP_PUBLICA:8000
```

ja no ha de ser accessible.

### 🧠 Per què eliminem la regla?

Perquè no hem de deixar ports oberts si ja no existeix cap necessitat de servei.

---

# 20. No elimines aquesta EC2

Aquesta instància és:

```text
porconstech-web
```

i serà reutilitzada en el següent Sprint per instal·lar:

```text
Apache
PHP
MySQL
```

Per tant:

### ✅ Pots fer

```text
Stop instance
```

si has acabat la classe i vols evitar consum innecessari.

### ❌ No faces

```text
Terminate instance
```

ni:

```text
Reset Lab
```

si vols conservar el treball.

> **Stop** deté la màquina però conserva el recurs.  
> **Terminate** elimina la instància.  
> **Reset Lab** pot eliminar els recursos creats dins del laboratori.

---

# 21. Diagnòstic d'errors

## SSH no connecta

Comprova, en aquest ordre:

```text
1. Learner Lab iniciat?
2. EC2 en estat Running?
3. Status checks 2/2?
4. Estàs utilitzant la IP pública actual?
5. Security Group permet TCP 22 des de la teua IP?
6. Usuari correcte: ubuntu?
7. Fitxer .pem correcte?
```

No canvies cinc coses alhora.

---

## `Permission denied (publickey)`

Comprova:

```text
usuari → ubuntu
clau   → la del Learner Lab
```

i els permisos del fitxer `.pem`.

---

## La pàgina del port 8000 no funciona

Comprova:

```text
1. El servidor Python continua executant-se?
2. Has escrit la IP pública correcta?
3. Has posat :8000 en la URL?
4. El Security Group permet TCP 8000 des de My IP?
```

---

## `aws ec2 describe-instances` dona error

Comprova:

```bash
aws sts get-caller-identity
```

Si falla, probablement les credencials del Learner Lab han caducat i cal actualitzar-les.

---

# 22. Evidències

Entrega únicament evidències que demostren que el procés ha funcionat:

1. EC2 `porconstech-web` en estat `Running`, amb IP pública i privada.
2. Consulta de la mateixa instància amb AWS CLI.
3. Connexió SSH correcta i resultat de `whoami`.
4. Mini web accessible pel port 8000.
5. Security Group final, amb la regla temporal 8000 ja eliminada.

> No captures ni publiques la clau privada, credencials AWS, tokens o contrasenyes.

---

# 23. Preguntes finals

Respon breument amb les teues paraules.

### 1.
Què és una instància EC2?

### 2.
Quina funció té una AMI quan creem una EC2?

### 3.
Quina diferència has observat entre la IP pública i la IP privada?

### 4.
Per a què serveix el Security Group?

### 5.
Per què hem autoritzat SSH només des de `My IP`?

### 6.
Per què el navegador no podia arribar inicialment al servidor Python del port 8000?

### 7.
Quines dues coses havien d'estar correctes perquè funcionara la prova del port 8000?

### 8.
Per què eliminem després la regla del port 8000?

### 9.
Quina relació hi ha entre la informació mostrada per la consola AWS i la recuperada amb AWS CLI?

### 10.
Quina diferència pràctica hi ha entre **Stop** i **Terminate**?

---

# ✅ Checklist final

Abans de donar el Sprint per acabat comprova:

- [ ] He creat `porconstech-web`.
- [ ] La instància utilitza Ubuntu Server.
- [ ] He identificat l'AMI i l'Instance Type.
- [ ] Conec la IP pública i la IP privada.
- [ ] El port SSH no està obert a tot Internet.
- [ ] AWS CLI localitza la mateixa instància.
- [ ] Puc connectar-me per SSH.
- [ ] `whoami` retorna `ubuntu`.
- [ ] He identificat la IP privada des d'Ubuntu.
- [ ] `sudo apt update` té connectivitat.
- [ ] He executat el servidor temporal del port 8000.
- [ ] He comprovat la pàgina des del navegador.
- [ ] He aturat el servidor temporal.
- [ ] He eliminat la regla temporal del port 8000.
- [ ] No he publicat cap credencial ni clau.
- [ ] **No he terminat la instància.**
- [ ] He contestat les preguntes finals.

---

# 🏁 Sprint completat

Ara ja tens el primer servidor de PorçonsTech:

```text
AWS Academy
     ↓
AWS CLI
     ↓
EC2 Ubuntu
     ↓
SSH
     ↓
Security Group
     ↓
primer servei temporal
```

En el següent Sprint convertirem aquesta EC2 en un servidor web real instal·lant la pila **LAMP**.
