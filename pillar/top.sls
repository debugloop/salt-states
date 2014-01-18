{% set self = grains['id'] %}
base:
  '*':
    - smtp_password
    - private_email
  '{{ self }}':
    - {{ self }}_root_password
