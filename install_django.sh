#!/bin/bash
set -e

pip install -U pip

django_version=$(python -c "import django; print(django.get_version())" 2> /dev/null || true)
if [[ -n $django_version ]]; then
    echo Django version: $django_version
else
    pip install django
    python -c "import django; print(django.get_version())"
fi
