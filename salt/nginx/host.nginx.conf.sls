server {
	listen {{ port }};
	server_name {{ host }};
	root /srv/;
	index index.html index.htm index.php;

	location / {
		try_files $uri $uri;
	}

	include /etc/nginx/apps.conf.d/*.conf;

	location = /favicon.ico { access_log off; log_not_found off; }
	location = /robots.txt { access_log off; log_not_found off; }
}
