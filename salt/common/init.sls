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

{% if pillar.get('timezone', false) %}
{{ pillar['timezone'] }}:
  timezone.system:
    - utc: true
{% endif %}
