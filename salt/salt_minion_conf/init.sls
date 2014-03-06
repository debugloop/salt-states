salt-minion:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-minion
    - watch:
      - file: /etc/salt/minion.d/smtp.conf

/etc/salt/minion.d/smtp.conf:
  file.managed:
    - source: salt://salt_minion_conf/smtp.conf
    - template: jinja
