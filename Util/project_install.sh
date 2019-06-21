#!/bin/sh

PROJECT_DIR=$(pwd)

cd ${PROJECT_DIR}


#The directory for the project
mkdir -p slim-project/src/public

# PHP composer install
wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet
mv composer.phar /usr/local/bin/composer

#run composer to install slim framework
(cd slim-project/src && php /usr/local/bin/composer require slim/slim)

echo "$(tput setaf 2)Creating project skelton ...$(tput sgr 0)"

touch slim-project/src/public/index.php


#index file templet content 
cat <<EOF > slim-project/src/public/index.php
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
touch slim-project/src/public/.htaccess

cat <<EOF > slim-project/src/public/.htaccess
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule . index.php [L]
EOF


echo "$(tput setaf 2)Configuring apache...$(tput sgr 0)"

# configure apache to run api

cat <<EOF >> /etc/httpd/conf/httpd.conf
<Directory "${PROJECT_DIR}/slim-project/src/public">
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>

<VirtualHost *:80>
    DocumentRoot ${PROJECT_DIR}/slim-project/src/public
</VirtualHost>
EOF

# restart apache
service httpd restart

echo "$(tput setaf 2)Everthing looks OK!!! The Templet successfully installed.$(tput sgr 0)"
