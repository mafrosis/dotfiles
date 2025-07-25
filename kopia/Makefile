.PHONY: build
build:
	docker build \
		-t mafrosis/kopia \
		--build-arg HOSTNAME=$$(hostname) \
		--secret id=KOPIA_PASSWORD,env=KOPIA_PASSWORD .
