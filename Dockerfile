FROM centos:8

LABEL opensciencegrid.name="EL 8"
LABEL opensciencegrid.description="Enterprise Linux (CentOS) 8 base image"
LABEL opensciencegrid.url="https://www.centos.org/"
LABEL opensciencegrid.category="Base"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-el8"

# base dnf/yum setup
RUN dnf -y update && \
    dnf -y install 'dnf-command(config-manager)' && \
    yum -y config-manager --set-enabled PowerTools && \
    dnf -y install epel-release

# osg repo - not available yet
#RUN dnf -y install http://repo.opensciencegrid.org/osg/3.5/osg-3.5-el8-release-latest.rpm
   
# pegasus repo - not available yet
# RUN echo -e "# Pegasus\n[Pegasus]\nname=Pegasus\nbaseurl=http://download.pegasus.isi.edu/wms/download/rhel/7/\$basearch/\ngpgcheck=0\nenabled=1\npriority=50" >/etc/dnf.repos.d/pegasus.repo

# well rounded basic system to support a wide range of user jobs
RUN dnf -y groupinstall "Development Tools" \
                        "Scientific Support"

RUN dnf -y install --allowerasing \
           redhat-lsb \
           bc \
           binutils \
           binutils-devel \
           coreutils \
           curl \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           glib2-devel \
           glibc-langpack-en \
           glibc-locale-source \
           graphviz \
           gsl-devel \
           java-11-openjdk \
           java-11-openjdk-devel \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libX11-devel \
           libXaw-devel \
           libXext-devel \
           libXft-devel \
           libxml2 \
           libxml2-devel \
           libXmu-devel \
           libXpm \
           libXpm-devel \
           libXt \
           mesa-libGL-devel \
           openssh \
           openssh-server \
           python3-devel \
           python3-numpy \
           python3-scipy \
           redhat-lsb-core \
           rsync \
           subversion \
           tcl-devel \
           tcsh \
           time \
           tk-devel \
           wget \
           which

# osg
#RUN dnf -y install osg-ca-certs osg-wn-client \
#    && rm -f /etc/grid-security/certificates/*.r0

# htcondor - include so we can chirp
#RUN dnf -y install condor

# pegasus
#RUN dnf -y install pegasus

# Cleaning caches to reduce size of image
RUN dnf clean all

# required directories
RUN for MNTPOINT in \
        /cvmfs \
        /ceph \
        /hadoop \
        /hdfs \
        /lizard \
        /mnt/hadoop \
        /mnt/hdfs \
        /xenon \
        /spt \
        /stash2 \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs /etc/OpenCL/vendors

RUN mkdir -p /.singularity.d
COPY osg-labels.json /.singularity.d/labels.json

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt


