dovecot-imapd:
  pkg:
    - installed

mutt:
  pkg:
    - installed

/etc/init.d/dovecot:
  file.managed:
    - source: salt://imap/dovecot.initd
    - mode: 744
    - require:
      - pkg: dovecot-imapd

dovecot-system-auth-disabled:
  file.sed:
    - name: /etc/dovecot/conf.d/10-auth.conf
    - before: "!include auth-system.conf.ext"
    - after: "#!include auth-system.conf.ext"
    - limit: "^!include auth-system.conf.ext"
    - backup: ''
    - require:
      - pkg: dovecot-imapd

dovecot-passwd-auth-enabled:
  file.sed:
    - name: /etc/dovecot/conf.d/10-auth.conf
    - before: "#!include auth-passwdfile.conf.ext"
    - after: "!include auth-passwdfile.conf.ext"
    - backup: ''

dovecot-plaintext-auth-enabled:
  file.sed:
    - name: /etc/dovecot/conf.d/10-auth.conf
    - before: "#disable_plaintext_auth = yes"
    - after: "disable_plaintext_auth = no"
    - backup: ''
    - require:
      - pkg: dovecot-imapd

{% if "maildir" in grains %}
{% set maildir = grains['maildir'] %}
{% else %}
{% set maildir = "/home/"+grains['user']+"/Maildir" %}
{% endif %}

dovecot-maildir-location:
  file.sed:
    - name: /etc/dovecot/conf.d/10-mail.conf
    - before: "#mail_location = "
    - after: "mail_location = maildir:{{ maildir }}"
    - backup: ''
    - require:
      - pkg: dovecot-imapd

dovecot-user-auth-file:
  file.managed:
    - name: /etc/dovecot/users
    - source: salt://imap/dovecot.users
    - template: jinja
    - context:
        user: {{ grains['user'] }}
        password: eggs
        uid: {{ salt['cmd.exec_code']('bash', 'id -u '+grains['user']) }}
        gid: {{ salt['cmd.exec_code']('bash', 'id -g '+grains['user']) }}
        home: /home/{{ grains['user'] }}

maildir-create:
  file.directory:
    - name: {{ maildir }}
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - require:
      - file: dovecot-system-auth-disabled
      - file: dovecot-passwd-auth-enabled
      - file: dovecot-plaintext-auth-enabled
      - file: dovecot-maildir-location
      - file: dovecot-user-auth-file

dovecot-reload-config:
  service.running:
    - name: dovecot
    - watch:
      - file: maildir-create

