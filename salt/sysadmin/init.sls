include:
  - apt

required-packages-sysadmin:
  pkg.installed:
    - names:
      - disktype
      - whois
      - telnet
      - curl
      - rsync
      - axel
      - zip
      - unzip
      - cryptsetup
    - require:
      - file: apt-no-recommends
