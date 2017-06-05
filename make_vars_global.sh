#!/bin/ash

set -e

# add an element to the pseudobuffer
function append_val() {
        offset=$buf0
        let "offset=offset + 1"
        eval buf$offset="\$1"
        buf0=$offset
}

# splits the string using the delimiter provided and 
# stores the chunks found into the pseudobufer named
# buf
function split() {
        str=$1
        del=$2
        chunk=""
        i=0
        len=${#str}
        eval buf0=0
        while true; do
                if [ $i -ge $len ]; then
                        append_val $chunk
                        break
                fi
                c=${str:$i:1}
                if [ $c = $del ]; then
                        append_val $chunk
                        chunk=""
                else
                        chunk="$chunk$c"
                fi
                let "i = i + 1"
        done
}

function print_buf() {
        i=1
        while [ $i -le $buf0 ]; do
                eval assign="\$buf$i"
                eval echo "$assign=\$$assign"
                let "i=i+1"
        done
}

function output_vars() {
        i=1
        while [ $i -le $buf0 ]; do
                eval assign="\$buf$i"
                eval echo "export $assign=\$$assign" >> /etc/profile.d/env_vars.sh
                let "i=i+1"
        done
}

echo "#!/bin/ash" > /etc/profile.d/env_vars.sh
echo "" >> /etc/profile.d/env_vars.sh
echo "export NGINX_ENV_VARS=$NGINX_ENV_VARS" >> /etc/profile.d/env_vars.sh
split $NGINX_ENV_VARS ","
chunks="$buf0"
output_vars
chmod 0777 /etc/profile
for i in $(ls /etc/profile.d/); do
        chmod 0777 "/etc/profile.d/$i"
done
