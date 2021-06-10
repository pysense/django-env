#/bin/bash
set -e

# 如何用 uWSGI 托管 Django
# https://docs.djangoproject.com/zh-hans/3.2/howto/deployment/wsgi/uwsgi/
# Setting up Django and your web server with uWSGI and nginx
# https://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html

nginx_version=$(rpm -qi nginx | grep -i version | awk -F": " '{print$2}')
if [[ -n $nginx_version ]]; then
    echo Nginx version: $nginx_version
else
    yum install -y nginx
fi

pip install -U pip

if command -v uwsgi > /dev/null; then
    echo uWSGI version: $(uwsgi --version)
else
    pip install uwsgi
fi
