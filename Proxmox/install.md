## Aksel
## CAUBEL
### RT3-App Dev-Cloud

# Installation Proxmox

> ## Utilisation de l'Idrac

>## Creds
>```js
>user = root
>mdp = root
>ip = 10.202.3.3
>```
>
>```js
>ip Proxmox : 10.202.3.33
>identifiant Proxmox : root
>mot de pass Proxmox : rootroot
>```

On va venir faire une installation via l'interface Idrac.

Pour ce faire on va entrer dans la partie ```configuration``` -> ```Média Virtuel```.
Le but est de faire un mapping de notre OS Proxmox *Utilisation de la version 7.4*

On vient ensuite **Connecter le média virtuel**

![mapping-iso](img/mapping-iso.png)

Une fois l'iso connecté on va choisir proxmox, on vient dans la console virtuelle dans ```démarrer```->```Boot action```->```CD/DVD/ISO``` pour qu'au prochain démarrage l'on puisse réaliser l'installation de ***proxmox***.
![boot-action](img/boot-action.png)
Pour faire le redémarrage a chaud a distance, on va revenir sur l'interface *Idrac* dans ```configuration```->```Gestion de l'alimentation``` et ensuite dans la partie *Contrôle de l'alimentation* choisir l'option **Rénitialiser le système (redémarrage à chaud)**
![redemarrage-a-chaud](img/redemarrage-chaud.png)
Maintenant nous pouvons commencer a suivre les instructions de Proxmox :
![acceuil-install](img/acceuil-install-proxmox.png)

Une fois les instructions suivit on retrouve cette configuration dans notre cas.
![summary-conf-proxmox](img/conf-summary-proxmox.png)

L'interface graphique est maintenant disponible sur le port [8006](https://10.202.3.33:8006/)

# Mise en place de GOAD sur *Proxmox*

> ## Mise en place dde l'architecture
[Source d'instruction](https://mayfly277.github.io/posts/GOAD-on-proxmox-part1-install/)

La configuration initial donner nous demande crée des interfaces réseaux supplémentaire :

- 3 Bridge Linux
- 2 VLAN Linux

Pour ce faire, dans la partie ***Datacenter*** *(volet de gauche)* on va aller dans notre ***Node*** ici appelé ```pv7``` puis aller dans l'onglet ```Système``` -> ```Network```.

Pour la création des bridges / VLANs, tous va se faire dans l'onglet ```Create``` : 

![create-network](img/create-network.png)

Voici un extrait des prérequis : 

```
The network we will build will be in multiple part :

