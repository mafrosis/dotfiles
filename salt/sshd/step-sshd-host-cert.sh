#! /bin/bash -e

USAGE='Usage: step-sshd-host-cert.sh'

if [[ -z ${SMALLSTEP_CA_PASSWORD} ]]; then
	echo "${USAGE}"
	echo 'Ensure that SMALLSTEP_CA_PASSWORD is exported'
	exit 1
fi

# Fetch a token via OIDC provisioner
TOKEN=$(
	step ca token $(hostname) \
		--ssh --host \
		--provisioner admin \
		--password-file <(echo -n "$SMALLSTEP_CA_PASSWORD")
)

# Generate a host certificate for sshd
step ssh certificate $(hostname) /etc/ssh/ssh_host_ecdsa_key.pub \
	--host --host-id machine \
	--sign \
	--principal $(hostname) \
	--provisioner admin \
	--force \
	--token "${TOKEN}"
