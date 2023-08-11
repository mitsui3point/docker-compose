[이고잉님 강의 주소](https://www.youtube.com/watch?v=EK6iYRCIjYs&t=2s)  
[이고잉님 실행스크립트 원본 링크](https://gist.github.com/egoing/b62aa16573dd5c7c5da51fd429a5faa2)

# command 실행

```bash
docker network create wordpress_net       # docker-compose.yml 자동 생성
```

```bash
docker \
run \
    --name "db" \                         # services:db:
    -v "$(pwd)/db_data:/var/lib/mysql" \  # services:db:volumes:
    -e "MYSQL_ROOT_PASSWORD=123456" \     # services:db:environment:
    -e "MYSQL_DATABASE=wordpress" \       # services:db:environment:
    -e "MYSQL_USER=wordpress_user" \      # services:db:environment:
    -e "MYSQL_PASSWORD=123456" \          # services:db:environment:
    --network wordpress_net \             # host 내 component 들이 접속할 수 있는 네트워크 연결; docker-compose.yml 자동생성
mysql:5.7                                 # services:db:image:
```

```bash
docker \
    run \
    --name app \                              # services:app:
    -v "$(pwd)/app_data:/var/www/html" \      # services:app:volumes:
    -e "WORDPRESS_DB_HOST=db" \               # services:app:environment:
    -e "WORDPRESS_DB_USER=wordpress_user" \   # services:app:environment:
    -e "WORDPRESS_DB_NAME=wordpress" \        # services:app:environment:
    -e "WORDPRESS_DB_PASSWORD=123456" \       # services:app:environment:
    -e "WORDPRESS_DEBUG=1" \                  # services:app:environment:
    -p 8080:80 \                              # services:app:ports:
    --network wordpress_net \                 # host 내 component 들이 접속할 수 있는 네트워크 연결; docker-compose.yml 자동생성
wordpress:latest                              # services:app:
```

# docker-compose.yml 실행
```bash
$ docker-compose up # docker-compose file 실행 -> 내부 network, services container 등록 및 네트워크 등록
$ docker-compose dowmn # docker-compose 실행중인 container network 제거
```

```yml
version: "3.7"

services:
  db:
    image: mysql:5.7
    volumes:
      - ./db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress_user
      MYSQL_PASSWORD: 123456
  
  app:
    depends_on: 
      - db
    image: wordpress:latest
    volumes:
      - ./app_data:/var/www/html
    ports:
      - "8080:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress_user
      WORDPRESS_DB_PASSWORD: 123456 
```
