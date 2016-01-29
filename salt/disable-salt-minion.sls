# when running salt masterless, the minion doesn't need
# to run as a daemon
disable-salt-minion:
  service.dead:
    - name: salt-minion
    - enable: false
