DEBUG = False
SECRET_KEY = '{{ secret_key }}'

# Celery config
BROKER_URL = 'amqp://{{ user }}:{{ rabbitmq_password }}@localhost:5672/{{ rabbitmq_vhost }}'
CELERY_DEFAULT_QUEUE = '{{ user }}'
CELERY_DEFAULT_EXCHANGE = '{{ user }}'
CELERY_DEFAULT_EXCHANGE_TYPE = 'direct'
CELERY_DEFAULT_ROUTING_KEY = '{{ user }}'
