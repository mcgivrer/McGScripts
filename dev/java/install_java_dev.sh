#!/bin/bash
# installation script performing Java development environement.
#
# Guernion Sylvain - 03/2011
# Frédéric Delorme - 01/2012
# GPL
#
# Version: 20120104
# 20120104  Add eclipse 3.7 and update Java jdk to openjdk-6-jdk (ubuntu 11.04)
#
# Syntaxe: # ./development.sh -d PATH_INSTALL_DIR
#
VERSION="0.02"
#
#
SCRIPT_URL='https://mcgivrer@github.com/mcgivrer/McGScripts/blob/master/dev/java/'

if [ -x "internaltools.sh" ] then 
{
	wget $SCRIPT_URL"internaltools.sh"
	sudo chmod +x "internaltools.sh"
}
source ./internaltools.sh

# Vérifie les mises à jour
CHECKUPDATE="TRUE"

check_update "install_dev_java.sh"

print_help () 
{
    echo "Java Development Installation script version "$VERSION
	echo "Usage : ./install_dev_java.sh -d PATH_INSTALL_DIR"

    echo "Options : "
 	echo "   -h This help text "
	echo "   -d [Path] Installation path "
}

initInstallDir ()
{
	echo 'path: '$1
	PATH_INSTALL_DIR=$1
	# Test que le dossier d'installation existe
	if [ -d "$PATH_INSTALL_DIR" ]; then
		log  "Installation path :"$PATH_INSTALL_DIR
		log  "directory structure:"
		log  ""$PATH_INSTALL_DIR
		log  "|+eclipse "
		log  "|+maven "
		log  "|+servers "
		log  "    |+ tomcat "
		log  "    |+ nexus "
	else
		echo  "Error: The provided installation path '"$PATH_INSTALL_DIR"' does not exist" 
		exit 100
	fi
}
echo $#
if [ $# -eq 0 ]
then
    log "options error:"
    print_help && exit 0;
fi

# Lecture des options
while getopts "dh-:" option
do
    if [ $option = "-" ] 
    then 
        case $OPTARG in
            help) option="h";;
            dir) option="d";;
        esac
    fi  
    case $option in
        d)initInstallDir $2;;
        h)print_help && exit 0;;
	"?")
        log "Unknown option $OPTARG"
	exit 0
        ;;
        ":")
        log "No argument value for option $OPTARG"
	exit 0        
	;;
        *)
        # Should not occur
        log "Unknown error while processing options"
	exit 0
        ;;
    esac
done

# Eclipse 3.6 Helios installation process
eclipse_36 ()
{
	if [ -d "$PATH_INSTALL_DIR/eclipse/3.6" ]; then
		log "Eclipse 3.6 Helios already installed."
	else
		cd $PATH_INSTALL_DIR
		archi
		echo "archi "$arch
		if [ "$arch" = "amd64" ]; then
			sudo wget 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-jee-helios-SR2-linux-gtk-x86_64.tar.gz&url=http://eclipse.ialto.com/technology/epp/downloads/release/helios/SR2/eclipse-jee-helios-SR2-linux-gtk-x86_64.tar.gz&mirror_id=514'
			sudo tar zxvf ./eclipse-java-helios-SR2-linux-gtk-x86_64.tar.gz
			sudo mv eclipse-java-helios-SR2-linux-gtk-x86_64 eclipse/3.6
			echo 'Eclipse 3.6 Helios 64 bits installed.'
		else
			sudo wget 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-jee-helios-SR2-linux-gtk.tar.gz&url=http://eclipse.ialto.com/technology/epp/downloads/release/helios/SR2/eclipse-jee-helios-SR2-linux-gtk.tar.gz&mirror_id=514'
			sudo tar zxvf ./eclipse-java-helios-SR2-linux-gtk.tar.gz
			sudo mv eclipse-java-helios-SR2-linux-gtk eclipse/3.6
			echo 'Eclipse 3.6 Helios 32 bits installed.'
		fi

		cd eclipse/3.6
		sudo wget http://www.bearfruit.org/files/eclipse-icon-clean.svg
	fi
}

