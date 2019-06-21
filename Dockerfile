#Author: Sukanto Mondal
#A basic centos6 server docker image

FROM centos:6
ENV container docker
ADD Util/init_script.sh /root/init_script.sh
ADD Util/project_install.sh /root/project_install.sh

RUN yum -y install wget unzip
RUN yum -y install httpd

#Installing php7

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-6.rpm

RUN yum -y install yum-utils

RUN yum-config-manager --enable remi-php70   [Install PHP 7.0]

RUN yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo 

EXPOSE 80
EXPOSE 8080

CMD sh /root/init_script.sh
