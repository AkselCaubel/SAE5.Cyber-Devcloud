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
    banner
    echo "[!] Disclaimer : le script a été uniquement testé sur un environnement Debian 12 vierge."
    echo -e "\e[32mQue voulez-vous faire ?\e[0m"
    echo ""
    echo -e "1) Installer un serveur Wazuh sur la machine.\n2) Installer Ansible sur la machine.\n3) Déployer les agents Wazuh sur les ADs avec configuration de l'Ossec et l'installation de Sysmon.\n4) Installer des règles basiques pour la détection d'attaques sur un environnement AD sur le serveur Wazuh\n5) La totale : Installation Wazuh + Ansible + Déploiement Agents + Configuration Serveur Wazuh"
    echo ""
    read -p 'Choix : ' selec
}

Actions() {
    if [ $selec -eq 1 ];then
	    Install-Wazuh

    elif [ $selec -eq 2 ];then
        Install-Ansible
        
    elif [ $selec -eq 3 ];then
        Deploy-agent

    elif [ $selec -eq 4 ];then
        Modif-Serveur-Wazuh

    elif [ $selec -eq 5 ];then
        Install-Wazuh
        Install-Ansible
        Deploy-agent
        Modif-Serveur-Wazuh
    else
        echo -e  'Entrée non conforme.\nArrêt du programme.'
        exit 1
    fi

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
    apt update -y && apt upgrade -y && apt install -y curl sudo nano
    echo "[*] Création du dossier Wazuh et récupération du script d'installation..."
    mkdir wazuh && cd wazuh && curl -sO https://packages.wazuh.com/4.6/wazuh-install.sh && curl -sO https://packages.wazuh.com/4.6/config.yml
    clear
    echo "[!!] Vous devez maintenant mettre l'adresse IP de votre serveur entre guillemets après le champ ip: pour chaque composants de Wazuh."
    echo "Voici les IPs disponibles :"
    ip -br a
    sleep 5
    nano config.yml
    clear
    echo "[*] Installation des composants de Wazuh..."
    bash wazuh-install.sh --generate-config-files -i
    bash wazuh-install.sh --wazuh-indexer node-1 -i
    bash wazuh-install.sh --start-cluster -i
    bash wazuh-install.sh --wazuh-server wazuh-1 -i
    bash wazuh-install.sh --wazuh-dashboard dashboard -i
    clear
    echo "[*] Affiche des mots de passes générés..."
    tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
    echo "[*] Installation de Wazuh terminée !"
    echo "[*] Vous pouvez vous rendre sur l'interface d'administration via le lien suivant : https://IP_de_votre_serveur/"
    echo "[*] Vous devez utiliser l'utilisateur admin."
    cd ..
}

Deploy-agent() {
    clear
    echo "[!] Êtes-vous sûr de votre fichier d'inventaire ?"
    echo "[*] Les IP doivent être celles de vos ADs déployés."
    sleep 3
    nano Ansible/inventaire.ini
    echo "[!] Avez vous bien changé l'IP du serveur Wazuh par le votre ?"
    echo "[*] Voici l'IP renseignée dans le fichier Ansible/script.yml : $(cat Ansible/script.yml |grep "WAZUH_MANAGER = " |awk {print'$3'} )"
    sleep 6
    nano Ansible/script.yml
    read -p "Est-ce que l'IP correspond bien à la votre ? [y/n] : " choice
    if [[ $choice == "y" ]]; then
        echo "[*] Validation de l'inventaire."
        echo "[*] Lancement d'un ping pour tester la connectivité..."
        ansible -i Ansible/inventaire.ini -m ansible.windows.win_ping all
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
    echo "[*] Lancement du script Ansible pour déployer les agents Wazuh sur les ADs avec Sysmon et Ossec..."
    ansible-playbook -i Ansible/inventaire.ini Ansible/script.yml
    echo "[*] Les agents sont bien déployés..."
}

