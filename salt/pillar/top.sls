base:
  '*':
    - github_pky
    - mafro

  # default Vagrant host for testing
  'vmware:true':
    - match: grain
    - vagrant

  'host:monopoly':
    - match: grain
    - monopoly
    - wakeonlan

  'id:raspbmc':
    - match: grain
    - raspbmc
