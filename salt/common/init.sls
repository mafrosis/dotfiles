git:
  pkg.latest:
    - order: 1

system-tools:
  pkg.latest:
    - names:
      - at
      - bc
      - disktype
      - file
      - less
      - make
      - time
      - vim
      - whois

{% set timezone = pillar.get('timezone', 'Australia/Melbourne') %}

/etc/timezone:
  timezone.system:
    - name: {{ timezone }}
    - utc: true
