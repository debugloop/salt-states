salt-master:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: salt-master
    - watch:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/schedule.conf
      - file: /etc/salt/master.d/reactor.conf

/etc/salt/master:
  file.managed:
    - source: salt://salt_master_conf/master

/etc/salt/master.d/schedule.conf:
  file.managed:
    - source: salt://salt_master_conf/schedule.conf

/etc/salt/master.d/reactor.conf:
  file.managed:
    - source: salt://salt_master_conf/reactor.conf
