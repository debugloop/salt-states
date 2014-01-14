base:
  '*':
    - basic_packages
    - myuser
    - root_password
    - ntp

  'nightfort':
    - salt_master_conf

  'virtual:kvm':
    - match: grain
    - virsh_console
