{% if grains['os_family'] == 'Debian' %}
include:
  - common.debian
{% endif %}

git:
  pkg.latest:
    - order: 1
