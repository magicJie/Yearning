#!/bin/bash

exec "$@"

# 启动juno
nohup ./juno &

# 启动yearning
./Yearning install | ./Yearning migrate
./Yearning run