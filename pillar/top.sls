{% set self = grains['id'] %}
base:
  '{{ self }}':
    - {{ self }}_root_password
