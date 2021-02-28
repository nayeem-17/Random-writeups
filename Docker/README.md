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

You can run your container in a detached mode using `--detach` tag or `-d` tag
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
You can delete all stopped container by running one command
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
For example, if you want to create a container from mongodb image, you have to publish a port in order to access mongodb from host machine. The default port of mongodb container is 27017. If you want to access mongo at port 3000 from your machine.
```bash
sudo docker run -p 3000:27017 --name mongo_container mongo
```
Now, you can access mongodb at port 3000 & the name of the container is **mongo_container**
## Volume Binding
Here's a scenario, you've started a database container. You stored some data. Now you restarted the container, you can not find any data because the database is empty. Because a docker container does not have its own storage. You can solve this problem by binding volume to your docker container. You can mount a file or directory of your host machine into a container. The path of the file or directory does not need to exist on your host machine already. To bind volume to your docker container, you have to use `-v` / `--volume` tag.
```bash
-v PATH_IN_HOST:PATH_IN_CONTAINER
# or
--volume PATH_IN_HOST:PATH_IN_CONTAINER
```
Here, both paths are absolute paths. So, after binding a directory of your host machine to a directory of a container, whatever you stored in that directory of the container, will be stored in that directory of your host machine. So, you'll find your data after restarting your container.
Here's a example of publishing ports,binding volume together
```bash
sudo docker run -p 3000:27017 -v ~/mongo/data:/data/db --name mongo_container mongo

```
Here, `~/mongo/data` of host machine is linked in `/data/db` directory in **mongo_container**

## Creating Network
When you are using multiple docker containers and they need to connect to each other, here comes the problem. Because we know that docker containers are isolated environments. Normally a docker container does not allow any connection from outside. To establish a connection between multiple docker containers, you have a create a docker network and connect each container so that they can talk to each other.     
To create a docker network
```bash
sudo docker network create NETWORK_NAME
```
To connect with a network while creating a container, use `--network` flag
```
sudo docker run --network NETWORK_NAME IMAGE_NAME
```
To connect a container with a docker network,
```bash
sudo docker network connect NETWORK_NAME CONTAINER_NAME
# or
sudo docker network connect NETWORK_NAME CONTAINER_ID
```
To detach a container from a network
```bash
sudo docker network disconnect NETWORK_NAME CONTAINER_NAME
sudo docker network disconnect NETWORK_NAME CONTAINER_ID
```
To remove a docker network
```bash
sudo docker network rm NETWORK_NAME
```
# Building Docker Image
Now, we know how to play with a docker images we get from the docker hub. Now we'll see how we can build a docker image from our development environment.  

To build a docker image, first, we have to create a docker config file, `Dockerfile` . Here, you have to write your docker configuration. There are several rules for writing a `Dockerfile`   
* The first line of your `DOckerfile` should be this
    ```Dockerfile
    FROM BASE_IMAGE
    ```
    You have to extend any docker image.
* You can create a directory where you want to copy your project
    ```Dockerfile
    WORKDIR YOUR_WORKING_DIRECTORY
    ```
* You can copy files from your local machine to a container 
    ```DOckerfile
    COPY FROM_LOCAL TO_CONTAINER
    ```     
* You can run any command in your container
    ```Dockerfile
    RUN COMMAND
    ```
*   You can tell docker which command to execute last 
    ```DOckerfile
    CMD [COMMAND]
    ```        
    Here, you have to write the `COMMAND` separated in `,` not in space. To see more about how to write a valid `Dockerfile`. See [this](https://docs.docker.com/engine/reference/builder/)
* Others, such as `network`, `volume` etc. same as explained before.    
Here's a demo [Dockerfile](Dockerfile) 
Now, to build a docker image
```bash
sudo docker build . # if you are in the same directory where Dockerfile exists.
#or
sudo docker build DOCKERFILE_LOCATION 
```
# Why Docker-compose
You can easily understand why you should use docker-compose by this example.    
You need to setup a node-express server with mongo database. If you wanna use docker, first, you have to create two separate docker conatiner for node-express and mongodb. Then you have to create a network then attach the containers with this network. You have to publish ports for each containers. Uggh! Tons of work.  
To make your life easier, here comes docker-compose. You will write a `Dockerfile` to build your own docker image. Now you'll write a `docker-compose.yml` config file. Then just run this
```bash
sudo docker-compose up
```
This will create a docker network, and create containers according to the `docker-compose.yml` file and connect the containers with this network. You can stop your containers by running this
```bash
sudo docker-compose down
```
This will remove all the containers and the common docker network. Here's a demo [Docker-compose](Docker-compose.yml) file. 
To know more about docker-compose, see [this](https://docs.docker.com/compose/).
# Useful links
* [Docker Docs](https://docs.docker.com/)
* [The Docker Handbook](https://docker.farhan.info/) & [project links](https://github.com/fhsinchy/docker-handbook-projects) for this book.
* [Docker tutorial](https://youtu.be/3c-iBn73dDE)
