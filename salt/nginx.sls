nginx:
  pkg:
    - installed
  service.running:
    - enable: true
    - require:
      - pkg: nginx
      - file: /etc/nginx/sites-enabled/default
    - watch:
      - file: /etc/nginx/conf.d/http.conf
      - file: /etc/nginx/proxy_params

/etc/nginx/conf.d/http.conf:
  file.managed:
    - content: |
        client_max_body_size 30m;			# default is 1m
        client_body_buffer_size 128k;		# default is 8k or 16k
        client_header_buffer_size 1k;		# this is default
        large_client_header_buffers 4 64k;	# default is 4 8k
    - require:
      - pkg: nginx

/etc/nginx/proxy_params:
  file.managed:
    - content: |
        proxy_redirect off;
        proxy_pass_header Server;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        proxy_buffer_size 4k;
        proxy_buffers 4 32k;
        proxy_busy_buffers_size 64k;
        proxy_temp_file_write_size 64k;
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file.absent
