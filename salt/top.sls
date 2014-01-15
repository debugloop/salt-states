base:
  '*':
    - basic_packages
    - root_password
    - myuser
    - ntp

  'nightfort':
    - salt_master_conf

  'virtual:kvm':
    - match: grain
    - virsh_console
