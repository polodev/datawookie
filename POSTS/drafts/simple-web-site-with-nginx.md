Allow access on port.

iptables -I INPUT -p tcp --dport 82 -j ACCEPT

Check access.

iptables -L | grep 82

NGINX Configuration

server {
        listen 82;

        root /home/django/python-web-scraping;

        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }
}
