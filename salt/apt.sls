apt-no-recommends:
  file.managed:
    - name: /etc/apt/apt.conf.d/00NoRecommends
    - contents: |
        APT::Install-Recommends "0";
        APT::Install-Suggests "0";
    - order: first

{% if pillar.get('autoupdate', false) %}
autoupdate-requisites:
  pkg.latest:
    - names:
      - unattended-upgrades
      - bsd-mailx

# wheezy is configured for auto security updates in:
# /etc/apt/apt.conf.d/50unattended-upgrades
/etc/apt/apt.conf.d/02periodic:
  file.managed:
    - contents: |
        APT::Periodic::Enable "1";
        APT::Periodic::Update-Package-Lists "1";
        APT::Periodic::Unattended-Upgrade "1";
        APT::Periodic::AutocleanInterval "7";

{% if pillar.get('admin_email', false) %}
apticron:
  pkg.latest

/etc/apticron/apticron.conf:
  file.managed:
    - contents: |
        EMAIL="{{ pillar['admin_email'] }}"
{% endif %}
{% endif %}
