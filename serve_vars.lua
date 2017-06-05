local json = require("dkjson")

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function get_from_env(name)
        local f = assert(io.popen("/bin/sh -c 'source /etc/profile; echo \"$" .. name .. "\"'", 'r'))
        return assert(f:read('*a')):gsub("n", ""):gsub("%s+", "")
end

local env_vars_to_load = get_from_env("NGINX_ENV_VARS")
local name = "NGINX_ENV_VARS"
local response = {
        command = "/bin/sh -c 'source /etc/profile; echo \"$" .. name .. "\"'"
}

if env_vars_to_load == nil or env_vars_to_load == '' then
        response.vars_list = "empty"
else
        response.vars_list = env_vars_to_load
        for key,value in pairs(split(env_vars_to_load, ",")) do
                response[value] = get_from_env(value)
        end
end

ngx.header["Content-Type"] = "application/json"
ngx.say(json.encode(response))
