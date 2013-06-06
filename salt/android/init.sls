include:
  - dev_user
  - java

android-sdk-download:
  file.managed:
    - name: /home/{{ grains['user'] }}/android-sdk_r22.0.1-linux.tgz
    - source: https://dl.google.com/android/android-sdk_r22.0.1-linux.tgz
    - source_hash: sha1=2f6d4cc7379f80fbdc45d1515c8c47890a40a781
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
  cmd.wait:
    - name: tar xzf /home/{{ grains['user'] }}/android-sdk_r22.0.1-linux.tgz
    - user: {{ grains['user'] }}
    - watch:
      - file: android-sdk-download

android-sdk-chown:
  cmd.run:
    - name: chown -R {{ grains['user'] }}:{{ grains['user'] }} /home/{{ grains['user'] }}/android-sdk-linux
    - require:
      - cmd: android-sdk-download

android-sdk-update:
  cmd.run:
    - name: echo "y" | /home/{{ grains['user'] }}/android-sdk-linux/tools/android update sdk -s --no-ui --filter tool,platform-tool,android-16
    - user: {{ grains['user'] }}
    - require:
      - cmd: android-sdk-download
      - pkg: jdk-install

android-sdk-PATH:
  file.sed:
    - name: /home/{{ grains['user'] }}/dotfiles/zsh/.zshrc
    - before: "~/Development/android/android-sdk-macosx"
    - after: "/home/{{ grains['user'] }}/android-sdk-linux"
    - limit: ^export ANDROID_HOME=
    - backup: ''
    - require:
      - cmd: android-sdk-download
      - cmd: install-dotfiles
