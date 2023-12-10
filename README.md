## Synthèse

### Bilan des rendus :
Au cours de ces semaines où nous avons travaillé sur le déploiement de solutions de défense dans un environnement vulnérable (GOAD), nous avons pu réaliser plusieurs tâches qui sont toutes réparties ci-dessous. Cela va de l'automatisation au déploiement de SIEMs connus comme Wazuh,Splunk et la suite Elastic jusqu'à l'attaque et donc la confirmation de fonctionnement de notre infrastructure. On peut résumer notre travail en quelques points importants :

### Le déploiement :
- Installation de l'environnement GOAD avec VirtualBox.
- Installation de l'environnement GOAD avec Proxmox.
- Installation de SIEMs : Splunk, Wazuh, ELK.
- Mise en place d'un serveur de logs : OpenWEC.

### L'automatisation :
- Scripts (Bash et Ansible) permettant l'installation de Wazuh sur une machine Debian 12 vierge ainsi que le déploiement des agents nécessaires (avec l'ajout de Sysmon) et qui configure également le serveur directement. 
- Scripts (Bash et Ansible) permettant l'installation de Splunk sur une machine Debian 12 vierge ainsi que le déploiement des agents nécessaires.
- Mise en place avec Terraform et Ansible de la stack ELK avec le déploiement automatisé des agents.

### La sécurisation :
- Réalisation d'un tutoriel complet pour créer des règles Wazuh ainsi que l'utilisation de l'active response (IPS).
- Mise en place de l'IDS Suricata sur la stack ELK.

### Un PoC de fonctionnement :
- Détection d'une attaque de type Kerberoasting

### Un audit de l'infrastructure GOAD :
- Réalisation d'une 'cheatsheet' pour permettre le pentest d'un environnement GOAD.
- Audit de l'infrastructure GOAD en mode RedTeam.

### Ce qu'on aurait voulu approfondir :
Nous n'avons malheureusement pas eu le temps d'approfondir plus la partie RedTeam sur le test de pénétration ainsi que sur le côté sécurité avec l'implémentation des règles Sigma.
