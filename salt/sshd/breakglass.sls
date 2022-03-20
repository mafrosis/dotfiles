include:
  - sshd.authorized_keys


{% set user = pillar['login_user'] %}

yubikey-15460210:
  file.managed:
    - name: /home/{{ user }}/.ssh/authorized_breakglass_keys
    - contents: "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAZ2uyz2VLk9xcNMr7RiVwZfBsRfGmixkulOX+wvnpzXiAaytBsLP/WtduN0FVUsopk+AR8hRTcccs3EZuwYvEsAAAAEc3NoOg== breakglass@yubikey-15460210"
    - user: {{ user }}
    - mode: 600
