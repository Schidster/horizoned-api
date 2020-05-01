import multiprocessing

from config.utils import env

defaults = {
    'workers': int(multiprocessing.cpu_count() * 2 + 1),
    'threads': int(multiprocessing.cpu_count())
}

bind = '0.0.0.0:8000'
workers = int(env('GUNICORN_WORKERS', defaults['workers']))
threads = int(env('GUNICORN_THREADS', defaults['threads']))

# TODO: SHould do.
# accesslog = 'logs/access'
# errorlog = 'logs/error'