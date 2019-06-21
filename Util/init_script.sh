 #!/bin/bash
 # centos init script
 
 
 # The directory for the project
 mkdir -p slim-project/src/public
 
 # PHP composer install
 wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet
 mv composer.phar /usr/local/bin/composer


 # Run project intalation
 #sh /root/project_install.sh 

 service httpd start
 tail -f /dev/null
