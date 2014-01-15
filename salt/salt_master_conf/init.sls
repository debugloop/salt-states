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

saltfiles:
  git.latest:
    - name: https://github.com/danieljn/salt-states.git
    - user: danieln
    - rev: master
    - target: /srv

/etc/salt/master:
  file.managed:
    - source: salt://salt_master_conf/master

/etc/salt/master.d/schedule.conf:
  file.managed:
    - source: salt://salt_master_conf/schedule.conf

/etc/salt/master.d/reactor.conf:
  file.managed:
    - source: salt://salt_master_conf/reactor.conf

/etc/salt/master.d/mail.conf:
  file.managed:
    - source: salt://salt_master_conf/mail.conf
    - template: jinja
    - context:
      smtp_password : {{ pillar['smtp_password'] }}
