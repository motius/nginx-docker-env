FROM openresty/openresty:alpine-fat

RUN 	luarocks install dkjson \
	&& mkdir -p /usr/local/openresty/nginx/bash \
	&& mkdir -p /usr/local/openresty/nginx/lua \
	$$ mkdir -p /usr/local/openresty/nginx/conf.d \
	&& mkdir -p /var/log/nginx \
	&& touch /var/log/nginx/access.log

COPY entrypoint.sh /usr/local/openresty/nginx/bash/entrypoint.sh
COPY make_vars_global.sh /usr/local/openresty/nginx/bash/make_vars_global.sh
COPY serve_vars.lua /usr/local/openresty/nginx/lua/serve_vars.lua
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY default.conf /usr/local/openresty/nginx/conf.d/default.conf

RUN chmod 0777 /usr/local/openresty/nginx/bash/*

ENTRYPOINT ["/usr/local/openresty/nginx/bash/entrypoint.sh"]
