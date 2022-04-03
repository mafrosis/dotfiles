docker-apt-deps:
  pkg.installed:
    - names:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - libffi-dev
      - software-properties-common

# HACK: docker didnt release into stable for bionic
# https://github.com/docker/for-linux/issues/290#issuecomment-393605253
{% if grains['oscodename'] == 'bionic' %}
{% set oscodename = 'artful' %}
{% else %}
{% set oscodename = grains['oscodename'] %}
{% endif %}

docker-pkgrepo:
  pkgrepo.managed:
    - humanname: docker
    - name: deb [arch={{ grains['osarch'] }}] https://download.docker.com/linux/{{ grains['os']|lower }} {{ oscodename }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/{{ grains['os']|lower }}/gpg
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
