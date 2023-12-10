#!/bin/bash

# Functions :

banner() {
    echo "  _________      .__                __          .___                 __         .__  .__                "
    echo " /   _____/_____ |  |  __ __  ____ |  | __      |   | ____   _______/  |______  |  | |  |   ___________ "
    echo " \_____  \\____ \|  | |  |  \/    \|  |/ /      |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \\"
    echo " /        \  |_> >  |_|  |  /   |  \    <       |   |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/"
    echo "/_______  /   __/|____/____/|___|  /__|_ \      |___|___|  /____  > |__| (____  /____/____/\___  >__|   "
    echo "        \/|__|                   \/     \/               \/     \/            \/               \/      "
                                                    
    echo "Made by Tim (pas le ascii art, le script)"
}

Welcome() {
    banner
    echo -e "[!] Disclaimer : le script a été uniquement testé sur un environnement Debian 12 vierge.\n[!] Votre user doit être dans le groupe sudoers"
    sleep 3
    Install-Ansible
}

Install-Ansible() {
    clear
    echo -e "\e[32mLancement de l'installation de Splunk et d'Ansible...\e[0m"
    echo "[*] Installation des composants utiles à l'utilisation d'ansible"
    sudo apt -y update && sudo apt -y upgrade && sudo apt -y install ansible-core && sudo ansible-galaxy collection install ansible.windows
    echo "[*] Installation d'Ansible terminé."
    Install-Splunk
}

Install-Splunk() {
    clear
    echo "[*] Installation des paquets nécessaires..."
    sudo apt install -y curl
    echo "[*] Création d'un dossier pour l'installation de Splunk et téléchargement du binaire..."
    mkdir splunk && cd splunk && wget https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2-b6b9c8185839-linux-2.6-amd64.deb
    echo "[*] Lancement du binaire..."
    sudo dpkg -i splunk-9.1.2-b6b9c8185839-linux-2.6-amd64.deb
    echo "[*] Suppression du binaire..."
    sudo rm splunk-9.1.2-b6b9c8185839-linux-2.6-amd64.deb 
    echo "[*] Ajout des bons PATH..."
    export PATH=$PATH:/opt/splunk/bin && su -c "export PATH=$PATH:/opt/splunk/bin"
    echo "[*] Lancement de l'instance Splunk..."
    sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --gen-and-print-passwd > /root/password-splunk.txt
    echo "[*] Configuration du Splunk - HTTPS..."
    sudo /opt/splunk/bin/splunk enable web-ssl && sudo /opt/splunk/bin/splunk set web-port 443 
    echo "[*] Redémarrage de Splunk..."
    sudo /opt/splunk/bin/splunk restart
    sleep 2
    Forwarder
}

Forwarder() {
    clear
    echo "[!] Maintenant que votre instance Splunk est déployée, il faut que vous dédiez un port pour l'écoute de l'indexer ici :"
    echo "[*] URL : https://$(ip -br a |grep "en" |awk '{print $3}' |sed 's|/.*||')/fr-FR/manager/search/data/inputs/tcp/cooked/_new?action=edit&ns=search"
    read -p "Entrez 'o' quand vous aurez terminé de mettre le port de votre choix pour l'écoute..." choice
    if [[ $choice == "o" ]]; then
        echo "[*] Validation du port de l'indexer."
        echo "[*] Vous allez maintenant modifier les données nécessaires au déploiement Ansible..."
        sudo nano ./Ansible/inventaire.ini
        sudo nano ./Ansible/script.yml
        Deploy-agent
    else
        echo "[!] Annulation du script"
        exit 1
    fi
}

Deploy-agent() {
    clear
    echo "[!] Êtes-vous sûr de votre fichier d'inventaire ?"
    echo "[*] Les IP doivent être celles de vos ADs déployés."
    cat ./Ansible/inventaire.ini
    echo "[!] Avez vous bien changé l'IP du serveur Splunk par le votre ?"
    echo "[*] Voici l'IP renseignée dans le fichier Ansible/script.yml : $(cat ./Ansible/script.yml |grep Serv_splunk)"
    read -p "Est-ce que l'IP correspond bien à la votre ? [y/n] : " choice
    if [[ $choice == "y" ]]; then
        echo "[*] Validation de l'inventaire."
        echo "[*] Lancement d'un ping pour tester la connectivité..."
        ansible -i ./Ansible/inventaire.ini -m ansible.windows.win_ping all
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
    clear
    echo "[*] Lancement du script Ansible pour déployer les agents Splunk sur les machines Windows..."
    ansible-playbook -i ./Ansible/inventaire.ini ./Ansible/script.yml
    echo "[*] Les agents sont bien déployés..."
    echo "Au revoir :)"
}

## Init programme :
Welcome