pip-dependencies:
  pkg.installed:
    - names:
      - python-dev
      - build-essential
      - python-pip
      - python-virtualenv

virtualenvwrapper-bin:
  pip.installed:
    - name: virtualenvwrapper
    - require:
      - pkg: pip-dependencies

virtualenv-init:
  virtualenv.manage:
    - name: /home/{{ grains['user'] }}/.virtualenvs/venv
    - runas: {{ grains['user'] }}
    - distribute: True
    - require:
      - pkg: pip-dependencies

virtualenv-init-pip:
  pip.installed:
    - name: pip
    - upgrade: true
    - ignore_installed: true
    - user: {{ grains['user'] }}
    - bin_env: /home/{{ grains['user'] }}/.virtualenvs/venv
    - require:
      - virtualenv: virtualenv-init

virtualenv-init-distribute:
  pip.installed:
    - name: distribute
    - upgrade: true
    - ignore_installed: true
    - user: {{ grains['user'] }}
    - bin_env: /home/{{ grains['user'] }}/.virtualenvs/venv
    - require:
      - pip: virtualenv-init-pip
