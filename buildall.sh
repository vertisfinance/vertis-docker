#! /bin/bash

set -e

dir="$(dirname "$BASH_SOURCE")"

echo "vertisfinance/base"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-base"

echo "vertisfinance/postgres"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-postgres"

echo "vertisfinance/nginx"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-nginx"

echo "vertisfinance/django-python2"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-django-python2"

echo "vertisfinance/django-python3"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-django-python3"

echo "vertisfinance/django"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-django"

echo "vertisfinance/ssh"
echo "--------------------"
docker build -t vertisfinance/core "$dir/vertisfinance-ssh"

echo "vertisfinance-bbg-python2"
echo "--------------------"
docker build -t vertisfinance/bbg-python2 "$dir/vertisfinance-bbg-python2"

echo "vertisfinance-bbg-python3"
echo "--------------------"
docker build -t vertisfinance/bbg-python3 "$dir/vertisfinance-bbg-python3"

echo "vertisfinance-bbg-python3"
echo "--------------------"
docker build -t vertisfinance/nodejs "$dir/vertisfinance-nodejs"
