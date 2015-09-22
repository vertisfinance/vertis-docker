set -e

echo "vertisfinance-base"
docker build -t vertisfinance/base vertisfinance-base

echo "vertisfinance-postgres"
echo "--------------------"
docker build -t vertisfinance/postgres vertisfinance-postgres

echo "vertisfinance-nginx"
echo "--------------------"
docker build -t vertisfinance/nginx vertisfinance-nginx

echo "vertisfinance-django-python2"
echo "--------------------"
docker build -t vertisfinance/django-python2 vertisfinance-django-python2

echo "vertisfinance-django-python3"
echo "--------------------"
docker build -t vertisfinance/django-python3 vertisfinance-django-python3

echo "vertisfinance-ssh"
echo "--------------------"
docker build -t vertisfinance/ssh vertisfinance-ssh

echo "vertisfinance-bbg-python2"
echo "--------------------"
docker build -t vertisfinance/bbg-python2 vertisfinance-bbg-python2

echo "vertisfinance-bbg-python3"
echo "--------------------"
docker build -t vertisfinance/bbg-python3 vertisfinance-bbg-python3

echo "vertisfinance-nodejs"
echo "--------------------"
docker build -t vertisfinance/nodejs vertisfinance-nodejs
