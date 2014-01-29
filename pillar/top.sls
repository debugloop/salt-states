base:
  '*':
    - smtp_password
    - private_email
  '{{ grains['id'] }}':
    - {{ grains['id']|replace(".","") }}.root_password
