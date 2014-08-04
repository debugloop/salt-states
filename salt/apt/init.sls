/etc/apt/apt.conf.d/99user:
  file.managed:
    - contents: APT::Install-Recommends false;
