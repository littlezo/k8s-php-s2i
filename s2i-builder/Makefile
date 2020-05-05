IMAGE_NAME = soinx/php-73-centos7

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-test .
	IMAGE_NAME=$(IMAGE_NAME)-test test/run
