sudo:
  pkg:
    - installed

danieln:
  user.present:
    - fullname: Daniel Naegele
    - home: /home/danieln
    - shell: /bin/bash
    - password: {{ pillar['user_password'] }}
    - enforce_password: False
    - create_home: True
    - remove_groups: False
    - groups:
      - sudo
    - require:
      - pkg: sudo

dotfiles:
  git.latest:
    - name: https://github.com/danieljn/dotfiles.git
    - user: danieln
    - rev: master
    - target: /home/danieln/dotfiles
    - require:
      - user: danieln
  cmd.wait:
    - name: ./init.sh
    - user: danieln
    - cwd: /home/danieln/dotfiles
    - watch:
      - git: dotfiles
    - require:
      - user: danieln
