#! /bin/bash

set -e

dir="$(dirname "$BASH_SOURCE")"

echo "vertisfinance/base"
echo "--------------------"
docker build -t vertisfinance/base "$dir/vertisfinance-base"

echo "vertisfinance/postgres"
echo "--------------------"
docker build -t vertisfinance/postgres "$dir/vertisfinance-postgres"

# echo "vertisfinance/nginx"
# echo "--------------------"
# docker build -t vertisfinance/nginx "$dir/vertisfinance-nginx"

# echo "vertisfinance/django-python2"
# echo "--------------------"
# docker build -t vertisfinance/django-python2 "$dir/vertisfinance-django-python2"

# echo "vertisfinance/django-python3"
# echo "--------------------"
# docker build -t vertisfinance/django-python3 "$dir/vertisfinance-django-python3"

# echo "vertisfinance/django"
# echo "--------------------"
# docker build -t vertisfinance/django "$dir/vertisfinance-django"

# echo "vertisfinance/ssh"
# echo "--------------------"
# docker build -t vertisfinance/ssh "$dir/vertisfinance-ssh"
