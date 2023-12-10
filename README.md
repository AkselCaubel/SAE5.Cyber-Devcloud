## Synthèse
### Membres du groupe :
Tim, Aksel, Léo

### Lien GitHub :

https://github.com/AkselCaubel/SAE5.Cyber-Devcloud

### Bilan des rendus :
Au cours de ces semaines où nous avons travaillé sur le déploiement de solutions de défense dans un environnement vulnérable (GOAD), nous avons pu réaliser plusieurs tâches qui sont toutes réparties ci-dessous. Cela va de l'automatisation au déploiement de SIEMs connus comme Wazuh,Splunk et la suite Elastic jusqu'à l'attaque et donc la confirmation de fonctionnement de notre infrastructure. On peut résumer notre travail en quelques points importants :

### L'organisation :
- Utilisation de l'onglet 'Projects' de Github pour avoir un suivi des tâches. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/projects?query=is%3Aopen) /!\**Pour voir cette partie vous devez accepter l'invitation reçue** /!\
- Utilisation de la plateforme Slack pour la communication. 

### Le déploiement :
- Installation de l'environnement GOAD avec VirtualBox. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/Installation%20GOAD/Virtual-Box/GOAD-vbox-install.md)
- Installation de l'environnement GOAD avec Proxmox. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/Installation%20GOAD/Proxmox/GOAD-proxmox-install.md)
- Installation de SIEMs : Splunk, Wazuh, ELK. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/tree/main/SIEM)
- Mise en place d'un serveur de logs : OpenWEC. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/PDF/OpenWEC-Install.pdf)
- Mise en place d'un accès distant VPN avec OpenVPN.

### L'automatisation :
- Scripts (Bash et Ansible) permettant l'installation de Wazuh sur une machine Debian 12 vierge ainsi que le déploiement des agents nécessaires (avec l'ajout de Sysmon) et qui configure également le serveur directement. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/SIEM/Installation-Wazuh/Deploy-Wazuh-for-GOAD/Deployer-Wazuh.sh)
- Scripts (Bash et Ansible) permettant l'installation de Splunk sur une machine Debian 12 vierge ainsi que le déploiement des agents nécessaires. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/SIEM/Installation-Splunk/Splunk-Deployer.sh)
- Mise en place avec Terraform et Ansible de la stack ELK avec le déploiement automatisé des agents. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/SIEM/installation-ELK/installation-ELK.md)

### La sécurisation :
- Réalisation d'un tutoriel complet pour créer des règles Wazuh ainsi que l'utilisation de l'active response (IPS). [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/SIEM/Installation-Wazuh/Affiner-regles-Wazuh/Affiner-des-regles-sur-Wazuh.md)
- Mise en place de l'IDS Suricata sur la stack ELK.
- Lecture de logs avec Chainsaw et Hayabusa. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/Hayabusa%20%26%20Chainsaw/Installation%20%26%20utilisation.md)

### Un PoC de fonctionnement :
- Détection d'une attaque de type Kerberoasting [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/Attaque-AD/Attaque-AD-POC.md)

### Un audit de l'infrastructure GOAD :
- Réalisation d'une 'cheatsheet' pour permettre le pentest d'un environnement GOAD. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/Cheatsheet/Cheatsheet-Pentest-AD.md)
- Audit de l'infrastructure GOAD en mode RedTeam. [Ici](https://github.com/AkselCaubel/SAE5.Cyber-Devcloud/blob/main/Pentest%26Reaction-GOAD/Pentest-Goad.md)

### Ce qu'on aurait voulu approfondir :
Nous n'avons malheureusement pas eu le temps d'approfondir plus la partie RedTeam sur le test de pénétration ainsi que sur le côté sécurité avec l'implémentation des règles Sigma.

### Schéma réseau de l'infrastructure virtualisée avec VirtualBox :
![Alt text](Synth%C3%A8se/img/schema-reseau-vbox.png)

### Schéma réseau de l'infrastructure virtualisée avec Proxmox :
![Alt text](Synth%C3%A8se/img/schema-reseau.png)
