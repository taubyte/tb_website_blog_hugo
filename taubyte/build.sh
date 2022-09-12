#!/bin/bash

cd /src && git submodule init && git submodule update && hugo && mv public out

exit $?