#!/bin/sh
if [ ! -d "scikit-learn" ]; then
    git clone --recursive -b 0.17.X https://github.com/scikit-learn/scikit-learn.git
    cd scikit-learn
else
    cd scikit-learn
fi

echo "**************************************************************************************************"
echo "Apply svm openmp patch to scikit-learn"
git apply --ignore-whitespace ../sklearn-openmp.patch
if [ $? -ne 0 ]; then
	cd ..
    exit 1
fi

echo "**************************************************************************************************"
echo "Building scikit-learn with libsvm and liblinear openmp support"
CFLAGS="-fopenmp -DCV_OMP=1" CXXFLAGS="-fofopenmp -DCV_OMP=1" LDFLAGS=-lgomp python setup.py build
if [ $? -ne 0 ]; then
	cd ..
    exit 1
fi

echo "**************************************************************************************************"
echo "Enter root password for scikit-learn deployment (install script)"
sudo CFLAGS="-fopenmp -DCV_OMP=1" CXXFLAGS="-fofopenmp -DCV_OMP=1" LDFLAGS=-lgomp python setup.py install
cd ..

