{% from 'django/init.sls' import project_name,project_home with context %}

{{ project_home }}/bin/gunicorn_start:
  file.managed:
    - source: salt://django/files/gunicorn_start
    - user: {{ project_name }}
    - group: {{ project_name }}
    - mode: 755
    - template: jinja
    - context:
      project_name: {{ project_name }}
      project_home: {{ project_home }}
    - require:
      - virtualenv: dependencies
      - user: {{ project_name }}
