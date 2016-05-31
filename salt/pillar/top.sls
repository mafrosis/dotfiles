base:
  '*':
    - mafro

  'G@host:monopoly or G@id:monopoly':
    - match: compound
    - monopoly
    - wakeonlan

  'G@host:locke or G@id:vagrant':
    - match: compound
    - locke
    - locke-secrets

  'G@host:mousetrap or G@id:mousetrap':
    - match: compound
    - mousetrap

  'id:raspbmc':
    - match: grain
    - raspbmc
