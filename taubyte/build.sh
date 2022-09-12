#!/bin/bash


cd /src && git submodule init && git submodule update && hugo && (mkdir -pv src/out || true) && mv public src/out


ls src/out

exit $?