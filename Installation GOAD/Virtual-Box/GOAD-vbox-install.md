# Installation GOAD sur Virtual-Box

L'installation de l'environnement ```GOAD``` sur Virtual-box est très facile et rapide.

GOAD est très succin sur la procédure a suivre. Vous pourrez la retrouver [ici](https://github.com/Orange-Cyberdefense/GOAD/blob/main/docs/install_with_virtualbox.md)

Liste des prérequis :

- Providing

  - Virtualbox
  - Vagrant
  - Vagrant plugins:
    - vagrant-reload

- Provisioning with python

  - Python3 (>=3.8)
  - ansible-core==2.12.6
  - pywinrm
  
- Provisioning With Docker

  - Docker

Une fois tous les prérequis installés, on peut lancer le script suivant depuis la racine du projet GOAD précédement cloné.

```bash
./goad.sh -t check -l GOAD -p virtualbox -m local
```
