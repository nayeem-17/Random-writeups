# What is Docker

Docker lets you package and run any application in an isolated environment called a container. So, you make a Docker image of your dev enviourment , push the image on [DockerHub](https://hub.docker.com/). Then, on the production enviourment , you just pull the dockerfile from DockerHub and run the file. You can deploy your application from dev enviourmnet to production enviourment this easily.

# Installing Docker engine on your machine

## Installing on your Linux machine

First update your apt package index
```bash
sudo apt-get update
```
The install the latest version of Docker engine     

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```
Now, check if everything's working fine 
```bash
sudo docker run hello-world
```
You can see this output

![output of docker run hello-world](docker-hello-world.png)

# Docker image and container 

Docker image and docker container are not the same. What we pull or push from DockerHub is image. Image can exist without any container. But when you run any docker image with/without some configuration, it becomes a docker container. You can create multiple docker containers with the same docker image with different configurations. Those containers will share the docker image. When you delete a container, it will delete just the configuration, not the docker image. If you want to delete a docker image you have to delete that docker image separately.

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
sudo docker run --detach dockerimage #either this command
sudo docker run -d dockerimage #or this command
```
Here, dokcerimage is the name of the docker image.If docker can not find this image on your local machine, it will pull the docker image from DockerHub. You can also pull an image from DockerHub.
```bash
sudo docker pull dockerimage
```
This command will download the docker image from DockerHub for you. 

Now, to delete a docker container , run this command
```bash
sudo docker container rm CONTAINER_NAME #either this command
sudo docker container rm CONTAINER_ID # or this command
```
# Useful links

* [The Docker Handbook](https://docker.farhan.info/) & [project links](https://github.com/fhsinchy/docker-handbook-projects) for this book.
* [Docker tutorial](https://youtu.be/3c-iBn73dDE)