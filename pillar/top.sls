{% set self = grains['id'] %}
base:
  '*':
    - smtp_password
  '{{ self }}':
    - {{ self }}_root_password
