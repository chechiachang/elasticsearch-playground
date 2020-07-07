SHELL:=/bin/bash
UNAME_S := $(shell uname -s)

docker-compose:
	docker-compose up -d
