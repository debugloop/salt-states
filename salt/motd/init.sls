/etc/motd.tail:
  file.managed:
    - template: jinja
    - source: salt://motd/motd.tail

/etc/issue.net:
  file.managed:
    - template: jinja
    - source: salt://motd/issue.net

/etc/ssh/sshd_config:
  file.uncomment:
    - regex: "Banner /etc/issue.net"
