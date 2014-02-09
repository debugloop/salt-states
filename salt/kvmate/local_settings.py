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

###############################################################
####    Get the rest from the local_settings.example.py     ###
###############################################################
from django.core.exceptions import ImproperlyConfigured
raise ImproperlyConfigured('do NOT use default settings, change the local_settings.py delivered by Salt')
