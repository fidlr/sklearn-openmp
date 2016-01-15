#!/bin/sh
if [ ! -d "scikit-learn" ]; then
    git clone --recursive -b 0.17.X https://github.com/scikit-learn/scikit-learn.git
    cd scikit-learn
    git apply sklearn-openmp.patch
else
    cd scikit-learn
fi

CFLAGS="-fopenmp -DCV_OMP=1" CXXFLAGS="-fofopenmp -DCV_OMP=1" LDFLAGS=-lgomp python setup.py build

if [ $? -ne 0 ]; then
    exit 1
fi

sudo CFLAGS="-fopenmp -DCV_OMP=1" CXXFLAGS="-fofopenmp -DCV_OMP=1" LDFLAGS=-lgomp python setup.py install
