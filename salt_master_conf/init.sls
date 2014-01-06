salt-master:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: salt-master
    - watch:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/schedule

/etc/salt/master:
  file:
    - managed
    - source:
      - salt://salt_master_conf/master.{{ grains['host'] }}
      - salt://salt_master_conf/master

/etc/salt/master.d/schedule:
  file:
    - managed
    - source:
      - salt://salt_master_conf/schedule.{{ grains['host'] }}
      - salt://salt_master_conf/schedule
