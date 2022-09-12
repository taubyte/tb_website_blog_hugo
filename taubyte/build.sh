#!/bin/bash


rm -fr /src/out

cd /src && git submodule init && git submodule update && hugo && mv public out


ls out

exit $?