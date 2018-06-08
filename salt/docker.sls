docker-apt-deps:
  pkg.installed:
    - names:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - software-properties-common

{# HACK: docker didnt release into stable for bionic #}
{# https://github.com/docker/for-linux/issues/290#issuecomment-393605253 #}
{% if grains['oscodename'] == 'bionic' %}
{% set oscodename = 'artful' %}
{% else %}
{% set oscodename = grains['oscodename'] %}
{% endif %}

docker-pkgrepo:
  pkgrepo.managed:
    - humanname: docker
    - name: deb [arch=amd64] https://download.docker.com/linux/{{ grains['os']|lower }} {{ oscodename }} stable
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
    - source: https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64
    - source_hash: sha256=f679a24b93f291c3bffaff340467494f388c0c251649d640e661d509db9d57e9
    - mode: 755

docker-adduser-group:
  group.present:
    - name: docker
    - addusers:
      - {{ pillar['login_user'] }}
