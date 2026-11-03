#!/bin/bash
# docker-getrun.sh
# 欢迎访问 https://aq2.cn 交流
# Reconstruct docker run command from existing container
set -e

CID="$1"
if [ -z "$CID" ];then
  echo "Usage: $0 <container-id/name>"
  exit 1
fi

raw=$(docker inspect "$CID")
name=$(echo $raw | jq -r '.[0].Name' | sed 's/^\///')
img=$(echo $raw | jq -r '.[0].Config.Image')
cmd=$(echo $raw | jq -r '.[0].Config.Cmd | join(" ")')
entry=$(echo $raw | jq -r '.[0].Config.Entrypoint | join(" ")')
workdir=$(echo $raw | jq -r '.[0].Config.WorkingDir')
restart=$(echo $raw | jq -r '.[0].HostConfig.RestartPolicy.Name')

# env
envs=$(echo $raw | jq -r '.[0].Config.Env[] | "-e \"" + . + "\""')
# port mappings
ports=$(echo $raw | jq -r '.[0].HostConfig.PortBindings | to_entries[] | .key as $k | .value[] | "-p \(.HostIp):\(.HostPort):\($k)"')
# volumes
mounts=$(echo $raw | jq -r '.[0].Mounts[] | "-v \(.Source):\(.Destination)"')

ARGS=("-d" "--name $name")
if [ "$restart" != "no" ];then ARGS+=("--restart $restart");fi
if [ -n "$workdir" ];then ARGS+=("-w $workdir");fi

final="docker run ${ARGS[*]} $envs $ports $mounts $img"
if [ -n "$entry" ];then final+=" --entrypoint $entry";fi
if [ "$cmd" != "null" ];then final+=" $cmd";fi

echo $final
