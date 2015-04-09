{% if grains["cpuarch"] == "arm" %}
jdk-install:
  pkg.installed:
    - name: openjdk-7-jdk


{% elif grains["os"] == "MacOS" %}
#brew-cask-install:
#  pkg.installed:
#    - name: caskroom/cask/brew-cask

java-install-with-cask:
  caskroom.installed:
    - name: java

#java-install-with-cask:
#  cmd.run:
#    - name: brew cask install java
#    - user: {{ pillar['login_user'] }}


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
    - debconf: salt://java/oracle-java7-installer.ans
    - require:
      - pkgrepo: webupd8team-java-ppa
{% endif %}
