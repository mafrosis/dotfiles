yubikey-apt-deps:
  pkg.latest:
    - names:
      - pcscd

pcscd:
  service.running:
    - enable: true
