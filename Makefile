NAME = app

up:
	docker-compose up

up-d:
	docker-compose up -d

up-build:
	docker-compose up --build

build:
	docker-compose build

start:
	docker-compose start

stop:
	docker-compose stop

restart:
	docker-compose down
	docker-compose up -d

down:
	docker-compose down

destroy:
	docker-compose down --rmi all --volumes

ps:
	docker ps

ps-a:
	docker ps -a

login:
	docker exec -it $(NAME) sh

attach:
	docker attach $(NAME)

rm-v:
	docker volume prune

rm-i:
	docker image prune