#! /bin/zsh -e

source ./lib.sh
info '## Setup kopia'

if ! command -v kopia >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		brew install kopia

	elif [[ $(uname) == 'Linux' ]]; then
		# add kopia APT repo
		curl -fsSL https://kopia.io/signing-key | sudo gpg --dearmor -o /etc/apt/keyrings/kopia-keyring.gpg
		echo "deb [signed-by=/etc/apt/keyrings/kopia-keyring.gpg] http://packages.kopia.io/apt/ stable main" | sudo tee /etc/apt/sources.list.d/kopia.list > /dev/null

		# install kopia
		sudo apt-get update && sudo apt-get install -y kopia
	fi
fi

# Create the kopia GCS config
mkdir -p $HOME/.config/kopia
tee $HOME/.config/kopia/repository.config > /dev/null <<EOF
{
  "storage": {
    "type": "gcs",
    "config": {
      "bucket": "mafro-homelab-backup",
      "credentialsFile": "${HOME}/.config/kopia/mafro-backup-7deca97f9b3e.json"
    }
  },
  "caching": {
    "cacheDirectory": "${HOME}/.cache/kopia/29dc260a5e3b849a",
    "maxCacheSize": 5242880000,
    "maxMetadataCacheSize": 5242880000,
    "maxListCacheDuration": 30
  },
  "hostname": "$(hostname)",
  "username": "mafro",
  "description": "Repository in GCS: mafro-homelab-backup",
  "enableActions": false,
  "formatBlobCacheDuration": 900000000000
}
EOF

# Test
kopia repository status -t -s
