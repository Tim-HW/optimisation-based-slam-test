FROM ros:noetic-ros-base


ENV DEBIAN_FRONTEND=noninteractive

# Disable apt-get warnings
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 42D5A192B819C5DA || true && \
  apt-get update || true && apt-get install -y --no-install-recommends apt-utils dialog && \
  rm -rf /var/lib/apt/lists/*

# Change timezone
ENV TZ=Europe/Brussels
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install build dependencies
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    build-essential \
    git \
    cmake \
    libyaml-cpp-dev \
    software-properties-common \
    pkg-config \ 
    wget \
    curl \
    libgflags-dev \ 
    liblapack-dev

RUN sudo apt install -y \
    libopenblas-dev \
    libgoogle-glog-dev \ 
    libsuitesparse-dev \
    libpcl-dev \ 
    libpdal-dev \ 
    ros-noetic-pcl-conversions \
    ros-noetic-pcl-ros \
    libomp-dev \
    libeigen3-dev &&\
    apt-get clean && rm -rf /var/lib/apt/lists/



# install Sophus
RUN cd / && git clone https://github.com/strasdat/Sophus.git &&\
    cd /Sophus/ &&\
    git checkout 1.22.10 &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make -j10 &&\
    make install

# install Ceres
RUN cd / && git clone https://ceres-solver.googlesource.com/ceres-solver &&\
    cd /ceres-solver/ &&\
    git checkout 2.1.0 &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make -j10 &&\
    make install



ENTRYPOINT ["/sbin/ros_entrypoint.sh"]
CMD ["bash"]
