include:
  - apt

required-packages-sysadmin:
  pkg.installed:
    - names:
      - disktype
      - whois
      - telnet
    - require:
      - file: apt-no-recommends
