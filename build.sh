COPPELIASIM_RELEASE=CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz
MINIFORGE3_RELEASE=Miniforge3-Linux-x86_64.sh
if [ ! -f download/$COPPELIASIM_RELEASE ]; then
    if [ "$1" = "-d" ]; then
        if ! command -v curl > /dev/null 2>&1; then
            echo "Command 'curl' not available" 1>&2
            exit 1
        fi
        rm -rf download/tmp
        mkdir download/tmp
        echo "Downloading $COPPELIASIM_RELEASE"
        cd download/tmp
        curl --progress-bar --remote-name --location \
            https://www.coppeliarobotics.com/files/$COPPELIASIM_RELEASE || exit 1
        mv $COPPELIASIM_RELEASE ..
        cd -
    else
        echo "File 'download/$COPPELIASIM_RELEASE' not found."
        echo "Either download it manually, or pass the -d option."
        exit 1
    fi
fi
if [ ! -f download/$MINIFORGE3_RELEASE ]; then
    if [ "$1" = "-d" ]; then
        if ! command -v curl > /dev/null 2>&1; then
            echo "Command 'curl' not available" 1>&2
            exit 1
        fi
        rm -rf download/tmp
        mkdir download/tmp
        echo "Downloading $COPPELIASIM_RELEASE"
        cd download/tmp
        curl --progress-bar --remote-name --location \
            https://github.com/conda-forge/miniforge/releases/latest/download/$COPPELIASIM_RELEASE || exit 1
        mv $MINIFORGE3_RELEASE ..
        cd -
    else
        echo "File 'download/$MINIFORGE3_RELEASE' not found."
        echo "Either download it manually, or pass the -d option."
        exit 1
    fi
fi
docker build --rm -f Dockerfile -t voxposer:ubuntu20-v1 .
