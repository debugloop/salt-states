SECRET_KEY = '{{ secret_key }}'

# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ project_name }}',
        'USER': '{{ project_name }}',
        'PASSWORD': '{{ postgres_password }}',
        'HOST': 'localhost'
    }
}

STATIC_ROOT = '{{ project_home }}/static/'

# the final ip/dns name of your instance used for the preseed downloads
PRESEED_HOST = "192.168.0.1"

# initial password set in new VMs
INITIAL_PASSWORD = "geheim42"

# Where should the in-browser VNC client connect to (probably your server's IP)
VNC_HOST = '62.210.141.243'

# defaults on host create page
CREATE_HOST_DEFAULT_DOMAIN = 'as-webservices.de'
CREATE_HOST_DEFAULT_SETUP_SCRIPT = 'http://192.168.0.1/post_install.sh'

DEFAULT_MIRROR = "ftp.fr.debian.org"