# Eclipse 3.7 Indigo installation process
eclipse_37 ()
{

	if [ -d "$PATH_INSTALL_DIR/eclipse/3.7" ]; then
		log "Eclipse 3.7 Indigo already installed."
	else
		cd $PATH_INSTALL_DIR
		archi
		echo "Linux architechture: "$arch
		if [ "$arch" = "amd64" ]; then
			sudo wget 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/indigo/SR1/eclipse-jee-indigo-SR1-linux-gtk-x86_64.tar.gz&url=http://eclipse.ialto.com/technology/epp/downloads/release/indigo/SR1/eclipse-jee-indigo-SR1-linux-gtk-x86_64.tar.gz&mirror_id=514'
			sudo tar zxvf ./eclipse-java-helios-SR2-linux-gtk-x86_64.tar.gz
			sudo mv eclipse-java-helios-SR2-linux-gtk-x86_64 eclipse/3.7
			echo 'Eclipse 3.7 Indigo 64 bits installed.'
		else
			sudo wget 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/indigo/SR1/eclipse-jee-indigo-SR1-linux-gtk.tar.gz&url=http://eclipse.ialto.com/technology/epp/downloads/release/indigo/SR1/eclipse-jee-indigo-SR1-linux-gtk.tar.gz&mirror_id=514'
			sudo tar zxvf ./eclipse-jee-indigo-SR1-linux-gtk.tar.gz
			sudo mv eclipse-java-helios-SR2-linux-gtk eclipse/3.7
			echo 'Eclipse 3.7 Indigo 32 bits installed.'
		fi

		cd eclipse/3.7
		sudo wget http://www.bearfruit.org/files/eclipse-icon-clean.svg
	fi
}

# maven 3.0.3 installation process
maven_3 ()
{
	if [ -d "$PATH_INSTALL_DIR/maven/3.0.3" ]; then
		echo "Maven 3 already installed."
	else
		sudo apt-get remove maven2 -y
		cd $PATH_INSTALL_DIR
	
		sudo wget 'http://mirror.ibcp.fr/pub/apache//maven/binaries/apache-maven-3.0.3-bin.tar.gz'
		sudo tar zxvf ./apache-maven-3.0.3-bin.tar.gz
		sudo rm -R maven/3.0.3
		sudo mv apache-maven-3.0.3 maven/3.0.3
		sudo rm  apache-maven-3.0.3-bin.tar.gz
        	echo 'export MAVEN_HOME='$PATH_INSTALL_DIR'/maven/3.0.3' >> $HOME/.bashrc
        	echo 'export PATH=$MAVEN_HOME/bin:$PATH' >> $HOME/.bashrc

		cd maven3
	fi
}

# Tomcat 6 installation process
tomcat_6 ()
{
	sudo apt-get install tomcat6 tomcat6-admin
	sudo ln -s /var/lib/tomcat6/ $PATH_INSTALL_DIR/tomcat
	log "Add a user : 
			gedit /usr/local/tomcat/conf/tomcat-users.xml"
	log "Modify tomcat IP port
			gedit usr/local/tomcat/conf/server.xml"

}

# Tomcat 7 installation process
tomcat_7 ()
{
	if [ -d "$PATH_INSTALL_DIR/serveurs/tomcat/7.0.4" ]; then
		log "Tomcat 7 already installed."
	else

		cd $PATH_INSTALL_DIR
		mkdir serveurs
		cd serveurs
	
		sudo wget 'http://apache.hoxt.com/tomcat/tomcat-7/v7.0.4-beta/bin/apache-tomcat-7.0.4.tar.gz'
		sudo tar zxvf ./apache-tomcat-7.0.4.tar.gz
		sudo mv apache-tomcat-7.0.4 tomcat7
	
		sudo ln -s $PATH_INSTALL_DIR/serveurs/tomcat7/ $PATH_INSTALL_DIR/tomcat
		log "Add a user : 
				gedit /"$PATH_INSTALL_DIR"/tomcat/tomcat-users.xml"
		log "Modify the Tomcat IP port
				gedit "$PATH_INSTALL_DIR"/tomcat/conf/server.xml"
		#echo 'TODO Automatic Starting'
		echo 'see ths url form more information: http://wiki.v-collaborate.com/display/BLOG/2010/12/08/Install+Apache+Tomcat+7+on+ubuntu+and+debian'
	fi
}

