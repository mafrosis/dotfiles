docker-apt-deps:
  pkg.installed:
    - names:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - libffi-dev
      - software-properties-common

/etc/apt/keyrings/docker.gpg:
  file.managed:
    - source: https://download.docker.com/linux/debian/gpg
    - source_hash: md5=1afae06b34a13c1b3d9cb61a26285a15
    - makedirs: true

docker-pkgrepo:
  pkgrepo.managed:
    - humanname: docker
    - name: deb [arch={{ grains['osarch'] }} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/{{ grains['os']|lower }} {{ grains['oscodename'] }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - require_in:
      - pkg: docker-install

docker-install:
  pkg.installed:
    - name: docker-ce
    - require:
      - pkg: docker-apt-deps

docker-compose-plugin:
  pkg.installed

docker-adduser-group:
  group.present:
    - name: docker
    - addusers:
      - {{ pillar['login_user'] }}
