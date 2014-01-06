ntp:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: ntp
    - watch:
      - file: /etc/ntp.conf

/etc/ntp.conf:
  file:
    - managed
    - source:
      - salt://files/ntp/ntp.conf
