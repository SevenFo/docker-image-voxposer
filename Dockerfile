FROM ubuntu:20.04

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list &&\
    apt-get update && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        vim gcc bash tar xz-utils git \
        libx11-6 libxcb1 libxau6 libgl1-mesa-dev \
        xvfb dbus-x11 x11-utils libxkbcommon-x11-0 \
        libavcodec-dev libavformat-dev libswscale-dev \
        python3.9-full python3.9-dev build-essential libssl-dev libffi-dev python3-pip libraw1394-11 libmpfr6 \
        libusb-1.0-0 \
        && \
    apt-get autoclean -y && apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /bin/python3.9 /bin/python

RUN mkdir -p /shared /opt /root/workspace

COPY ./download/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz /opt/
RUN tar -xf /opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz -C /opt && \
    rm /opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz

ENV COPPELIASIM_ROOT=/opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT
ENV QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT
ENV PATH=$COPPELIASIM_ROOT:$PATH

WORKDIR /root/workspace

RUN git clone https://github.com/stepjam/PyRep.git --depth 1 && cd PyRep && \
    python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt && \
    python -m pip install .

RUN git clone https://github.com/stepjam/RLBench.git --depth 1 && cd RLBench && \
    python -m pip install -r requirements.txt && \
    python -m pip install .

RUN git clone https://github.com/huangwl18/VoxPoser.git && cd VoxPoser && \
    python -m pip install -r requirements.txt

RUN python -m pip install pyzmq cbor

# RUN echo '#!/bin/bash\ncd $COPPELIASIM_ROOT_DIR\n/usr/bin/xvfb-run --server-args "-ac -screen 0, 1024x1024x24" coppeliaSim "$@"' > /entrypoint && chmod a+x /entrypoint

# Use following instead to open an application window via an X server:
# RUN echo '#!/bin/bash\ncd $COPPELIASIM_ROOT_DIR\n./coppeliaSim "$@"' > /entrypoint && chmod a+x /entrypoint

EXPOSE 23000-23500 80
# ENTRYPOINT ["/entrypoint"]
CMD [ "/bin/bash" ]