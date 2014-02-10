{% from 'django/init.sls' import project_name with context %}

postgresql:
  postgres_database.present:
    - name: {{ project_name }}
    - owner: {{ project_name }}
    - user: postgres
    - require:
      - postgres_user: postgresql
  postgres_user.present:
    - name: {{ project_name }}
    - password: {{ pillar[project_name ~ '_postgres_password'] }}
    - user: postgres
