rm -rf app_data
rm -rf db_data

docker rm -f db
docker rm -f app
docker network rm -f wordpress_net