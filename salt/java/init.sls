{% if 'arm' in grains["cpuarch"] %}
jdk-install:
  pkg.installed:
    - name: openjdk-7-jdk

{% else %}
webupd8team-java-ppa:
  pkgrepo.managed:
    - human_name: webupd8team PPA
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/webupd8team.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com

jdk-install:
  pkg.installed:
    - name: oracle-java7-installer
    - require:
      - pkgrepo: webupd8team-java-ppa
{% endif %}
