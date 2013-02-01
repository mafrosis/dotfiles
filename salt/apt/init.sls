apt-no-recommends:
  file.managed:
    - source: salt://apt/00NoRecommends
    - name: /etc/apt/apt.conf.d/00NoRecommends
    - order: first
