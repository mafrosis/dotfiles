{% set user = grains.get('user') %}
{% set GOPATH = pillar.get('GOPATH', '/home/'+user+'/dev/go') %}

libpod-install-deps:
  pkg.installed:
    - names:
      - btrfs-tools
      - git
      - golang-go
      - go-md2man
      - iptables
      - libassuan-dev
      - libdevmapper-dev
      - libglib2.0-dev
      - libc6-dev
      - libgpgme11-dev
      - libgpg-error-dev
      - libprotobuf-dev
      - libprotobuf-c0-dev
      - libseccomp-dev
      - libselinux1-dev
      - pkg-config
      - libsystemd-dev
      - uidmap

{{ GOPATH }}/src/github.com:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}

crio:
  git.latest:
    - name: git://github.com/cri-o/cri-o
    - rev: v1.13.9
    - target: {{ GOPATH }}/src/github.com/cri-o/cri-o
    - runas: {{ user }}
  cmd.wait:
    - name: mkdir bin && make bin/conmon && install -D -m 755 bin/conmon /usr/libexec/podman/conmon
    - cwd: {{ GOPATH }}/src/github.com/cri-o/cri-o
    - watch:
      - git: crio

runc:
  git.latest:
    - name: git://github.com/opencontainers/runc
    - rev: v1.0.0-rc8
    - target: {{ GOPATH }}/src/github.com/opencontainers/runc
    - runas: {{ user }}
  cmd.wait:
    - name: make BUILDTAGS="seccomp" && cp runc /usr/bin/runc
    - cwd: {{ GOPATH }}/src/github.com/opencontainers/runc
    - watch:
      - git: runc

containernetworking-plugins:
  git.latest:
    - name: git://github.com/containernetworking/plugins
    - rev: master
    - target: {{ GOPATH }}/src/github.com/containernetworking/plugins
    - runas: {{ user }}
  cmd.wait:
    - name: ./build_linux.sh && mkdir -p /usr/libexec/cni && cp bin/* /usr/libexec/cni
    - cwd: {{ GOPATH }}/src/github.com/containernetworking/plugins
    - watch:
      - git: containernetworking-plugins

libpod:
  git.latest:
    - name: git://github.com/containers/libpod
    - rev: v1.3.0
    - target: {{ GOPATH }}/src/github.com/containers/libpod
    - runas: {{ user }}
  cmd.wait:
    - name: make && make install PREFIX=/usr
    - cwd: {{ GOPATH }}/src/github.com/containers/libpod
    - watch:
      - git: libpod

/etc/containers:
  file.directory

/etc/containers/registries.conf:
  file.managed:
    - source: https://raw.githubusercontent.com/projectatomic/registries/master/registries.fedora
    - replace: false

/etc/containers/policy.json:
  file.managed:
    - source: https://raw.githubusercontent.com/containers/skopeo/master/default-policy.json
    - replace: false
