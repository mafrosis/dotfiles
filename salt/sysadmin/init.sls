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
      - parted
      - dnsutils
    - require:
      - file: apt-no-recommends
