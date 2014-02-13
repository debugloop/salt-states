base:
  '*':
    - smtp_password
    - user_password
    - private_email
  '{{ grains['id'] }}':
    - {{ grains['id']|replace(".","") }}.root_password
  'hyper*':
    - kvmate_passwords
    - django
