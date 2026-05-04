# Example Dockerfile / Apptainer definition files for Pytorch

This directory contains an example [Dockerfile](Dockerfile) and Apptainer definition files ([catdog_nvidia.def](catdog_nvidia.def) and [catdog_conda.def](catdog_conda.def) for building a PyTorch container for the "catdog" example in this repository.

## Dockerfile

To build a Docker container image, you will need to run these commands on your local computer with Docker installed. You will *not* be able to run these commands on CHTC. You will also need to have a [Docker Hub account](https://hub.docker.com). 

On Linux/Windows, in this directory, run:
```
docker build -t <Docker Hub username>/<image>:<tag> .
```

On MacOS/ARM, in this directory, run:
```
docker build --platform linux/amd64 -t <Docker Hub username>/<image>:<tag> .
```

And push to Docker Hub:
```
docker image push <Docker Hub username>/<image>:<tag>
```

Refer to [our guide on building Docker images](https://chtc.cs.wisc.edu/uw-research-computing/docker-build.html).

## Apptainer

You can build an Apptainer container image on OSPool Access Points. The steps below use the `catdog_conda.def` file - if you prefer, you can use `catdog_nvidia.def`.

First, make sure you run these lines to avoid filling the `/tmp` directory on the Access Point:
```
mkdir -p $HOME/tmp
export TMPDIR=$HOME/tmp
export APPTAINER_TMPDIR=$HOME/tmp
export APPTAINER_CACHEDIR=$HOME/tmp
```

Build the container using Apptainer:
```
apptainer build catdog_conda.sif catdog_conda.def
```

The build should take a few minutes. After the build is complete, you should see your Apptainer image, `catdog_conda.sif`.

Move this file to your `/ospool` directory (change `ap40` to your Access Point):
```
mv catdog_conda.sif /ospool/ap40/data/$USER
```

Refer to [our guide on building Apptainer images](https://portal.osg-htc.org/documentation/htc_workloads/using_software/containers-singularity/).
