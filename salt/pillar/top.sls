base:
  '*':
    - mafro

  'G@host:monopoly or G@id:monopoly':
    - match: compound
    - monopoly
    - wakeonlan

  'G@host:kerplunk or G@id:kerplunk':
    - match: compound
    - kerplunk
    - kerplunk-secrets
    - inform

  'G@host:mousetrap or G@id:mousetrap':
    - match: compound
    - mousetrap

  'id:raspbmc':
    - match: grain
    - raspbmc
