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

###############################################################
###############################################################
from django.core.exceptions import ImproperlyConfigured
raise ImproperlyConfigured('you propaply do NOT want to use these default settings, change the local_settings.py delivered by Salt')
