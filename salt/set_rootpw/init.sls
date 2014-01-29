{% if pillar['root_password'] %}
set_root_pass:
  module.run:
    - name: shadow.set_password
    - m_name: root
    - password: {{ pillar['root_password'] }}
{% endif %}
