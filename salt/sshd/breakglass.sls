include:
  - sshd.authorized_keys


{% set user = pillar.get('login_user', 'mafro') %}

/home/{{ user }}/.ssh:
  file.directory:
    - mode: 700
    - user: {{ user }}
    - group: {{ user }}

yubikey-15460210:
  file.managed:
    - name: /home/{{ user }}/.ssh/authorized_breakglass_keys
    - contents: "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAZ2uyz2VLk9xcNMr7RiVwZfBsRfGmixkulOX+wvnpzXiAaytBsLP/WtduN0FVUsopk+AR8hRTcccs3EZuwYvEsAAAAEc3NoOg== breakglass@yubikey-15460210"
    - user: {{ user }}
    - mode: 600
    - require:
      - file: /home/{{ user }}/.ssh