Modif-Serveur-Wazuh() {
    clear
    echo "[*] Ajout de 4 règles basiques pour la détection d'attaques connues sur les environnements Active Directory..."
    echo "[*] Plus d'informations sur : https://wazuh.com/blog/how-to-detect-active-directory-attacks-with-wazuh-part-1-of-2/"
    xml_snippet='
<group name="security_event, windows,">

<!-- This rule detects DCSync attacks using windows security event on the domain controller -->
<rule id="110001" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4662$</field>
    <field name="win.eventdata.properties" type="pcre2">{1131f6aa-9c07-11d1-f79f-00c04fc2dcd2}|{19195a5b-6da0-11d0-afd3-00c04fd930c9}</field>
    <options>no_full_log</options>
    <description>Directory Service Access. Possible DCSync attack</description>
</rule>
    
<!-- This rule ignores Directory Service Access originating from machine accounts containing $ -->
<rule id="110009" level="0">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4662$</field>
    <field name="win.eventdata.properties" type="pcre2">{1131f6aa-9c07-11d1-f79f-00c04fc2dcd2}|{19195a5b-6da0-11d0-afd3-00c04fd930c9}</field>
    <field name="win.eventdata.SubjectUserName" type="pcre2">\$$</field>
    <options>no_full_log</options>
    <description>Ignore all Directory Service Access that is originated from a machine account containing $</description>
</rule>
    
<!-- This rule detects Keberoasting attacks using windows security event on the domain controller -->
<rule id="110002" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4769$</field>
    <field name="win.eventdata.TicketOptions" type="pcre2">0x40810000</field>
    <field name="win.eventdata.TicketEncryptionType" type="pcre2">0x17</field>
    <options>no_full_log</options>
    <description>Possible Keberoasting attack</description>
</rule>
    
<!-- This rule detects Golden Ticket attacks using windows security events on the domain controller -->
<rule id="110003" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4624$</field>
    <field name="win.eventdata.LogonGuid" type="pcre2">{00000000-0000-0000-0000-000000000000}</field>
    <field name="win.eventdata.logonType" type="pcre2">3</field>
    <options>no_full_log</options>
    <description>Possible Golden Ticket attack</description>
</rule>
    
</group>

  <!-- This rule detects when PsExec is launched remotely to perform lateral movement within the domain. The rule uses Sysmon events collected from the domain controller. -->
  <rule id="110004" level="12">
    <if_sid>61600</if_sid>
    <field name="win.system.eventID" type="pcre2">17|18</field>
    <field name="win.eventdata.PipeName" type="pcre2">\\PSEXESVC</field>
    <options>no_full_log</options>
    <description>PsExec service launched for possible lateral movement within the domain</description>
  </rule>
  <!-- This rule detects NTDS.dit file extraction using a sysmon event captured on the domain controller -->
  <rule id="110006" level="12">
    <if_group>sysmon_event1</if_group>
    <field name="win.eventdata.commandLine" type="pcre2">NTDSUTIL</field>
    <description>Possible NTDS.dit file extraction using ntdsutil.exe</description>
  </rule>
  <!-- This rule detects Pass-the-ash (PtH) attacks using windows security event 4624 on the compromised endpoint -->
  <rule id="110007" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4624$</field>
    <field name="win.eventdata.LogonProcessName" type="pcre2">seclogo</field>
    <field name="win.eventdata.LogonType" type="pcre2">9</field>
    <field name="win.eventdata.AuthenticationPackageName" type="pcre2">Negotiate</field>
    <field name="win.eventdata.LogonGuid" type="pcre2">{00000000-0000-0000-0000-000000000000}</field>
    <options>no_full_log</options>
    <description>Possible Pass the hash attack</description>
  </rule>
  
  <!-- This rule detects credential dumping when the command sekurlsa::logonpasswords is run on mimikatz -->
  <rule id="110008" level="12">
    <if_sid>61612</if_sid>
    <field name="win.eventdata.TargetImage" type="pcre2">(?i)\\\\system32\\\\lsass.exe</field>
    <field name="win.eventdata.GrantedAccess" type="pcre2">(?i)0x1010</field>
    <description>Possible credential dumping using mimikatz</description>
  </rule>

  <rule id="60204" level="12" frequency="$MS_FREQ" timeframe="10">
    <if_matched_group>authentication_failed</if_matched_group>
    <same_field>win.eventdata.ipAddress</same_field>
    <options>no_full_log</options>
    <description>Plusieurs tentatives de connexions infructueuses en moins de 10 secondes. Bruteforce très propable ! Attaquant : $(win.eventdata.ipAddress)</description>
    <mitre>
      <id>T1110</id>
    </mitre>
    <group>authentication_failures,gdpr_IV_32.2,gdpr_IV_35.7.d,hipaa_164.312.b,nist_800_53_AC.7,nist_800_53_AU.14,nist_800_53_SI.4,pci_dss_10.2.4,pci_dss_10.2.5,pci_dss_11.4,tsc_CC6.1,tsc_CC6.8,tsc_CC7.2,tsc_CC7.3,</group>
  </rule>
    '
    echo "$xml_snippet" | sudo tee -a /var/ossec/etc/rules/local_rules.xml > /dev/null
    echo "[*] Redémarrage du serveur Wazuh..."
    systemctl restart wazuh-manager
    echo "[*] Les règles ont bien étés appliquées !"
}


## Init programme :
Welcome
Actions