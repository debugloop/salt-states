ntp:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: ntp
    - watch:
      - file: /etc/ntp.conf

/etc/ntp.conf:
  file.managed:
    - backup: minion
    - source:
      - salt://ntp/ntp.conf
