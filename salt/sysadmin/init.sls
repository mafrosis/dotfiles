include:
  - apt

required-packages-sysadmin:
  pkg.installed:
    - names:
      - disktype
    - require:
      - file: apt-no-recommends
