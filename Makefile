all: build

PROJECT=jiliti-opnprjct
CONTAINER_NAME=open_project_ctn
IMAGE_NAME=open_project_img
DOCKER_USER=docker
REMOTE_ROOT=-w '/root'

start:
	service docker start

listctn: 
	docker container ls --all

listimg:
	docker image ls

rembash:
	docker exec -ti $(CONTAINER_NAME) bash

getip:
	docker inspect $(CONTAINER_NAME) | grep "IPAddress"

restartapache:
	docker exec  $(REMOTE_ROOT) $(CONTAINER_NAME) service apache2 restart

startapache:
	docker exec   $(REMOTE_ROOT) $(CONTAINER_NAME) service apache2 start

stopall:
	docker stop $$(docker ps -q -a)

##cleaning
dri:
	docker rmi $$(docker images -q)

drmf: 
	docker rm -f $$(docker ps -q -a)

#clnall: stopall drmf dri prune

clnright:
	docker exec  $(REMOTE_ROOT) $(CONTAINER_NAME) bash -c '/root/install/clnright.sh'

prune:
	docker image prune -a

#param make erase CONTAINER_NAME="mon_container" lancé par make erase CONTAINER_NAME="pro"
erase: stopall
	docker container rm $(CONTAINER_NAME) && docker image rm $$(docker images '*$(CONTAINER_NAME)*')

save:
# docker commit $(CONTAINER_NAME) [new_image_name]
	docker commit $(CONTAINER_NAME) 
#
# launch

exportcontainer:
	docker export $(CONTAINER_NAME) > $(CONTAINER_NAME).tar


build:
	docker-compose build

up:
	docker-compose up

setpsswd:
	docker exec  $(REMOTE_ROOT)  $(CONTAINER_NAME) passwd docker

buildraw:
	docker build -t $(CONTAINER_NAME) ./docker/build

browser: 
	python3 browser.py
  

.FORCE:
