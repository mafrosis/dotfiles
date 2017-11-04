docker-apt-deps:
  pkg.installed:
    - names:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - software-properties-common

docker-pkgrepo:
  pkgrepo.managed:
    - humanname: docker
    - name: deb [arch=amd64] https://download.docker.com/linux/{{ grains['os']|lower }} {{ grains['oscodename'] }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/{{ grains['os']|lower }}/gpg
    - require_in:
      - pkg: docker-install

docker-install:
  pkg.installed:
    - name: docker-ce
    - require:
      - pkg: docker-apt-deps

docker-compose-install:
  file.managed:
    - name: /usr/local/bin/docker-compose
    - source: https://github.com/docker/compose/releases/download/1.7.1/docker-compose-Linux-x86_64
    - source_hash: sha1=f8c4b82c22f905ed5eaa5cd82d1e28d5ad6df43d
    - mode: 744

docker-adduser-group:
  group.present:
    - name: docker
    - addusers:
      - {{ pillar['login_user'] }}
