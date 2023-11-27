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