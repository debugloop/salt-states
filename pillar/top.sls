base:
  '*':
    - smtp_password
    - user_password
    - private_email
  '{{ grains['id'] }}':
    - root_password.{{ grains['id']|replace(".","") }}
  'hyper*':
    - kvmate_passwords
    - django
