/etc/inittab:
  file:
    - append
    - text: T0:S12345:respawn:/sbin/getty -hL ttyS0 115200 vt100

/etc/default/grub:
  file:
    - sed
    - before: ^GRUB_CMDLINE_LINUX_DEFAULT="quiet"$
    - after: GRUB_CMDLINE_LINUX_DEFAULT="quiet serial=tty0 console=ttyS0,115200n8"

update-grub:
  cmd:
    - wait
    - name: /usr/sbin/update-grub
    - watch:
      - file: /etc/inittab
      - file: /etc/default/grub
