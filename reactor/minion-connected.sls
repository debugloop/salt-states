run_highstate:
  cmd.state.highstate:
    - tgt: {{ data['id'] }}
