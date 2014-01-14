{% if data['act'] == 'accept' and data['result'] == True %}
gen_root_password:
  runner.root_password.gen:
    - minion_id: {{ data['id'] }}
{% endif %}
