driver-source:
  git.latest:
    - name: https://github.com/brektrou/rtl8821CU
    - target: /tmp/rtl8821CU
  cmd.wait:
    - name: chmod +x dkms-install.sh && bash dkms-install.sh && modprobe 8821cu
    - cwd: /tmp/rtl8821CU
    - watch:
      - git: driver-source
