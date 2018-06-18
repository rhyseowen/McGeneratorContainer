#!/bin/bash

ROOT_VERSION=`root-config --version | sed "s#/#-#g; s#\.#-#g"`
GCC_VERSION=`gcc --version | grep ^gcc | sed 's/^.* //g;  s#-.*##g; s#\.#-#g'`

FASTJET_VERSION=3.2.1
LHAPDF_VERSION=6.1.6
OPENLOOPS_VERSION=1.3.1
HEPMC_VERSION=2.06.09
OPENMPI_VERSION=3.1.0
SHERPA_VERSION=2.2.4

MAKE_ARGS="-j"`nproc --ignore=1`

PREFIX=/opt/mcGen-ROOT_${ROOT_VERSION}-GCC_${GCC_VERSION}

WORKDIR=`mktemp --tmpdir -d COMPILEMC.XXXXXXXXX`
echo "Using workdir:${WORKDIR}"
cd $WORKDIR

mkdir -p $PREFIX/bin
export PATH=$PREFIX/bin:$PATH

#fastjet
cd $WORKDIR
curl -O http://fastjet.fr/repo/fastjet-${FASTJET_VERSION}.tar.gz
tar -xzf fastjet-${FASTJET_VERSION}.tar.gz
cd fastjet-${FASTJET_VERSION} 
./configure --prefix=$PREFIX
make $MAKE_ARGS
make check
make install


#LHAPDF
cd $WORKDIR
wget http://www.hepforge.org/archive/lhapdf/LHAPDF-${LHAPDF_VERSION}.tar.gz
tar -xzf LHAPDF-${LHAPDF_VERSION}.tar.gz
cd LHAPDF-${LHAPDF_VERSION}
./configure --prefix=$PREFIX
make $MAKE_ARGS
make install

#OPENLOOPS
cd $WORKDIR
wget http://www.hepforge.org/archive/openloops/OpenLoops-${OPENLOOPS_VERSION}.tar.gz
tar -xzf ./OpenLoops-${OPENLOOPS_VERSION}.tar.gz 
mv OpenLoops-${OPENLOOPS_VERSION} $PREFIX/
export OPENLOOPS=$PREFIX/OpenLoops-${OPENLOOPS_VERSION}
cd $OPENLOOPS
./scons
./openloops libinstall all.coll compile_extra=1

#HEPMC
cd $WORKDIR
wget http://hepmc.web.cern.ch/hepmc/releases/hepmc${HEPMC_VERSION}.tgz
tar -xzf hepmc${HEPMC_VERSION}.tgz
mkdir HepMC-build
cd HepMC-build
cmake3 -DCMAKE_INSTALL_PREFIX=$PREFIX -Dmomentum:STRING=MEV -Dlength:STRING=MM ../hepmc${HEPMC_VERSION}/
make $MAKE_ARGS
make test
make install

#OPENMPI
cd $WORKDIR
wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-${OPENMPI_VERSION}.tar.gz
tar -xzf openmpi-${OPENMPI_VERSION}.tar.gz
cd openmpi-${OPENMPI_VERSION}
./configure --prefix=$PREFIX --enable-mpi-cxx --enable-mpi-cxx-seek --enable-cxx-exceptions
make $MAKE_ARGS
make install

#SHERPA
cd $WORKDIR
wget http://www.hepforge.org/archive/sherpa/SHERPA-MC-${SHERPA_VERSION}.tar.gz
tar -xzf SHERPA-MC-${SHERPA_VERSION}.tar.gz
cd SHERPA-MC-2.2.1
./configure --enable-hepmc2=$PREFIX --enable-fastjet=$PREFIX --enable-openloops=$OPENLOOPS --enable-lhapdf=$PREFIX --enable-root --prefix=$PREFIX
make $MAKE_ARGS
make install

cd
rm -rf  $WORKDIR 


