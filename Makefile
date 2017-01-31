#!/usr/bin/make -f

# Copyright (c) 2016, Jan Wielemaker, Franco Masotti.
# See LICENSE file for details.

# This file is placed in /opt/rserve-sandbox-docker

USER=rserve
UHOME=/home/$(USER)
MOUNT=-v /home/$(USER):/home/rserve
DOCKERFILE=Dockerfile

all::
	@echo "Targets:"
	@echo
	@echo "  image      build the docker image"
	@echo "  remove     remove the docker image"
	@echo "  run        run the container one time"
	@echo "  stop       quit and remove the current docker container"

image:	Dockerfile
	docker build -t rserve .

Dockerfile: Dockerfile.in
	sed -e "s/@USERID@/$$(id -u $(USER))/g" \
	    -e "s/@GROUPID@/$$(id -g $(USER))/g" \
		Dockerfile.in > $(DOCKERFILE)

remove:
	docker rmi -f rserve

run:
	docker run --net=none --rm $(MOUNT) rserve

stop:
	docker stop $$(docker ps --format "{{.ID}}\t{{.Image}}" | grep rserve | awk '{print $$1}') 1>/dev/null 2>/dev/null

