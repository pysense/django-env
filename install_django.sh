#!/bin/bash
set -e

django_version=$(python -c "import django; print(django.get_version())" 2> /dev/null)
if [[ -n $django_version ]]; then
    echo Django version: $django_version
    echo uWSGI version: $(uwsgi --version)
else
    pip install django
    python -c "import django; print(django.get_version())"
    pip install uwsgi
fi
