salt-minion:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-minion
    - watch:
      - file: /etc/salt/minion

/etc/salt/minion:
  file.managed:
    - source: salt://salt_minion_conf/minion
    - template: jinja
