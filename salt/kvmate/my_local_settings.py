SECRET_KEY = '{{ pillar['secret_key'] }}'

# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ project_name }}',
        'USER': '{{ project_name }}',
        'PASSWORD': '{{ pillar['postgres_password'] }}',
        'HOST': 'localhost'
    }
}

#################
### KVMate specific settings
#################

# Create Host defaults
CREATE_HOST_DEFAULT_IP = '172.16.0.'
CREATE_HOST_DEFAULT_NETMASK = '255.255.255.0'
CREATE_HOST_DEFAULT_GATEWAY = '172.16.0.1'
CREATE_HOST_DEFAULT_DNS = '172.16.0.1'
CREATE_HOST_DEFAULT_DOMAIN = '.danieljn.de'
CREATE_HOST_DEFAULT_SETUP_SCRIPT = 'http://172.16.0.10:9000/post_install.sh'

### Settings for the virtinstall command:
# The name of the bridge on the hypervisor the new host should use
BRIDGE_NAME = "br0"
# The type of the bridge, set it to 'bridge' for linux and to 'network' for openvswitch
BRIDGE_TYPE = "bridge"
# The name of the libvirt volume-pool that should be used
STORAGEPOOL_NAME = "virtimages"
# The amount of memory a new host should reserve
DISKSIZE = "5"
# the final ip/dns name of your instance used for the preseed downloads
PRESEED_HOST = "172.16.0.10"
# Where the preseedfiles will be stored and downloaded (serve this directory statically for your virtual machines)
PRESEEDPATH = "/home/danieln/kvmate/kvmate/host/static/host/"
# A url where the latest netinstaller is available
NETINSTALL_URL = "http://ftp.de.debian.org/debian/dists/wheezy/main/installer-amd64/"
# the port where the preseedfiles can be downloaded
# !!! IMPORTANT: this port may not redirect to https, as the debian installer's wget does not support ssl !!!
PRESEED_PORT = "8000"

### Settings for the preseeding process:
DEFAULT_MIRROR = "mirror.selfnet.de"
DEFAULT_TIMEZONE = "Europe/Berlin"
DEFAULT_NTPSERVER = "ntp.belwue.de"
INITIAL_PASSWORD = "geheim42"

VNC_HOST = 'dn.user.selfnet.de'
