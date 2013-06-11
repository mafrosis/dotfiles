base:
  'user:vagrant':
    - match: grain
    - mafro
  'user:mafro':
    - match: grain
    - mafro

  'role:chromebook':
    - match: grain
    - chromebook
