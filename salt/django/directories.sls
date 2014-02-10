{% from 'django/init.sls' import project_name,project_home with context %}

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
