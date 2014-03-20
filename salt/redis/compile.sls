# get stable link from here: http://redis.io/download
# hashes are here: https://github.com/antirez/redis-hashes/blob/master/README
{% set version = '2.8.7' %}
/root/redis-{{ version }}.tar.gz:
  file.managed:
    - source: http://download.redis.io/releases/redis-{{ version }}.tar.gz
    - source_hash: sha1=acc369093ec74223e6da207921595187f7e64998

unpack:
  cmd.wait:
    - name: tar xzf redis-{{ version }}.tar.gz
    - cwd: /root
    - watch:
      - file: /root/redis-{{ version }}.tar.gz

make:
  pkg.installed:
    - name: build-essential
  cmd.wait:
    - name: make
    - cwd: /root/redis-{{ version }}
    - require:
      - pkg: make
    - watch:
      - cmd: unpack

copy-server:
  file.copy:
    - name: /usr/local/bin/redis-server
    - source: /root/redis-{{ version }}/src/redis-server
    - force: True
    - watch:
      - cmd: make

copy-cli:
  file.copy:
    - name: /usr/local/bin/redis-cli
    - source: /root/redis-{{ version }}/src/redis-cli
    - force: True
    - watch:
      - cmd: make

cleanup:
  cmd.wait:
    - name: rm -r redis-{{ version }} && rm redis-{{version }}.tar.gz
    - cwd: /root
    - require:
      - file: copy-server
      - file: copy-server
    - watch:
      - cmd: make
