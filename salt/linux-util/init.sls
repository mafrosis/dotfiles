include:
  - apt

linux-utils-pkgs:
  pkg.latest:
    - names:
      - usbmount
      - hfsprogs
    - require:
      - file: apt-no-recommends
