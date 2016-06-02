nvidia-glx:
  pkg.installed

/usr/share/X11/xorg.conf.d/20-nvidia.conf:
  file.managed:
    - contents: |
        Section "Device"
            Identifier "{{ grains['host'] }}"
            Driver "nvidia"
        EndSection
    - require:
      - pkg: xserver-xorg
