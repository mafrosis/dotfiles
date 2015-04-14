#include:
#  - osx.brew
#
#osx-applications:
#  pkg.installed:
#    - names:
#      - Caskroom/cask/google-chrome
#      - Caskroom/cask/firefox
#      - Caskroom/cask/keepassx
#    - require:
#      - pkg: brew-cask

google-chrome:
  caskroom.installed

ant:
  pkg.installed

