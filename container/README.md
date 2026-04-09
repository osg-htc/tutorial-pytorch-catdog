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

You can build an Apptainer container image on CHTC systems. The steps below use the `catdog_conda.def` file - if you prefer, you can modify `build.sub` and the steps below to reference `catdog_nvidia.def`. You'll also need to modify `build.sub` to transfer `requirements.txt`.

To do so, you'll need to submit an interactive job:
```
condor_submit -i build.sub
```

Once you've entered the interactive job, build the container using Apptainer:
```
apptainer build catdog_conda.sif catdog_conda.def
```

The build should take a few minutes. After the build is complete, you should see your Apptainer image, `catdog_conda.sif`.

Move this file to your `/staging` directory:
```
mv catdog_conda.sif /staging/$USER
```

Refer to [our guide on building Apptainer images](https://chtc.cs.wisc.edu/uw-research-computing/apptainer-htc).
