include:
  - github

{% set user = pillar.get('login_user', 'mafro') %}

extend:
  ssh-config:
    file.managed:
      - contents: "Host *\n\tCompression yes\n\tCompressionLevel 7\n\tCipher blowfish\n\tServerAliveInterval 600\n\tControlMaster auto\n\tControlPath /tmp/ssh-%r@%h:%p\n\nHost github.com\n\tIdentityFile ~/.ssh/github.{{ grains['host'] }}.pky\n"

# create a new Github SSH key for each machine named with $(hostname)

