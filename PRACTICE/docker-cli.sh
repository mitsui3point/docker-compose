##  원칙상 db 와 app 을 병렬(&) 실행이 아닌 docker-compose depends_on 과 같이 수행완료 후 수행하도록 서비스 구성을 제어해야 함
##  sh 파일 실행 특성상 
##      db(mysql) process 하나가 쉘로 실행이 되면,
##      db(mysql) process 를 실행하고 있는 쉘이 종료되지 않을 경우,
##      app(wordpress) process 를 실행할 수 없으므로
##      app(wordpress) process 를 병렬로 실행했다.

./docker-cli-restore.sh &&

docker network create wordpress_net

docker \
    run \
    --name "db" \
    -v "$(pwd)/db_data:/var/lib/mysql" \
    -e "MYSQL_ROOT_PASSWORD=123456" \
    -e "MYSQL_DATABASE=wordpress" \
    -e "MYSQL_USER=wordpress_user" \
    -e "MYSQL_PASSWORD=123456" \
    --network wordpress_net \
mysql:5.7 \
& \

echo $(pwd) \
& \

docker \
    run \
    --name app \
    -v "$(pwd)/app_data:/var/www/html" \
    -e "WORDPRESS_DB_HOST=db" \
    -e "WORDPRESS_DB_USER=wordpress_user" \
    -e "WORDPRESS_DB_NAME=wordpress" \
    -e "WORDPRESS_DB_PASSWORD=123456" \
    -e "WORDPRESS_DEBUG=1" \
    -p 8080:80 \
    --network wordpress_net \
wordpress:latest
