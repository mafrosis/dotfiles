docker-apt-deps:
  pkg.installed:
    - names:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - libffi-dev
      - software-properties-common

/etc/apt/keyrings:
  file.directory

docker-apt-gpg:
  file.managed:
    - name: /tmp/docker.gpg
    - source: https://download.docker.com/linux/debian/gpg
    - source_hash: md5=1afae06b34a13c1b3d9cb61a26285a15
    - keep_source: false
  cmd.wait:
    - name: cat /tmp/docker.gpg | gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg
    - watch:
      - file: docker-apt-gpg

docker-pkgrepo:
  pkgrepo.managed:
    - humanname: docker
    - name: deb [arch={{ grains['osarch'] }} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian {{ grains['oscodename'] }} stable
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
