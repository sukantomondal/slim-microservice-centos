#!/bin/sh

if [ -z "$1" ]; then
    PROJECT_NAME="slim-project"
else
    PROJECT_NAME="$1"
fi

PROJECT_DIR=$(pwd)

cd ${PROJECT_DIR}


#The directory for the project
mkdir -p ${PROJECT_NAME}/src/public

# PHP composer install
wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet
mv composer.phar ${PROJECT_DIR}/${PROJECT_NAME}/src/composer.phar

#run composer to install slim framework
(cd ${PROJECT_DIR}/${PROJECT_NAME}/src && php ${PROJECT_DIR}/${PROJECT_NAME}/src/composer.phar require slim/slim)

echo "$(tput setaf 2)Creating project skelton ...$(tput sgr 0)"

touch ${PROJECT_NAME}/src/public/index.php


#index file templet content 
cat <<EOF > ${PROJECT_NAME}/src/public/index.php
<?php
use \\Psr\\Http\\Message\\ServerRequestInterface as Request;
use \\Psr\\Http\\Message\\ResponseInterface as Response;

require '../vendor/autoload.php';

\$app = new \\Slim\\App;
\$app->get('/hello/{name}', function (Request \$request, Response \$response, array \$args) {
    \$name = \$args['name'];
    \$response->getBody()->write("Hello, \$name");

    return \$response;
});
\$app->run();
EOF

# creating .htaccs file
touch ${PROJECT_NAME}/src/public/.htaccess

cat <<EOF > ${PROJECT_NAME}/src/public/.htaccess
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule . index.php [L]
EOF


echo "$(tput setaf 2)Configuring apache...$(tput sgr 0)"

# configure apache to run api

cat <<EOF >> /etc/httpd/conf/httpd.conf
<Directory "${PROJECT_DIR}/${PROJECT_NAME}/src/public">
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>

<VirtualHost *:80>
    DocumentRoot ${PROJECT_DIR}/${PROJECT_NAME}/src/public
</VirtualHost>
EOF

# restart apache
service httpd restart

echo "$(tput setaf 2)Everthing looks OK!!! The Templet successfully installed.$(tput sgr 0)"
