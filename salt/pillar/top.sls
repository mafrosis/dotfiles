base:
  '*':
    - github_pky
    - mafro

  # default Vagrant host for testing
  'vmware:true':
    - match: grain
    - vagrant

  'host:mousetrap':
    - match: grain
    - mousetrap
  'host:monopoly':
    - match: grain
    - monopoly

  'id:raspbmc':
    - match: grain
    - raspbmc
