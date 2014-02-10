{% from 'django/init.sls' import project_name,project_home,server_name with context %}

tls.create_self_signed_cert:
  module.wait:
    - CN: {{ server_name }}
    - watch:
      - pkg: nginx {# workaround: trigger on nginx package #}
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
    - source: salt://django/files/nginx.conf
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
