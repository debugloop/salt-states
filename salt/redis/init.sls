redis_6379:
  pkg.purged: []
  service.running:
    - require:
      - file: /etc/redis
      - file: /var/redis
    - watch:
      - file: /usr/local/bin/redis-server
      - file: /usr/local/bin/redis-cli
      - file: /etc/redis/6379.conf
      - cmd: update-rc

/usr/local/bin/redis-server:
  file.exists: []

/usr/local/bin/redis-cli:
  file.exists: []

/var/redis/6379:
  file.directory:
    - user: root
    - group: root

/etc/redis:
  file.directory:
    - user: root
    - group: root

/var/redis:
  file.directory:
    - user: root
    - group: root

/etc/redis/6379.conf:
  file.managed:
    - source: salt://redis/redis.conf
    - require:
      - file: /etc/redis

/etc/init.d/redis_6379:
  file.managed:
    - mode: 744
    - source: salt://redis/redis_6379

update-rc:
  cmd.wait:
    - name: update-rc.d redis_6379 defaults
    - watch:
      - file: /etc/init.d/redis_6379
