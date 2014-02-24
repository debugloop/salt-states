{% from 'django/init.sls' import project_name,project_home,components with context %}

{% for component in components %}
supervisor_{{ project_name }}_{{ component }}:
  supervisord.running:
    - name: {{ project_name }}_{{ component }}
    - watch:
      - file: /etc/supervisor/conf.d/{{ project_name }}_{{ component }}.conf
    - require:
      - pkg: dependencies
  file.managed:
    - name: /etc/supervisor/conf.d/{{ project_name }}_{{ component }}.conf
    - source: salt://django/files/supervisor_{{ project_name }}_{{ component }}.conf
    - template: jinja
    - context:
      project_name: {{ project_name }}
      project_home: {{ project_home }}
{% endfor %}
