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
	@echo "  image      Build the docker image"
	@echo "  run        Run the image one time"
	@echo "  stop       Quit and remove the current docker container."

image:	Dockerfile
	docker build -t rserve .

Dockerfile: Dockerfile.in
	sed -e "s/@USERID@/$$(id -u $(USER))/g" \
	    -e "s/@GROUPID@/$$(id -g $(USER))/g" \
		Dockerfile.in > $(DOCKERFILE)

run:
	docker run --net=none --rm $(MOUNT) rserve

stop:
	docker stop $$(docker ps --format "{{.ID}}\t{{.Image}}" | grep rserve | awk '{print $$1}') 1>/dev/null 2>/dev/null
