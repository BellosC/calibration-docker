FROM ros:kinetic-ros-core

RUN apt-get update && apt-get install -y --allow-unauthenticated \
build-essential \
cmake \
git \
ros-kinetic-vision-opencv \
libeigen3-dev \
libpcl-dev \
libsuitesparse-dev \
ros-kinetic-tf \
ros-kinetic-pcl-ros \
libgoogle-glog-dev \
libgflags-dev \
wget \
libsuitesparse-dev \
ros-kinetic-image-transport

RUN rm -rf /var/lib/apt/lists/*

RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz
RUN wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz
RUN tar zxf ceres-solver-1.14.0.tar.gz
RUN tar zxf eigen-3.3.7.tar.gz
WORKDIR /eigen-3.3.7/build
RUN cmake ..
RUN make install
WORKDIR /ceres-bin
RUN cmake ../ceres-solver-1.14.0 
RUN make -j"$(($(nproc)+1))"
# RUN make test
RUN make install
# RUN bin/simple_bundle_adjuster ../ceres-solver-1.14.0/data/problem-16-22106-pre.txt
WORKDIR /
RUN git clone --depth=1 https://github.com/Livox-SDK/Livox-SDK.git 

WORKDIR /ws_livox/src
RUN git clone --depth=1 https://github.com/Livox-SDK/livox_ros_driver.git
RUN git clone --depth=1 https://github.com/Livox-SDK/livox_camera_lidar_calibration.git

WORKDIR /Livox-SDK/build

RUN cmake .. && make -j"$(($(nproc)+1))" && make install -j"$(($(nproc)+1))"

RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /ws_livox; catkin_make -j"$(($(nproc)+1))"'

WORKDIR /

COPY . .

ENTRYPOINT [ "./entrypoint.sh" ]
