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

  'id:raspbmc':
    - match: grain
    - raspbmc
