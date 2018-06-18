Bootstrap: docker
From: cern/cc7-base

%help
Base Container for HEP studies, cern centos 7 + dev tools + recent root build

%files
CompileMC.sh /opt/CompileMC.sh

%post
  yum install -y gvim vim wget cmake root-*
  yum-config-manager --enable rhel-server-rhscl-7-rpms
  yum install rh-git29 devtoolset-7 -y

  set +e
  source scl_source enable rh-git29 devtoolset-7
  set -e
  echo 'source scl_source enable rh-git29 devtoolset-7' >>$SINGULARITY_ENVIRONMENT

  ROOT_VERSION=`root-config --version | sed "s#/#-#g; s#\.#-#g"`
  GCC_VERSION=`gcc --version | grep ^gcc | sed 's/^.* //g;  s#-.*##g; s#\.#-#g'`

  /opt/CompileMC.sh

  echo "PATH=/opt/mcGen-ROOT_${ROOT_VERSION}-GCC_${GCC_VERSION}:$PATH" >> >>$SINGULARITY_ENVIRONMENT
  


%environment
  export IMAGE="S:cc7_MC"
