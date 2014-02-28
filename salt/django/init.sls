# This state installs a django project using nginx, postgresql and gunicorn. It
# also supports further modules using hypervisor if you drop your config in the
# files directory, like I did for huey.

{% set project_name = pillar['django_project_name'] %}
{% set git_url = pillar['django_git_url'] %}
{% set server_name = pillar['django_server_name'] %}

# gunicorn is practically required for the runserver and nginx assumes its
# socket. You can freely modify the following ones to your needs.
{% set components = pillar['django_deploy_components'] %}
{% set additional_deps = pillar['django_additional_dependencies'] %}

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
    - require:
      - user: {{ project_name }}
