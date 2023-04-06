#!/usr/bin/env bash
# sets up your web servers for the deployment of web_static
apt-get update
apt-get -y install nginx
mkdir -p /data/
mkdir -p /data/web_static/
mkdir -p /data/web_static/releases/
mkdir -p /data/web_static/shared/
mkdir -p /data/web_static/releases/test/
echo -e "<html>\n  <head>\n  </head>\n  <body>\n    Holberton School\n  </body>\n</html>" > /data/web_static/releases/test/index.html

if [[ -L /data/web_static/current ]]
then
    rm /data/web_static/current
fi

ln -sf /data/web_static/releases/test /data/web_static/current
chown -R ubuntu:ubuntu /data/

if grep -q hbnb_static /etc/nginx/sites-available/default
then
    echo ""
else
    sed -i '/:80 default_server/a \\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}' /etc/nginx/sites-available/default
fi

service nginx restart
