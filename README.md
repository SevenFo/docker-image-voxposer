VoxPoser Docker image
=======================================

### Building

Use `docker build` as usual, or use the provided script:

Check `build.sh` for detailed information as you need to download `CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz` adn place it in `./download`.

```bash
docker build --rm -f Dockerfile -t voxposer:ubuntu20-v1 .
```

### Running

**Only for Linux Environment**

Use `docker run` as usual.

The provided script `run.sh` sets some useful parameters, such as sharing the `shared` directory, and forwarding the RemoteAPI port.

Check `run.sh` for detailed information.

```bash
sudo docker run --rm -v $HOME/Data:/shared -p 23000-23500:23000-23500 -p 6060:80 -it --env DISPLAY=$DISPLAY --env LIBGL_ALWAYS_SOFTWARE=1 --volume /tmp/.X11-unix:/tmp/.X11-unix --name vox voxposer:ubuntu20-v1
```

If you have add `$USER` to the docker group (which means you can run docker without `sudo`) than try following command

```bash
docker run --privileged --rm -v $HOME/Data:/shared -p 23000-23500:23000-23500 -p 6060:80 -it --env DISPLAY=$DISPLAY --env LIBGL_ALWAYS_SOFTWARE=1 --volume /tmp/.X11-unix:/tmp/.X11-unix --name vox voxposer:ubuntu20-v1
```

Command above would allow the GUI application in docker container connect to the X server running on the host machine while **remember run `sudo xhost +` command in your host machine before launching GUI applications in container**.

### Credits

Thanks to Salvatore Sessa for initially getting CoppeliaSim to work under docker.
