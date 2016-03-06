docker-pkgrepo:
  pkgrepo.managed:
    - humanname: docker
    - name: deb https://apt.dockerproject.org/repo {{ grains['os']|lower }}-{{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: hkp://p80.pool.sks-keyservers.net:80
    - require_in:
      - pkg: docker-install

docker-install:
  pkg.installed:
    - name: docker-engine

docker-compose-install:
  file.managed:
    - name: /usr/local/bin/docker-compose
    - source: https://github.com/docker/compose/releases/download/1.7.1/docker-compose-Linux-x86_64
    - source_hash: sha1=f8c4b82c22f905ed5eaa5cd82d1e28d5ad6df43d
    - mode: 744
