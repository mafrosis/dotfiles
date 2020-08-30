base:
  'G@id:vagrant':
    - match: compound
    - vagrant

  'G@host:jorg or G@id:jorg':
    - match: compound
    - jorg
    - jorg-secrets
    - wakeonlan

  'G@host:locke':
    - match: compound
    - locke
    - locke-secrets

  'G@host:kvothe':
    - match: compound
    - kvothe

  'id:raspbmc':
    - match: grain
    - raspbmc

  'G@host:ringil':
    - match: compound
    - ringil
