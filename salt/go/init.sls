include:
  - common

go-source-base:
  file.directory:
    - name: /home/{{ grains['user'] }}/src
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}

go-source:
  file.managed:
    - name: /home/{{ grains['user'] }}/src/go1.1.src.tar.gz
    - source: https://go.googlecode.com/files/go1.1.src.tar.gz
    - source_hash: sha1=a464704ebbbdd552a39b5f9429b059c117d165b3
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - require:
      - file: go-source-base
  cmd.run:
    - name: tar xf go1.1.src.tar.gz
    - unless: ls /home/{{ grains['user'] }}/src/go
    - cwd: /home/{{ grains['user'] }}/src
    - runas: {{ grains['user'] }}
    - watch:
      - file: go-source

go-source-install:
  cmd.run:
    - name: ./all.bash
    - unless: ls /home/{{ grains['user'] }}/src/go/bin/go
    - cwd: /home/{{ grains['user'] }}/src/go/src
    - runas: {{ grains['user'] }}
    - require:
      - cmd: go-source
      - pkg: required-packages

helloworld.go:
  file.managed:
    - name: /home/{{ grains['user'] }}/hello.go
    - source: salt://go/hello.go
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - require:
      - file: go-source-base
  cmd.run:
    - name: /home/{{ grains['user'] }}/src/go/bin/go run hello.go
    - cwd: /home/{{ grains['user'] }}
    - runas: {{ grains['user'] }}
    - require:
      - cmd: go-source-install
    - watch:
      - file: helloworld.go
