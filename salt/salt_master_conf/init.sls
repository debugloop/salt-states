salt-master:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-master
    - watch:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/redis.conf
      - file: /etc/salt/master.d/schedule.conf
      - file: /etc/salt/master.d/reactor.conf

saltfiles:
  git.latest:
    - name: https://github.com/analogbyte/salt-states.git
    - user: danieln
    - rev: master
    - target: /srv

salt-run root_password.regen_all &> /dev/null:
  cron.present:
    - user: root
    - minute: '0'
    - hour: '5'
    - daymonth: '*'
    - month: '*'

/etc/salt/master:
  file.managed:
    - source: salt://salt_master_conf/master

/etc/salt/master.d/redis.conf:
  file.managed:
    - source: salt://salt_master_conf/redis.conf

/etc/salt/master.d/schedule.conf:
  file.managed:
    - source: salt://salt_master_conf/schedule.conf

/etc/salt/master.d/reactor.conf:
  file.managed:
    - source: salt://salt_master_conf/reactor.conf
