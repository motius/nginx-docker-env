# What is it?

It's a container that packages an nginx server with bindings for running Lua scripts and the Lua DKJSON library. When you have a project where you need to serve some application that needs access to the environment variables of the container then you can use this container to quickly do that.

# How to use it?

The entrypoint script of the container checks the environment variables and expects to discover a special variable with the name `NGINX_ENV_VARS`. The value of this variable should be a comma-separated list contianing the names of all the environment variables that you want to have access to. 

For example, if you want to load the variables `ENV1=bla` and `ENV2=blabla` to the environemnt of the container and make them accessible from the outside then you should set `NGINX_ENV_VARS="ENV1,ENV2"`. 

You do not need to do anything else, the entrypoint will take care of the rest during the container startup. 

In your nginx configuration you must also include the following:

```
location /env {                                                                                             
    content_by_lua_file /usr/local/openresty/nginx/lua/serve_vars.lua;                                      
}
```

This /env endpoint is the one that you need to call with a GET request to get the json document with the environment variables that you have loaded to the container.

