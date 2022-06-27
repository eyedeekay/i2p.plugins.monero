#! /usr/bin/env sh

here=$(dirname $(readlink -f "$0"))
cd "$here"
echo "$here"

cd linux32 && ./build.sh
cd $here

cd linux64 && ./build.sh
cd $here

cd linuxarm7 && ./build.sh
cd $here

cd linuxarm8 && ./build.sh
cd $here

cd win64 && ./build.sh
cd $here

cd win32 && ./build.sh
cd $here

cd mac64 && ./build.sh
cd $here