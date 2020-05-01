"""
This module provides some utility classes and functions
for project settings.
"""
import os
from enum import Enum

import requests


class Environment(Enum):
    """Enum class defining possible environments"""
    DEVELOPMENT = 'development'
    TESTING = 'test'
    PRODUCTION = 'production'

def env(key, default=None) -> str:
    """Alias for os.environ.get()"""
    return os.environ.get(key, default)

def get_allowed_hosts() -> list:
    """
    Gets allowed hosts from environment and tries
    to get the ip address of the current ec2 instance.
    """
    hosts = env('DJANGO_ALLOWED_HOSTS', '').split(' ')
    try:
        instance_ip = requests.get(
            'http://169.254.169.254/latest/meta-data/local-ipv4',
            timeout=0.01
        ).text
    except requests.exceptions.RequestException:
        instance_ip = []
    if hosts and instance_ip:
        hosts = hosts.append(instance_ip)
    else:
        hosts = hosts or instance_ip
    return hosts
