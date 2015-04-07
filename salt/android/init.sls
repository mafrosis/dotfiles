include:
  - java

{% if '64' in grains["cpuarch"] %}
ia32-libs:
  pkg:
    - installed
{% endif %}

{% if grains['os'] == "Darwin" %}
android-sdk-download:
  file.managed:
    - name: /home/{{ pillar['login_user'] }}/android-sdk.zip
    - source: http://dl.google.com/android/android-sdk_r24.1.2-macosx.zip
    - source_hash: sha1=00e43ff1557e8cba7da53e4f64f3a34498048256
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
  cmd.wait:
    - name: unzip /home/{{ pillar['login_user'] }}/android-sdk.zip
    - user: {{ pillar['login_user'] }}
    - watch:
      - file: android-sdk-download
{% else %}
android-sdk-download:
  file.managed:
    - name: /home/{{ pillar['login_user'] }}/android-sdk.tgz
    - source: http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz
    - source_hash: sha1=68980e4a26cca0182abb1032abffbb72a1240c51
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
  cmd.wait:
    - name: tar xzf /home/{{ pillar['login_user'] }}/android-sdk.tgz -O android-sdk
    - user: {{ pillar['login_user'] }}
    - watch:
      - file: android-sdk-download
{% endif %}

android-sdk-chown:
  cmd.run:
    - name: chown -R {{ pillar['login_user'] }}:{{ pillar['login_user'] }} /home/{{ pillar['login_user'] }}/android-sdk-linux
    - require:
      - cmd: android-sdk-download

android-sdk-update:
  cmd.run:
    - name: echo "y" | /home/{{ pillar['login_user'] }}/android-sdk-linux/tools/android update sdk -s --no-ui --filter tool,platform-tool,android-16
    - user: {{ pillar['login_user'] }}
    - require:
      - cmd: android-sdk-download
      - pkg: jdk-install

android-sdk-PATH:
  file.sed:
    - name: /home/{{ pillar['login_user'] }}/dotfiles/zsh/.zshrc
    - before: "~/Development/android/android-sdk-macosx"
    - after: "/home/{{ pillar['login_user'] }}/android-sdk-linux"
    - limit: ^export ANDROID_HOME=
    - backup: ''
    - require:
      - cmd: android-sdk-download
      - cmd: install-dotfiles