- 10.0.0.0/30 (10.0.0.1-10.0.0.2) : this will be the WAN network with only 2 ips, one for proxmox host, and the other one for pfsense
- 192.168.1.1/24 (192.168.1.1-192.168.1.254) : this will be the LAN network for the pfsense and the provisioning machine
- 192.168.10.1/24 (192.168.10.1-192.168.10.254) : VLAN1 for the GOAD’s vm
- 192.168.20.1/24 (192.168.20.1-192.168.20.254) : VLAN2 for future projects
- 10.10.10.0/24 (10.10.10.0-10.10.10.254) : openvpn for vpn users (will be manage by pfsense later)
```

>Création d'un Bridge : 

![create-bridge](img/create-bridge.png)

>Création d'un VLAN : 

![create-VLAN](img/create-vlan.png)

Par la suite il nous est demandé de faire l'installation d'une ISO PFSence.
On va pouvour procéder ainsi : 

![install-iso](img/proxmox-iso-install.png)

On va ensuite pouvoir crée notre première VM en commençant par *PfSense* ***Ne pas démarrer la VM a sa création***:
![create-pfsense1](img/pfsense-install/create-pfsense.png)

Une fois que la VM est crée avec la configuration ci-dessus, on va venir lui rajouter des interfaces réseaux que nous avons précédement crée de cette manière :

![add-network-device](img/pfsense-install/add-network-device.png)

Le résultat attendu est d'avoir :

![result](img/pfsense-install/result-add-network.png)

Maintenant que *PfSense* est configuré on peut démarrer la machine.

> Entrez dans la console depuis *Proxmox*
![proxmox-shell](img/pfsense-install/pfsense-shell.png)

Suivez le guide d'installation jusqu'à l'option ```reboot```

### Configuration réseau

> VLAN(s)

On ne souhaite pas configurer de VLAN : 

![vlan-setting](img/pfsense-install/Vlan-choice.png)

> Interfaces

Précédement nous avons attribuée les ```devices``` réseaux vtnet{1,2,3}. ***Attention, dans PfSense le compteur est revenue a partir de 0. Nous aurons alors vtnet1 -> vtnet0 et ainsi de suite***.

![device-setting](img/pfsense-install/interface-choice.png)

Les choix fait précédement nous menerons a la configuration suivante : 

![set-ip](img/pfsense-install/set-ip.png)

> Configuration Réseau

![network-setting](img/pfsense-install/set%20wan.png)
![network-setting-next](img/pfsense-install/set-gateway.png)

Nous aurons alors le résultat de configuration suivant :

![end setting](img/pfsense-install/end-conf.png)

Une fois la configuration générique faite, on va venir faire une configuration plus précise pour l'interface *LAN* en fesant :

- Un changement d'adresse IP -> 192.168.1.2/24
  - Sans mettre de passerelle
  - Pas d'IPv6
- Un serveur DHCP (pool : 192.168.1.100 <-> 192.168.1.254)

![interface-LAN-1](img/pfsense-install/interface-LAN-1.png)
![interface-LAN-2](img/pfsense-install/interface-LAN-2.png)
![interface-LAN-3](img/pfsense-install/interface-LAN-3.png)
![interface-LAN-4](img/pfsense-install/interface-LAN-4.png)

### Configuration suite en GUI

> Port-forwarding

Afin d'avoir accès a l'interface graphique sur notre poste nous devons faire un *port-forwarding* de l'host 192.168.1.2:80 vers notre machine avec un port client quelconque *(ici le 8082)*

Pour ce faire on viens faire un ```ssh```**```-L```**

```bash
ssh-L 8082:192.168.1.2:80 root@10.202.3.33 #Ip proxmox
```

> Interface WEB  
> *User: admin | passwd : pfsense*

![Page d'acceuil]()

Après connexion appuyer sur ***Next*** deux fois pour arriver sur cette page :

![step2]()

Changer le Domain présent pour **```goad.lab```**

Pour la configuration **NTP** vous pouvez le laisser par défaut et ensuite entrez *NEXT*.

L'interface WAN **doit être** laissée par défaut.  
Sur cette même page vous devais enlever le bloque ***RFC1918 private network***. Appuyer sur *NEXT*.  
![RFC-uncheck]()

Laissez l'interface LAN comme il vous est affichée. *NEXT*

Changez le mot de passe admin *(ici on a choisit la sécurité :D => passwd = admin)*

> ## Configuration de Terraform

Avant de lancer la procédure de création il faut renseigner les variables de connexion pour le serveur ***Proxmox*** dans le fichier ```GOAD/ad/GOAD/providers/proxmox/terraform/variables.tf.template```

Attention, pour que ***Terraform*** prenne en compte le fichier variables.tf, il faut changer l'extention en enlevant le ```.template```. Dans l'optique d'avoir une version de sauvegarde en local on peut faire une copie du fichier avant de faire des modifications.

dans notre cas la configuration correspondra a :

```json
variable "pm_api_url" {
  default = "https://10.202.3.33:8006/api2/json"
}

variable "pm_user" {
  default = "root@pam"
}

variable "pm_password" {
  default = "rootroot"
}

variable "pm_node" {
  default = "proxmox-goad"
}

variable "pm_pool" {
  default = "GOAD"
}

variable "pm_full_clone" {
  default = false
}
```

# Provisionning Proxmox via Ansible

[Source d'instruction](https://mayfly277.github.io/posts/GOAD-on-proxmox-part4-ansible/)

> ## configuration : 

Afin de mener a bien le provisionning via Ansible on va venir installer les dependencies du projet se trouvant dans le fichier ```GOAD/ansible/requirements.yml``` via la commande suivante : 

```bash
ansible-galaxy install -r requirements.yml
```

Dans ces requirements on va retrouvez par exemple la capacité a utiliser Ansible sur le système Windows.

Pour continuer l'installation avec les scripts d'installation fournit; On vient *set* la variable d'environnement suivant pour 


Dans le but d'également mettre les agents des SIEM directement sur le réseau, on va pouvoir mettre en place 
