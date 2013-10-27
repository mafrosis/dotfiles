abgx360-pkg-reqs:
  pkg.installed:
    - names:
      - libcurl4-openssl-dev
      - zlib1g-dev

abgx360-source:
  file.managed:
    - name: /tmp/abgx360-1.0.6.tar.gz
    - source: http://dl.dropbox.com/u/59058148/abgx360-1.0.6.tar.gz
    - source_hash: sha1=f06d54c51c5fb3347f7291f36945d903c9f3cd60
  cmd.wait:
    - name: tar xzf /tmp/abgx360-1.0.6.tar.gz
    - cwd: /tmp
    - watch:
      - file: abgx360-source

build-essential:
  pkg.installed

abgx360-configure:
  cmd.run:
    - name: ./configure && make && make install
    - unless: which abgx360
    - cwd: /tmp/abgx360-1.0.6
    - require:
      - pkg: build-essential
