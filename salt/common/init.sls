{% if grains['os_family'] == 'Debian' %}
include:
  - common.debian
{% elif grains['os'] == 'Ubuntu' %}
include:
  - common.ubuntu
{% endif %}

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
      - time
      - whois
