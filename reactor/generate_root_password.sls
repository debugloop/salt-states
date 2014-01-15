{% if data['act'] == 'accept' and data['result'] == True %}
generate_root_password:
  runner.root_password.gen:
    - minion_id: {{ data['id'] }}
{% endif %}
