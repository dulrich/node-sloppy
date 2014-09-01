#!/bin/bash

make all

set -m

DEBUG=* node $1.js &

trap "kill $!" SIGINT SIGTERM EXIT

fg %1