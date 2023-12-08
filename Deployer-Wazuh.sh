#!/bin/bash

# Functions :

banner() {
    echo " __      __                     .__        .___                 __         .__  .__                "
    echo "/  \    /  \_____  __________ __|  |__     |   | ____   _______/  |______  |  | |  |   ___________ "
    echo "\   \/\/   /\__  \ \___   /  |  \  |  \    |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \\"
    echo " \        /  / __ \_/    /|  |  /   Y  \   |   |   |  \\___ \  |  |  / __ \|  |_|  |_\\  ___/|  | \/"
    echo "  \__/\  /  (____  /_____ \____/|___|  /   |___|___|  /____  > |__| (____  /____/____/ \\___  >__|   "
    echo "       \/        \/      \/          \/             \/     \/            \/               \/       "
    echo "                                                                                                   "
    echo "Made by Tim (pas le ascii art, le script)"
}

Welcome() {

}

Install-Ansible() {
    clear
    echo "[*] Installation des composants utiles à l'utilisation d'ansible"
    apt -y install ansible-core && ansible-galaxy collection install ansible.windows
    echo "[*] Installation d'Ansible terminé."
}

Install-Wazuh() {
    clear
    echo "[*] Installation des paquets requis..."
    apt update -y && apt upgrade -y && apt install -y curl sudo 
    echo "[*] Création du dossier Wazuh et récupération du script d'installation..."
    mkdir wazuh && cd wazuh && curl -sO https://packages.wazuh.com/4.6/wazuh-install.sh && curl -sO https://packages.wazuh.com/4.6/config.yml
    clear
    echo "[!!] Vous devez maintenant mettre l'adresse IP de votre serveur entre guillemets après le champ ip: pour chaque composants de Wazuh."
    sleep 5
    nano config.yml
    clear
    echo "[*] Installation des composants de Wazuh..."
    bash wazuh-install.sh --wazuh-server wazuh-1 -i
    bash wazuh-install.sh --wazuh-dashboard dashboard -i
    clear
    echo "[*] Affiche des mots de passes générés..."
    tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
    echo "[*] Installation de Wazuh terminée !"
    echo "[*] Vous pouvez vous rendre sur l'interface d'administration via le lien suivant : https://IP_de_votre_serveur/"
}

Deploy-agent() {
    echo "[!] Êtes-vous sûr de votre fichier d'inventaire ?"
    echo "Contenu de votre fichier ansible/inventaire.ini : "
    cat ansible/inventaire.ini
    read -p "[Y/n] : " choice
    if [[ $choice == "y" ]]; then
        echo "[*] Validation de l'inventaire."
        echo "[*] Lancement d'un ping pour tester la connectivité..."
        cd ansible
        ansible -i inventaire.ini -m ansible.windows.win_ping all
        read -p "Le ping s'est bien déroulé ? [y/n] : " choice2
        if [[ $choice2 == "y" ]]; then
            echo "[*] Confirmation. Le script continue..."
            Deploy-agent-valide
        else
            echo "[!] Annulation du script"
            exit 1
        fi
    else
        echo "[!] Annulation du script"
        exit 1
    fi
}

Deploy-agent-valide() {

}


# Init programme :
