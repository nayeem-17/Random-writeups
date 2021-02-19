# What is Docker

Docker lets you package and run any application in an isolated environment called a container. So, you make a Docker image of your dev environment, push the image on [DockerHub](https://hub.docker.com/). Then, on the production environment, you just pull the dockerfile from DockerHub and run the file. You can deploy your application from the dev environment to the production environment this easily.

# Installing Docker engine on your machine

## Installing on your Linux machine

First, update your apt package index
```bash
sudo apt-get update
```
Then, install the latest version of Docker engine     

```bash
sudo apt-get install docker.io -y
```
Now, check if everything's working fine 
```bash
sudo docker run hello-world
```
You can see this output

![output of docker run hello-world](docker-hello-world.png)

# Docker image and container 

Docker image and docker container are not the same. What we pull or push from DockerHub is an image. An image can exist without any container. But when you run any docker image with/without some configuration, it becomes a docker container. You can create multiple docker containers with the same docker image with different configurations. Those containers will share the docker image. When you delete a container, it will delete just the configuration, not the docker image. If you want to delete a docker image you have to delete that docker image separately.

You can see the docker images stored on your machine by running this command.
```bash
sudo docker images #either this command
sudo docker image ls #or this command
```
You can see the running docker containers by running this command
```bash
# either these commands
sudo docker ps #to show just current running containers
sudo docker ps -a # to show all running and stopped containers
# or these commands
sudo docker container ls #to show just current running containers
sudo docker container ls -a # to show all running and stopped containers
```
You can see that every container has its unique container id and container name. By default the id and name are auto-generated. But you can set the name of the container while starting a new container using the `--name` tag.
```bash
# start a container from hello-world image with a name
sudo docker run --name my-docker hello-world
# now check the names of your container from the output of this command
sudo docker ps -a
```
Now, you can see that the name of the last container is **my-docker**

You can run your container in a detached mood using `--detach` tag or `-d` tag
```bash
sudo docker run --detach DOCKER_IMAGE_NAME #either this command
sudo docker run -d DOCKER_IMAGE_NAME #or this command
```
If docker can not find this image on your local machine, it will pull the docker image from DockerHub. You can also pull an image from DockerHub.
```bash
sudo docker pull DOCKER_IMAGE_NAME
```
This command will download the docker image from DockerHub for you. 

You can stop a container.
```bash
sudo docker container stop CONTAINER_NAME
```

Now, to delete a docker container, run this command
```bash
sudo docker container rm CONTAINER_NAME #either this command
sudo docker container rm CONTAINER_ID # or this command
sudo docker rm CONTAINER_ID #or this command
sudo docker rm CONTAINER_NAME #or this command
```
You can not delete a docker image if there's a container of that image. To delete that image, first, you have to delete the docker container, then you can delete that docker image.
```bash
sudo docker rmi IMAGE_NAME #either this command
sudo docker image rm IMAGE_NAME #or this command
```
You can delte all stopped container by running one command
```bash
sudo docker container prune
```
# Creating Container

You can create a container by running a docker image.
```bash
sudo docker run IMAGE_NAME
```
You can also create a container without running an image.
```bash
sudo docker container create IMAGE_NAME
```
To start an existing container.
```bash
sudo docker container start CONTAINER_NAME
```
## Publishing ports

Containers are isolated environments. Your host machine does not know what is going on inside a container. You can publish appropriate ports to communicate between the container and host os/outside. The syntax of publishing a port is 
```bash
--publish HOST_PORT:CONTAINER_PORT
# or
-p HOST_PORT:CONTAINER_PORT
```
For example, if you want to create a container from mongodb image, you have to publish a port in order to access mongo from host machine. The default port of mongodb container is 27017. If you want to access mongo at port 3000 from your machine.
```bash
sudo docker run -p 3000:27017 --name mongo_container mongo
```
Now, you can access mongodb at port 3000 & the name of the container is **mongo_container**

# Useful links
* [Docker Docs](https://docs.docker.com/)
* [The Docker Handbook](https://docker.farhan.info/) & [project links](https://github.com/fhsinchy/docker-handbook-projects) for this book.
* [Docker tutorial](https://youtu.be/3c-iBn73dDE)