# TODO after initial setup:
  # install gunicorn and psycopg2
  # update create.py and production.py settings
  # run syncdb on server
  # create bridge/configure kvm networking
  # create kvm storage pool

{% set project_name = 'kvmate' %}
{% set git_url = 'https://github.com/kvmate/kvmate.git' %}
{% set server_name = 'dn.user.selfnet.de' %}
{% set salt_master = 'salt' %}

# leave those here:
{% set project_home = '/home/' + project_name %}

# Requirements
dependencies:
  pkg.installed:
    - pkgs:
      - python-openssl
      - python-virtualenv
      - python-dev
      - gcc
      - pkg-config
      - virtinst
      - libvirt-bin
      - libvirt-dev
      - bridge-utils
      - postgresql
      - postgresql-server-dev-all
      - python-psycopg2
      - redis-server
      - supervisor

# Core
{{ project_name }}:
  user.present:
    - home: {{ project_home }}
    - shell: /bin/bash
    - create_home: True
    - groups:
      - libvirt
    - remove_groups: False
    - require:
      - pkg: dependencies
  git.latest:
    - name: {{ git_url }}
    - rev: master
    - user: {{ project_name }}
    - target: {{ project_home }}/src
  file.managed:
    - name: {{ project_home }}/src/{{ project_name }}/{{ project_name }}/settings/local_settings.py
    - source: salt://{{ project_name }}/local_settings.py
    - user: {{ project_name }}
    - group: {{ project_name }}
    - template: jinja
    - context:
      project_name: {{ project_name }}
  virtualenv.managed:
    - name: {{ project_home }}
    - requirements: {{ project_home }}/src/requirements.d/production.txt
    - user: {{ project_name }}
    - no_chown: True
    - cwd: {{ project_home }}/src/requirements.d/
  module.wait:
    - func: djangomod.collectstatic
    - settings_module: {{ project_name }}.settings
    - watch:
      - git: {{ project_name }}

supervisor_{{ project_name }}:
  supervisord.running:
    - name: {{ project_name }}
    - update: True
    - watch:
      - file: {{ project_name }}
    - require:
      - pkg: dependencies
      - file: {{ project_name }}
  file.managed:
    - name: /etc/supervisor/conf.d/{{ project_name }}.conf
    - source: salt://{{ project_name }}/supervisor_{{ project_name }}.conf
    - template: jinja
    - context:
      project_name: {{ project_name }}
      project_home: {{ project_home }}

# Supervisor for a component
{{ project_name }}_huey:
  supervisord.running:
    - update: True
    - watch:
      - file: {{ project_name }}_huey
    - require:
      - pkg: dependencies
      - file: {{ project_name }}_huey
  file.managed:
    - name: /etc/supervisor/conf.d/{{ project_name }}_huey.conf
    - source: salt://{{ project_name }}/supervisor_{{ project_name }}_huey.conf
    - template: jinja
    - context:
      project_name: {{ project_name }}
      project_home: {{ project_home }}

# Database setup
postgresql:
  postgres_database.present:
    - name: {{ project_name }}
    - owner: {{ project_name }}
    - runas: postgres
  postgres_user.present:
    - name: {{ project_name }}
    - createdb: False
    - createuser: False
    - encrypted: True
    - superuser: False
    - replication: False
    - password: {{ pillar['postgres_password'] }}
    - runas: postgres

# Webserver
tls.create_self_signed_cert:
  module.run:
    - CN: {{ server_name }}
nginx:
  pkg:
    - installed
  service.running:
    - reload: True
    - watch:
      - file: /etc/nginx/sites-enabled/{{ project_name }}
      - file: /etc/nginx/sites-available/{{ project_name }}
    - require:
      - module: tls.create_self_signed_cert
  file.managed:
    - name: /etc/nginx/sites-available/{{ project_name }}
    - source: salt://{{ project_name }}/nginx.conf
    - require:
      - pkg: dependencies
    - template: jinja
    - context:
      project_name: {{ project_name }}
      project_home: {{ project_home }}
      server_name: {{ server_name }}

/etc/nginx/sites-enabled/{{ project_name }}:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ project_name }}
    - require:
      - file: /etc/nginx/sites-available/{{ project_name }}

# files that need to be served by the webserver
{{ project_home }}/preseed/post_install.sh:
  file.managed:
    - source: salt://{{ project_name }}/post_install.sh
    - user: {{ project_name }}
    - group: {{ project_name }}
    - makedirs: True
    - mode: 644
    - template: jinja
    - context:
      project_name: {{ project_name }}
      salt_master: {{ salt_master }}
    - require:
      - user: {{ project_name }}

# other directories and files which need to be created
{{ project_home }}/bin/gunicorn_start:
  file.managed:
    - source: salt://{{ project_name }}/gunicorn_start
    - user: {{ project_name }}
    - group: {{ project_name }}
    - mode: 755
    - template: jinja
    - context:
      project_name: {{ project_name }}
      project_home: {{ project_home }}
    - require:
      - virtualenv: {{ project_name }}
      - user: {{ project_name }}

{{ project_home }}/logs:
  file.directory:
    - user: {{ project_name }}
    - group: {{ project_name }}
    - dir_mode: 777
    - require:
      - user: {{ project_name }}

{{ project_home }}/run:
  file.directory:
    - user: {{ project_name }}
    - group: {{ project_name }}
    - dir_mode: 755
    - require:
      - user: {{ project_name }}

{{ project_home }}/static:
  file.directory:
    - user: {{ project_name }}
    - group: {{ project_name }}
    - dir_mode: 755
    - require:
      - user: {{ project_name }}
