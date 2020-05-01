#!/usr/bin/env python3
"""Provides project setup functionality adhering to python standards."""

from setuptools import setup, find_packages

project: dict = {
    'name': 'HorizonedsApi',
    'version': '0.1dev',
    'description': 'A restful api to serve data.',
    'long_description': open('README.md').read(),
    'author': 'Schidster Adinson',
    'author_email': 'schid2003@gmail.com',
    'packages': find_packages(),
    'scripts': ['manage.py'],
    'license': open('LICENSE').read()
}

setup(**project)
