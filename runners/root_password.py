import salt.key
import salt.output

import subprocess
import os.path
import crypt

opts = salt.config.master_config('/etc/salt/master')
keys = salt.key.Key(opts)
minions = keys.list_keys().get('minions')

def gen(minion_id):
    '''
    Generates a file

    CLI Example:

    .. code-block:: bash

        salt-run root_password.gen minionid
    '''
    p = subprocess.Popen('pwgen -s 40 -N 1', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    pwclear = p.stdout.read().strip()
    pwhash = crypt.crypt(pwclear, "$6$%s" % os.urandom(8).encode('base_64').strip())
    if not os.path.isfile("/srv/pillar/%s_root_password.sls" % minion_id):
        with open("/srv/pillar/%s_root_password.sls" % minion_id, "w") as sls:
            sls.write('root_password: ' + pwhash)
        # TODO: encrypt and save to separate files
        with open("/home/danieln/pw.txt", "a") as sls:
            sls.write('%s: %s\n' % (minion_id, pwclear))
        salt.output.display_output('Done.', '', __opts__)
        return True
    else:
        salt.output.display_output('This minion already has a password from this module.', '', __opts__)
        return False
