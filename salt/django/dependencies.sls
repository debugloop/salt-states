{% from 'django/init.sls' import project_name,project_home,additional_deps with context %}

dependencies:
  pkg.installed:
    - pkgs:
      - python-openssl
      - python-virtualenv
      - python-dev
      - gcc
      - pkg-config
      - postgresql
      - postgresql-server-dev-all
      - python-psycopg2
      - supervisor
{%- for package in additional_deps %}
      - {{ package }}
{% endfor %}
  virtualenv.managed:
    - name: {{ project_home }}
    - requirements: {{ project_home }}/src/requirements.d/dev.txt
    - user: {{ project_name }}
    - no_chown: True
    - cwd: {{ project_home }}/src/requirements.d/
    - require:
      - git: kvmate
