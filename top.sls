base:
  '*':
    - basic_packages
    - ntp

  'nightfort':
    - salt_master_conf

  'virtual:kvm':
    - match: grain
    - virsh_console
