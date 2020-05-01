#!/bin/bash
set -ex

python manage.py collectstatic --no-input --clear

exec "$@"