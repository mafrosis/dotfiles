git:
  pkg.latest:
    - order: 1

system-tools:
  pkg.latest:
    - names:
      - at
      - bc
      - file
      - less
      - ntp
      - time
      - vim
      - whois

{% set timezone = pillar.get('timezone', 'Australia/Melbourne') %}

{{ timezone }}:
  timezone.system:
    - utc: true
