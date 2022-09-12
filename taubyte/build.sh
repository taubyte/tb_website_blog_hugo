#!/bin/bash

pwd

ls /src 

git submodule init && git submodule update && hugo && mv public/* /out

exit $?