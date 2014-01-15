import salt.key
import salt.output

import subprocess
import os.path
import crypt

def _gen(minion_id):
    p = subprocess.Popen('pwgen -s 40 -N 1', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    pwclear = p.stdout.read().strip()
    pwhash = crypt.crypt(pwclear, "$6$%s" % os.urandom(8).encode('base_64').strip())
    with open("/srv/pillar/%s_root_password.sls" % minion_id, "w") as sls:
        sls.write('root_password: ' + pwhash)
    # TODO: encrypt and save to separate files
    with open("/home/danieln/pw.txt", "a") as sls:
        sls.write('%s: %s\n' % (minion_id, pwclear))

def gen(minion_id):
    '''
    Generates a file within this masters pillar tree, named
    minionid_root_password.sls, containing a pillar entry root_password with a
    random password hash.

    CLI Example:

    .. code-block:: bash

        salt-run root_password.gen minionid
    '''
    if not os.path.isfile("/srv/pillar/%s_root_password.sls" % minion_id):
        _gen(minion_id)
        salt.output.display_output('Done.', '', __opts__)
        return True
    else:
        salt.output.display_output('This minion already has a password from this module.', '', __opts__)
        return False

def regen(minion_id):
    '''
    Same as gen, but overrites an existing file.

    CLI Example:

    .. code-block:: bash

        salt-run root_password.regen minionid
    '''
    _gen(minion_id)
    salt.output.display_output('Done.', '', __opts__)
    return True

def regen_all():
    '''
    Refreshes root passwords on all minions.

    CLI Example:

    .. code-block:: bash

        salt-run root_password.regen_all
    '''
    opts = salt.config.master_config('/etc/salt/master')
    keys = salt.key.Key(opts)
    minions = keys.list_keys().get('minions')
    for m in minions:
        _gen(minion_id)
    salt.output.display_output('Root password regeneration complete.', '', __opts__)
    return True
