cdparanoia:
  pkg.installed

cdparanoia_zsh:
  file.directory:
    - name: /home/{{ pillar['login_user'] }}/.zsh_aliases.d
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}

cdparanoia_zsh_alias:
  file.managed:
    - name: /home/{{ pillar['login_user'] }}/.zsh_aliases.d/cdparanoia
    - contents: "alias cdparanoia-rip='cdparanoia -S 4 -B --'\n"
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - require:
      - file: cdparanoia_zsh
