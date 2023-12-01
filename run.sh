set -ex
# docker run -v $PWD/shared:/shared -p 23000-23500:23000-23500 -it coppeliasim-ubuntu22 "$@"

# To open an application window via X11 server:
# docker run -v $PWD/shared:/shared -p 23000-23500:23000-23500 -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --name coppelia_container coppeliasim-ubuntu22 "$@"

# on the host:
# xhost +local:docker

docker run --rm -v $HOME/Data:/shared -p 23000-23500:23000-23500 -p 6060:80 -it --env DISPLAY=$DISPLAY --env LIBGL_ALWAYS_SOFTWARE=1 --volume /tmp/.X11-unix:/tmp/.X11-unix --name vox voxposer:ubuntu20-v1

# docker run --rm -v $HOME/Data:/shared -p 23000-23500:23000-23500 -p 6060:80 -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --name coppelia_container coppeliasim-ubuntu20:v1
