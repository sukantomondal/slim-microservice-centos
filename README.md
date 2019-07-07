# slim-microservice-centos
A centos server with slim micro-service

* Pull the Docker image
   * sudo docker pull sukantomondal/slim-microservice-centos
* Run the container from your docker host
   * sudo docker run -itd --rm --name=cems -p 8880:80 sukantomondal/slim-microservice-centos
* Go to container shel
   * sudo docker exec -it cems sh
* Install project in the container
   * sh /root/project_install.sh {your_project_name}   
   
