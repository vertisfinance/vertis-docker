#! /bin/bash

set -e

docker push vertisfinance/base
docker push vertisfinance/postgres
docker push vertisfinance/nginx
docker push vertisfinance/django-python2
docker push vertisfinance/django-python3
docker push vertisfinance/django
docker push vertisfinance/ssh
