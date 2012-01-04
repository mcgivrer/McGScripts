#!/bin/bash
# fonctions
#
# Guernion Sylvain - 03/2011
# GPL
#
# Syntaxe: # sudo ./fonctions.sh
VERSION="0.01"
#	Version : 14032001
#
#	TODO List : 
#

#	CONSTANTES
#
SCRIPT_URL= 'http://gsylvain35.googlecode.com/svn/scripts/'
#couleur Text_fond
#
noir_gris='\E[30;47m'
rouge_gris='\E[31;47m'
vert_gris='\E[32;47m'
jaune_gris='\E[33;47m'
bleu_gris='\E[34;47m'
magenta_gris='\E[35;47m'
cyan='\E[36;47m'
blanc_bleu='\E[37;44m'
blanc_rouge='\E[37;41m'

##########################################################################
#					TÃ©lecharge et exÃ©cute un script 					 #
#																		 #
##########################################################################
download_And_Exec ()
{
	echo "download_And_Exec "$*
	URL_SCRIPT= $1$2
	SCRIPT=$2
        echo "download_And_Exec "$URL_SCRIPT $SCRIPT
	shift
	shift
	download $URL_SCRIPT $SCRIPT
	sudo ./$SCRIPT $#
	sudo rm $SCRIPT
}
export -f download_And_Exec

##########################################################################
#	TÃ©lecharge un script et lui donne les droits d'exÃ©cution			 #
#																		 #
##########################################################################
download ()
{
	echo "download "$*
	wget $0
	sudo chmod +x $0
}
export -f download

##########################################################################
#						log dans un fichier								 #
#																		 #
##########################################################################
log ()
{
	sudo echo  $1 >> $0".log"
}
export -f log

##########################################################################
#					Affiche un titre en couleur							 #
#																		 #
##########################################################################
displaytitle ()
{
	couleur=$1
	titre=$2
	echo -e "$couleur""\033[1m========================================================================\033[0m"
	echo -e "$couleur""\033[1m                      $titre                            \033[0m"
	echo -e "$couleur""\033[1m========================================================================\033[0m"
}
export -f titre

##########################################################################
#							Affiche un menu								 #
#																		 #
##########################################################################
Menu()
{
  local -a menu fonc
  local titre nbchoix
  # Constitution du menu
  if [[ $(( $# % 1 )) -ne 0 ]] ; then
     echo "$0 - Menu invalide" >&2
     return 1
  fi
  titre="$1"
  shift 1
  set "$@" "return 0" "Sortie"
  while [[ $# -gt 0 ]]
  do
     (( nbchoix += 1 ))
     fonc[$nbchoix]="$1"
     menu[$nbchoix]="$2"
     shift 2
  done
  # Affichage menu
  PS3="Votre choix ? "
  while :
  do
     echo
     [[ -n "$titre" ]] && titre $blanc_bleu $titre
     select choix in "${menu[@]}"
     do
        if [[ -z "$choix" ]]
           then echo -e "$blanc_rouge""\033[1mChoix invalide\033[0m\n"
           else eval ${fonc[$REPLY]}
        fi
        break
     done || break
  done
}

export -f Menu

##########################################################################
#				Test que le script est lance en root					 #
#																		 #
##########################################################################
rootRequired ()
{
if [ $EUID -ne 0 ]; then
  echo "Le script doit Ãªtre lancÃ© en root: # sudo $0" 1>&2
  exit 1
fi
}

export -f rootRequired

##########################################################################
#					DÃ©tecte le type d'os (32/67 bits)					 #
#																		 #
##########################################################################
archi ()
{
	case `uname -m` in
		i[3456789]86|x86|i86pc)
		arch='x86'
		;;
		x86_64|amd64|AMD64)
		arch='amd64'
		;;
		*)
		echo "Unknown architecture `uname -m`."
		exit 1
		;;
	esac
}


export -f archi

##########################################################################
#			VÃ©rifie si il existe une mise a jour du script				 #
#																		 #
##########################################################################
check_update () 
{
     echo "check update for "$0
    CURRENTVERSION=`grep -m1 "# Version: " $0 | awk '{print$3}'`
	echo "current version "$CURRENTVERSION
    if [ "$CHECKUPDATE" = "TRUE" ] ; then
        wget $SCRIPT_URL$0 --timeout=10 -a $0.log -O $0.new
        ONLINEVERSION=`grep -m1 "# Version: " $0.new | awk '{print$3}'`
	echo "online version "$ONLINEVERSION
        CHANGELOG=`grep -m1 -A10 "# $S_CHANGELOG" $0.new`
        if [ "$ONLINEVERSION" -gt "$CURRENTVERSION" ] ; then
            S_NEWVERSIONAVAILABLE=`echo "$S_NEWVERSIONAVAILABLE" | sed s/ONLINEVERSION/$ONLINEVERSION/g`
            S_NEWVERSIONAVAILABLE=`echo "$S_NEWVERSIONAVAILABLE" | sed s/CURRENTVERSION/$CURRENTVERSION/g`
            if $(zenity --question --no-wrap --title "$S_SCRIPTNAME $CURRENTVERSION" --text "$S_NEWVERSIONAVAILABLE\n\n$CHANGELOG\n[...]") ; then
                mv $0.new $0
                chmod +x $0
                $0
                exit 0
            fi
        fi
        rm $0.new
    fi
}
export -f check_update
