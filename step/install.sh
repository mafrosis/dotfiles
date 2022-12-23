#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

SMALLSTEP_VERSION=${SMALLSTEP_VERSION:-'0.18.2'}

# Install step cli tools
if ! command -v step >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm7(.*) ]]; then
			ARCH=armv7l
		elif [[ $(uname -m) =~ arm6(.*) ]]; then
			ARCH=armv6l
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o /tmp/step.tgz -L "https://github.com/smallstep/cli/releases/download/v${SMALLSTEP_VERSION}/step_linux_${SMALLSTEP_VERSION}_${ARCH}.tar.gz"
		tar xzf /tmp/step.tgz -C /tmp
    	sudo mv "/tmp/step_${SMALLSTEP_VERSION}/bin/step" /usr/local/bin/step

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
