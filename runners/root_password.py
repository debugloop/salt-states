import salt.key
import salt.output

# util
import os

# password generation
import subprocess
import crypt

# encryption
import StringIO
import gnupg

client = salt.client.LocalClient()
gpg = gnupg.GPG()
workpath='/root/password-store/server/' # must be inside a salt fileroot
passpath='/root/.password-store'
passhost = 'nightfort'

def _log(msg):
    report.append('%s' % msg)
    salt.output.display_output('%s' % msg, '', __opts__)

def _generate_passwords(minion_id):
    p = subprocess.Popen('pwgen -s 10 -N 1', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    pwclear = p.stdout.read().strip()
    pwhash = crypt.crypt(pwclear, "$6$%s" % os.urandom(8).encode('base_64').strip())
    return pwclear, pwhash

# methods manipulating the host
def _backup_password(minion_id):
    _log('%s: Creating a backup of the old password.' % minion_id)
    cmd = client.cmd(minion_id, 'shadow.info', ['root'])
    return cmd.get(minion_id).get('passwd') if cmd else False

def _set_password(minion_id, pwhash):
    _log('%s: Setting the password.' % minion_id)
    cmd = client.cmd(minion_id, 'shadow.set_password', ['root', pwhash])
    return cmd.get(minion_id) if cmd else False

# methods manipulating the pass host
def _create_duplicate(minion_id):
    _log('%s: Creating a backup of the gpg file on the pass host' % minion_id)
    cmd = client.cmd(passhost, 'file.copy', [passpath + minion_id + '.gpg', passpath + subdir + minion_id + '.bak.gpg'])
    return cmd.get(passhost) if cmd else False

def _restore_from_duplicate(minion_id):
    _log('%s: Restoring the old gpg file on the pass host' % minion_id)
    cmd = client.cmd(passhost, 'file.rename', [passpath + minion_id + '.bak.gpg', passpath + subdir + minion_id + '.gpg'])
    return cmd.get(passhost) if cmd else False

def _remove_duplicate(minion_id):
    _log('%s: Removing the backup gpg file from the pass host' % minion_id)
    cmd = client.cmd(passhost, 'file.remove', [passpath + minion_id + '.bak.gpg'])
    return cmd.get(passhost) if cmd else False

def _encrypt_password(minion_id, password):
    _log('%s: Encrypting the new password.' % minion_id)
    keys = [key.get('fingerprint') for key in gpg.list_keys()]
    enc = gpg.encrypt_file(StringIO.StringIO(password + '\n'), keys, always_trust=True, armor=False, output=workpath + minion_id)
    return enc.ok

def _send_password(minion_id):
    _log('%s: Sending the encrypted password to the pass host' % minion_id)
    cmd = client.cmd(passhost, 'cp.get_file', ['salt://server/%s' % minion_id, passpath + minion_id + '.gpg'], kwarg={'saltenv': 'pass'})
    return cmd.get(passhost) == passpath + subdir + minion_id + '.gpg' if cmd else False

def regen(minion_id):
    '''
    Refreshes the root password on a minion.

    CLI Example:

    .. code-block:: bash

        salt-run root_password.regen minion_id
    '''
    # generate password and hash
    pwclear, pwhash = _generate_passwords(minion_id)

    # check for errors which require no cleanup
    if not _create_duplicate(minion_id):
        _log('%s: Creating a backup of the password store failed, abort!' % minion_id)
        return 1

    # check for errors and clean up
    if not _encrypt_password(minion_id, pwclear):
        _log('%s: Encrypting the password failed!' % minion_id)
        _remove_duplicate(minion_id)
        return 1
    if not _send_password(minion_id):
        _log('%s: Sending the new password to the pass host failed!' % minion_id)
        _remove_duplicate(minion_id)
        _log('%s: Removing the encrypted password from the salt master.' % minion_id)
        os.remove(workpath + minion_id)
        return 1
    _log('%s: Removing the encrypted password from the salt master.' % minion_id)
    os.remove(workpath + minion_id)
    # if it cant be set, revert to backup
    if not _set_password(minion_id, pwhash):
        if _restore_from_duplicate(minion_id):
            _log('%s: Reverted all changes.' % minion_id)
            return 1
        else:
            _log('%s: Unable to reverted all changes.' % minion_id)
            return -1
    else:
        _remove_duplicate(minion_id)
    _log('%s: Done.\n' % minion_id)
    return 0

def regen_all(test=False):
    '''
    Refreshes root passwords on all minions.

    CLI Example:

    .. code-block:: bash

        salt-run root_password.regen_all
    '''
    opts = salt.config.master_config('/etc/salt/master')
    keys = salt.key.Key(opts)
    success = 0
    critical = []
    minions = keys.list_keys().get('minions')
    if test:
        minions = ['nightfort']
    for minion_id in minions:
        ret = regen(minion_id)
        if ret == 0:
            success += 1
        elif ret == -1:
            critical.append(minion_id)
    _log('Root password regeneration for %d of %d minions complete.' % (success, len(minions)))
    if len(critical) > 0:
        _log('There were critical errors, this means the gpg encrypted password does not match the password currently inplace on the host.')
        _log('The passwords do not match on:')
        for host in critical:
            _log('  - %s' % host)
