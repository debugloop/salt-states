# This state installs a django project using nginx, postgresql and gunicorn. It
# also supports further modules using hypervisor if you drop your config in the
# files directory, like I did for huey.

{% set project_name = 'kvmate' %}
{% set git_url = 'https://github.com/kvmate/kvmate.git' %}
{% set server_name = 'dn.user.selfnet.de' %}
{% set salt_master = 'salt' %}

# gunicorn is practically required for the runserver and nginx assumes its
# socket. You can freely modify the following ones to your needs.
{% set components = ['gunicorn','huey'] %}
{% set additional_deps = [] %}

# best don't edit this one:
{% set project_home = '/home/' + project_name %}

include:
  - .dependencies
  - .directories
  - .settings
  - .database
  - .gunicorn
  - .supervisor
  - .webserver

# Core Stuff
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
