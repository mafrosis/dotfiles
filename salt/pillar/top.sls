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

  'id:raspbmc':
    - match: grain
    - raspbmc
