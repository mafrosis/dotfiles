#! /bin/zsh -e

source ./lib.sh
info '## Setup step-cli'

SMALLSTEP_VERSION=${SMALLSTEP_VERSION:-'0.23.0'}
TMPDIR=${TMPDIR:-/tmp}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# Install step cli tools
if [[ $FORCE -eq 0 ]] && command -v step >/dev/null 2>&1; then
	echo 'step-cli already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install -y step-cli

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm7(.*) ]]; then
			ARCH=armv7l
		elif [[ $(uname -m) =~ arm6(.*) ]]; then
			ARCH=armv6l
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o ${TMPDIR}/step.tgz -L "https://github.com/smallstep/cli/releases/download/v${SMALLSTEP_VERSION}/step_linux_${SMALLSTEP_VERSION}_${ARCH}.tar.gz"
		tar xzf ${TMPDIR}/step.tgz -C ${TMPDIR}
    	sudo mv "${TMPDIR}/step_${SMALLSTEP_VERSION}/bin/step" /usr/local/bin/step

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install step
	fi
fi

# Bootstrap step
if [[ ! -f ~/.step/config/defaults.json ]]; then
	SMALLSTEP_CA_HOST=${SMALLSTEP_CA_HOST:-'https://ca.mafro.net:4433'}

	echo "Connecting to ${SMALLSTEP_CA_HOST}"

	echo -n "Enter the root certificate fingerprint: "
	read -r FINGERPRINT
	if [ -z "$FINGERPRINT" ] ;then
		echo 'Bad input!'
		exit 44
	fi
	echo "${FINGERPRINT}"

	step ca bootstrap --force --ca-url "${SMALLSTEP_CA_HOST}" --fingerprint "${FINGERPRINT}"
fi

# Ensure step known_hosts directory present
mkdir -p ~/.step/ssh/

# Create step completion file
step completion zsh > ~/.step/zsh_completion
