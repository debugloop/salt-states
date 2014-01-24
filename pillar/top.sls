base:
  '*':
    - smtp_password
    - private_email
  '{{ grains['id'] }}':
    - {{ grains['host'] }}.root_password
