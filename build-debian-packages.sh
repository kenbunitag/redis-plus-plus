#!/bin/bash
# This script builds debian package
# To be used for docker-build with kenbun-cppubuntu2004

builddir=build

# From here on build release code
mkdir -p $builddir
cd $builddir

# Configure Project
cmake -DCMAKE_BUILD_TYPE=Release -DREDIS_PLUS_PLUS_CXX_STANDARD=14 -DCMAKE_INSTALL_PREFIX=/usr ..

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while configuring project"
    cd ..
    exit $retVal
fi


# Build debian packages
cpack -G DEB

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while building debian packege"
    exit $retVal
fi

cd ..



