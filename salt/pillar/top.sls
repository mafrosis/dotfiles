base:
  '*':
    - mafro

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

  'id:raspbmc':
    - match: grain
    - raspbmc
