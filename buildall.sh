#! /bin/bash

set -e

dir="$(dirname "$BASH_SOURCE")"

echo "vertisfinance/base"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-base"

echo "vertisfinance/postgres"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-postgres"

echo "vertisfinance/nginx"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-nginx"

echo "vertisfinance/django-python2"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-django-python2"

echo "vertisfinance/django-python3"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-django-python3"

echo "vertisfinance/django"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-django"

echo "vertisfinance/ssh"
echo "--------------------"
docker build -t vertis/core "$dir/vertisfinance-ssh"
