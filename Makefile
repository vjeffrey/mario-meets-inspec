start-vagrant-ubuntu:
		cd playground/vagrant-ubuntu && vagrant up

start-vagrant-windows:
		cd playground/vagrant-windows && vagrant up

start-docker-ssh:
		cd playground/docker-ssh && docker build -t ssh-node . && docker create ssh-node

start-docker-mario:
		cd playground/docker-mario && docker build -t mariomeetsinspec . && docker create mariomeetsinspec
