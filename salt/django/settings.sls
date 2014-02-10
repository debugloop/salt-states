{% from 'django/init.sls' import project_name,project_home with context %}

{{ project_home }}/src/{{ project_name }}/{{ project_name }}/settings/local_settings.py:
  file.managed:
    - source: salt://django/files/local_settings.py
    - user: {{ project_name }}
    - group: {{ project_name }}
    - template: jinja
    - context:
      project_name: {{ project_name }}
      secret_key: {{ pillar[project_name ~ '_secret_key'] }}
      postgres_password: {{ pillar[project_name ~ '_postgres_password'] }}
