base:
  '*':
    - basic_packages
    - salt_minion_conf
    - myuser
    - ntp

  'nightfort':
    - salt_master_conf

  'virtual:kvm':
    - match: grain
    - virsh_console
