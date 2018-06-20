Bootstrap: docker
From: cern/cc7-base

%help
Base Container for HEP studies

%files
CompileMC.sh /opt/CompileMC.sh

%post
  yum install -y curl wget cmake root-*

  ROOT_VERSION=`root-config --version | sed "s#/#-#g; s#\.#-#g"`
  GCC_VERSION=`gcc --version | grep ^gcc | sed 's/^.* //g;  s#-.*##g; s#\.#-#g'`

  /opt/CompileMC.sh

  echo "export PATH=/opt/mcGen-ROOT_${ROOT_VERSION}-GCC_${GCC_VERSION}/bin:$PATH" >> >>$SINGULARITY_ENVIRONMENT
  echo "export LD_LIBRARY_PATH=/opt/mcGen-ROOT_${ROOT_VERSION}-GCC_${GCC_VERSION}/lib:$LD_LIBRARY_PATH" >> >>$SINGULARITY_ENVIRONMENT
  


%environment
  export IMAGE="S:cc7_MC"