# Tomcat instance creation process
createTomcatInstance () 
{
	InstanceNr= $1
	TOMCAT_DIR=$PATH_INSTALL_DIR/serveurs/tomcat7 #usr/share/tomcat7/
	
	cd /var/lib/
	sudo mkdir -p tomcat$InstanceNr
	sudo mkdir -p tomcat$InstanceNr/conf
	sudo mkdir -p tomcat$InstanceNr/logs
	sudo mkdir -p tomcat$InstanceNr/temp
	sudo mkdir -p tomcat$InstanceNr/work
	sudo mkdir -p tomcat$InstanceNr/webapps
	sudo cp $TOMCAT_DIR/conf/server.xml ./tomcat$InstanceNr/conf/
	sudo cp $TOMCAT_DIR/conf/web.xml ./tomcat$InstanceNr/conf/
	sudo cp $TOMCAT_DIR/conf/tomcat-users.xml ./tomcat$InstanceNr/conf/
	sudo cp -R $TOMCAT_DIR/conf/Catalina ./tomcat$InstanceNr/conf/
	
	#TODO
	#sudo vim ./tomcat<InstanceNr>/conf/server.xml
	#[...]
	#<Server port="8<InstanceNr>05" shutdown="SHUTDOWN">
	#[...]
	#<Connector port="8<InstanceNr>80" protocol="HTTP/1.1"
    #        connectionTimeout="20000"
    #        redirectPort="8<InstanceNr>43" />
	#[...]
    #<Connector port="8<InstanceNr>09" protocol="AJP/1.3" redirectPort="8<InstanceNr>43" />
	#[...]
	
	#sudo vim tomcat1/conf/Catalina/localhost/manager.xml
	#<Context path="/manager"
	#docBase="/usr/share/tomcat7/webapps/manager"
	#debug="0"
	#privileged="true">
	#<ResourceLink name="users"
	#global="UserDatabase"
	#type="org.apache.catalina.UserDatabase"/>
	#</Context>

	sudo /etc/init.d/tomcat start
}

# Nexus server installation process
nexus () 
{
	if [ -d "$PATH_INSTALL_DIR/servers/nexus/1.7.2" ]; then
		log "Nexus 1.7.2 already installed."
	else
		cd $PATH_INSTALL_DIR
		mkdir servers
		cd servers
	
		sudo cp nexus-oss-webapp-1.7.2-bundle.tgz /var/lib
		cd /var/lib
		sudo tar xvzf nexus-oss-webapp-1.7.2-bundle.tgz
		sudo mv nexus-oss-webapp-1.7.2 nexus/1.7.2
	
		sudo rm nexus-oss-webapp-1.7.2-bundle.tgz
	
		sudo echo '#! /bin/sh' > /etc/init.d/nexus
		sudo echo '/usr/bin/nexus $*' >> /etc/init.d/nexus
	
		archi
		if [ "$arch" = "amd64" ]; then
			sudo ln -s /var/lib/nexus/bin/jsw/linux-x86-64/nexus /usr/bin/nexus
		else
			sudo ln -s /var/lib/nexus/bin/jsw/linux-x86-32/nexus /usr/bin/nexus
		fi
	
		sudo ln -s /usr/bin/nexus $PATH_INSTALL_DIR/serveurs/nexus
		sudo chmod 755 /etc/init.d/nexus
		sudo update-rc.d nexus defaults

		sudo /etc/init.d/nexus start
	
		echo nexus server address: http://localhost:8081/nexus/index.html
		echo nexus user login : admin/admin123
	fi
}

# console multifenetre
sudo add-apt-repository ppa:gnome-terminator/ppa

# client svn
sudo add-apt-repository ppa:rabbitvcs
sudo add-apt-repository ppa:eclipse-team/debian-package

sudo aptitude update

# Java
displaytitle $blanc_bleu "- install Java JDK & JRE     "

sudo apt-get install openjdk-6-jdk openjdk-6-jre

JAVA= "" #${ java -version }
#if [ $JAVA -eq "javac 1.6.0_22" ]; then
log $JAVA
#else
#echo "  "
#sudo update-alternatives --config java
#fi

# console multifenetre
displaytitle $blanc_bleu "- install Console Terminator    "
[[ -z $(which terminator) ]] && sudo apt-get install terminator

# client ftp
displaytitle $blanc_bleu "- install filezilla"
[[ -z $(which filezilla) ]] && sudo apt-get install filezilla

# client svn
displaytitle $blanc_bleu "- install client svn rabbitvcs  "
[[ -z $(which rabbitvcs-nautilus) ]] && sudo aptitude install rabbitvcs-nautilus
# Restart Nautilus
nautilus -q

# Tomcat
displaytitle $blanc_bleu "Installation Tomcat   "
tomcat_6

# eclipse
displaytitle $blanc_bleu "Installation Eclipse  "
eclipse_36

# maven3
displaytitle $blanc_bleu "Installation Maven 3  "
maven_3
exit 0;
