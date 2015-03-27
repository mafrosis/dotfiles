base:
  '*':
    - mafro

  'G@host:monopoly or G@id:monopoly':
    - match: compound
    - monopoly
    - wakeonlan

  'id:raspbmc':
    - match: grain
    - raspbmc
