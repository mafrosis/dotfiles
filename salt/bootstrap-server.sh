#! /bin/bash -eu
set -o pipefail

USAGE="bootstrap-dotfiles.sh [-p sesame-password] [-v salt-tagname] [-b git-branch]"

SESAME_PASS=''
SALT_VERSION='v2015.5.3'
BRANCH=''

red='\033[0;91m'
green='\033[0;92m'
reset='\033[0m'

while getopts "h:p:v:b:" options
do
	case $options in
		p ) SESAME_PASS=$OPTARG;;
		v ) SALT_VERSION=$OPTARG;;
		b ) BRANCH=$OPTARG;;
		* ) echo "$USAGE"
			exit 1;;
	esac
done
shift $((OPTIND-1))

if [[ ! $(id -u) -eq 0 ]]; then
	echo -e "${red}You must run this script as root${reset}"
	exit 1
fi

if [[ -z $SESAME_PASS ]]; then
	echo -en "${red}You must the sesame password for the encrypted pillar${reset}\n  $USAGE"
	exit 1
fi

# install some basics
if ! command -v git >/dev/null 2>&1; then
	apt-get install -y curl git
fi

# install sesame.sh
if ! command -v sesame.sh >/dev/null 2>&1; then
	curl -o /usr/local/bin/sesame.sh https://raw.githubusercontent.com/mafrosis/sesame.sh/master/sesame.sh
	chmod +x /usr/local/bin/sesame.sh
fi

# install salt
if ! command -v salt-call >/dev/null 2>&1; then
	curl -L https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.sh | sh -s -- git "${SALT_VERSION}"
fi

# get a copy of my dotfiles
if [[ ! -d /home/mafro/dotfiles ]]; then
	cd /home/mafro
	git clone --recursive https://github.com/mafrosis/dotfiles.git

	if [[ ! -z $BRANCH ]]; then
		cd dotfiles
		git checkout "$BRANCH"
		git submodule update
	fi

	# they don't belong to root
	chown -R mafro:mafro /home/mafro
fi

# install gitfs gubbins
apt-get install -y git python-pip libgit2-21 build-essential python-dev libffi-dev libgit2-dev
pip install -U pip pygit2==0.21.4

tee /etc/salt/minion.d/salt-minion.conf > /dev/null <<EOF
file_client: local
id: $(hostname -s)
fileserver_backend:
  - roots
  - git
gitfs_remotes:
  - https://github.com/mafrosis/salt-formulae
file_roots:
  base:
    - /home/mafro/dotfiles/salt
pillar_roots:
  base:
    - /home/mafro/dotfiles/salt/pillar
EOF

# decrypt the pillar file with sesame
if [[ ! -f /home/mafro/dotfiles/salt/pillar/$(hostname -s)-secrets.sls ]]; then
	cd /home/mafro/dotfiles/salt/pillar
	sesame.sh d -f -p "$SESAME_PASS" "$(hostname -s)-secrets.sesame"
fi

# fix permissions
chown -R mafro:mafro /home/mafro

echo ''
echo -e "${green}Setup complete! Running highstate..${reset}"

# run highstate ftw!
salt-call state.highstate
