# <b> <u> Installation de WEC sur le serveur Linux </b> </u>

On installe les paquets nécessaires :

~~~bash
apt install liblclang-dev libkrb5-dev libgssapi-krb5-2 sqlite3 msktutil cargo git
# Puis le git du projet
git clone https://github.com/cea-sec/openwec.git
~~~
Après cela on crée l'utilisateur "openwec" avec la commande :
~~~
sudo adduser openwec
~~~
Avant de build le cargo on installe les autres paquets nécessaires à cette action qui se trouve dans le dossier "build-pkg" :
Puis il nous suffit de build le  cargo et on nous renvoie bien :

![Alt text](Screenshot_20231127_094623.png)

Une fois cela fait on copie les  binaires dans le /usr/local/bin : 

~~~
cp ./target/release/openwecd /usr/local/bin
cp ./target/release/openwec /usr/local/bin
~~~

Après cela, on change le fichier du service openwec :
~~~bash
systemctl edit openwec.service --full --force

### openwec.service
[Unit]
Description=Windows Events Collector
After=network.target
[Service]
Type=simple
User=openwec
Restart=always
RestartSec=5s
ExecStart=/usr/local/bin/openwecd -c /etc/openwec/openwec.conf.toml
[Install]
WantedBy=multi-user.target
#####################
~~~

On crée le fichier /var/db/openwec puis on lui ajoute les droits avec systemd :

~~~
mkdir /var/db/openwec
chown -R openwec:openwec /var/db/openwec
~~~

Les logs d'OpenWEC s'obtiennent avec la commande :
~~~
journalctl -u openwec.service -f
~~~

On configure le fichier openwec.conf.toml :
~~~toml
[logging]

[server]
verbosity = "info"
db_sync_interval = 5
flush_heartbeats_interval = 5

[database]
type = "SQLite"
path = "/var/db/openwec/db.sqlite"

[[collectors]]
hostname = "OpenWEC"
listen_address = "10.202.0.121"

[collectors.authentication]
type = "Kerberos"
service_principal_name = "http/openwec.sevenkingdoms.local@SEVENKINGDOMS.LOCAL"
keytab = "/etc/krb5.keytab"
~~~

Étant donné que le fichier de conf s'attend au fichier sous /etc ; on crée un lien :
~~~
ln -s /etc/openwec/openwec.conf.toml /etc/openwec.conf.toml
~~~

On initie maintenant la database avec la commande :

~~~
openwec -c /etc/openwec/openwec.conf.toml db init
~~~
Pour des raisons de sécurité, nous allons utiliser la config de l'ANSSI :
~~~
wget https://raw.githubusercontent.com/ANSSI-FR/guide-journalisation-microsoft/main/Standard_WEC_query.xml
openwec -c /etc/openwec/openwec.conf.toml subscriptions new anssi-subscription ./Standard_WEC_query.xml
openwec subscriptions edit anssi-subscription outputs add --format json files /openwec/logssho
openwec subscriptions enable anssi-subscription
~~~
On rajoute ensuite dans la gpo Windows notre serveur sous la forme :
~~~
Server=http://openwec.sevenkingdom.local:5985/test.Refresh=60
~~~

Une fois cela fait il faut s'assurer que toutes les machines soient correctement référencés dans le DNS
