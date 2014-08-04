serial-tty-config:
{% if grains['os'] == 'Debian'%}
  file.append:
    - name: /etc/inittab
    - text: T0:S12345:respawn:/sbin/getty -hL ttyS0 115200 vt100
{% endif %}
{% if grains['os'] == 'Ubuntu'%}
  file.managed:
    - name: /etc/init/ttyS0.conf
    - source: salt://virsh_console/ttyS0.conf
{% endif %}

/etc/default/grub:
  file.replace:
    - pattern: ^GRUB_CMDLINE_LINUX_DEFAULT="quiet"$
    - repl: GRUB_CMDLINE_LINUX_DEFAULT="quiet serial=tty0 console=ttyS0,115200n8"

update-grub:
  cmd.wait:
    - name: /usr/sbin/update-grub
    - watch:
      - file: serial-tty-config
      - file: /etc/default/grub
