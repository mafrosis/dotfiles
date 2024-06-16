step-ca:
  group.present

/etc/step_root_ca.crt:
  file.managed:
    - contents_pillar: smallstep_root_ca_cert
    - group: step-ca
    - mode: 640
    - require:
      - group: step-ca
