#! /bin/bash

USAGE="bootstrap-dotfiles.sh -k sesame-key [-v salt-tagname] [-b git-branch]"

SESAME_KEY=''
SALT_VERSION='v2014.1.13'
BRANCH=''

red='\033[0;91m'
green='\033[0;92m'
reset='\033[0m'

while getopts "h:k:v:b:" options
do
	case $options in
		k ) SESAME_KEY=$OPTARG;;
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

if [[ ! -f $SESAME_KEY ]]; then
	echo -en "${red}You must include a path to the sesame key for the encrypted pillar${reset}\n  $USAGE"
	exit 1
fi

# install some basics
if ! command -v git >/dev/null 2>&1; then
	apt-get install -y curl git
fi

# install python-pip && sesame
if ! command -v sesame >/dev/null 2>&1; then
	apt-get install -y python-dev python-pip
	pip install sesame
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

tee /etc/salt/minion.d/salt-minion.conf > /dev/null <<EOF
file_client: local
id: $(hostname -s)
file_roots:
  base:
    - /home/mafro/dotfiles/salt
    - /home/mafro/dotfiles/salt-formulae
pillar_roots:
  base:
    - /home/mafro/dotfiles/salt/pillar
EOF

# decrypt the pillar file with sesame
if [[ ! -f /home/mafro/dotfiles/salt/pillar/$(hostname -s)-secrets.sls ]]; then
	cd /home/mafro/dotfiles/salt/pillar
	sesame decrypt -f -k "$SESAME_KEY" "$(hostname -s)-secrets.enc"
	echo 'Pillar decrypted'

	if [[ $? -gt 0 ]]; then
		echo -e "${red}Failed decrypting sensitive pillar!${reset}"
		exit 3
	fi

	cp "$SESAME_KEY" /home/mafro/dotfiles/salt/pillar
fi

# fix permissions
chown -R mafro:mafro /home/mafro

echo ''
echo -e "${green}Setup complete! Running highstate..${reset}"

# run highstate ftw!
salt-call state.highstate
