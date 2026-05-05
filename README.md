---
ospool:
  path: software_examples/ai/tutorial-pytorch/README.md
---

The OSPool can be used as a platform to carry out machine learning and artificial intelligence research. 
The following tutorial uses the common machine learning framework, PyTorch.

## Using PyTorch on OSPool
The preferred method of using a software on the the OSPool is to use a [container.](https://portal.osg-htc.org/documentation/htc_workloads/using_software/containers/) The guide shows how to run PyTorch by downloading our desired version of PyTorch images from DockerHub.

### Pulling an Image from Docker
**Please note that the `docker build` will not work on the access point**. Apptainer is installed on the access point and users can use Apptainer to either build an image from the definition file or use `apptainer pull` to create a `.sif` file from Docker images. At the time the guide is written, the latest version of PyTorch is 2.9.0. Before pulling the image/software from Docker it is a good practice to set up the cache directory of Apptainer. Run the following command on the command prompt

```
[user@ap]$ mkdir $HOME/tmp
[user@ap]$ export TMPDIR=$HOME/tmp
[user@ap]$ export APPTAINER_TMPDIR=$HOME/tmp
[user@ap]$ export APPTAINER_CACHEDIR=$HOME/tmp
```

Now, we pull the image and convert it to a `.sif` file using `apptainer pull`

```
[user@ap]$ apptainer pull  pytorch-2.9.0.sif docker://pytorch/pytorch:2.9.0-cuda12.6-cudnn9-runtime
```

#### Transfer the image using OSDF
The above command will create a singularity container named `pytorch-2.9.0.sif` in your current directory. The image will be reused for each job, and thus the preferred transfer method is [OSDF](https://portal.osg-htc.org/documentation/htc_workloads/managing_data/osdf/). Store the `pytorch-2.9.0.sif` file your data directory on the access point (see table [here](https://portal.osg-htc.org/documentation/htc_workloads/managing_data/overview/)), and then use the OSDF url directly in the `container_image` attribute.  Note that you can not use shell variable expansion in the submit file - be sure to replace the access point and username with your actual OSPool username.

```
container_image = osdf:///ospool/<AP/data/<USERNAME>/pytorch-2.9.0.sif
<other usual submit file lines> 
queue
```

Need to install additional system or Python packages? Check out our [example PyTorch definition files](https://github.com/osg-htc/tutorial-pytorch-catdog/tree/main/container).

## Run PyTorch jobs on the OSPool
In this tutorial, we will use PyTorch to train a cat/dog classifier to distinguish between images of cats and dogs. To download the materials for this tutorial, use this command in your `/home` directory on the Access Point:

```
git clone https://github.com/osg-htc/tutorial-pytorch-catdog.git
```

The github repository contains:
- Definition files for PyTorch containers
- Files for training a cat/dog classifier
- Files for running inference with the cat/dog classifier

### Train a cat/dog classifier

Go into the directory with files for the training job:

```
cd train
```

Let's take a look at our wrapper script, `train.sh`:

```
#!/bin/bash

unzip train.zip -d data/
rm train.zip

python train.py \
  --data-dir data \
  --checkpoint-dir . \
  --epochs 10
```

We unzip our training data, then run our Python script, using the current working directory (which is the top-level scratch directory of the Execution Point) as the place to save our model checkpoint.

We have written our Python script to take in arguments. This makes it easier to modify in later training jobs, in case we need to change the number of training epochs or use different input/output directories.

Let's take a look at an excerpt from the submit file (`train.sub`) to understand what we're doing:

```
container_image = osdf:///osg-public/containers/catdog_conda.sif
shell = ./train.sh
transfer_input_files = train.sh, train.py, osdf:///osg-public/data/tutorial-OSG-pytorch/train.zip
transfer_output_files = model.pth
```

* We are using an OSG-hosted container image called `catdog_conda.sif` using the OSDF file transfer protocol.
* We are running `train.sh`, our shell wrapper script, which unzips `train.zip`, our training data, and then runs `train.py`, which is our Python training script.
* We transfer in all the files we need: `train.sh`, `train.py`, and `train.zip`.
* We transfer `model.pth` back from the Execution Point to the Access Point when the training is complete.

!!! note "Large data and the OSDF"
    `train.zip` is a large, OSG-hosted dataset, so we are using the OSDF file transfer protocol. For your large training files, we recommend saving them in your `/ospool` directories as zip files or tarballs, and using the OSDF to transfer those files. To learn more, visit our guide: https://portal.osg-htc.org/documentation/htc_workloads/managing_data/osdf/

Also in the submit file:

```
#=== Resource requirements ===#
request_cpus = 1
request_memory = 4GB
request_disk = 15GB
request_gpus = 1

#=== GPU options ===#
gpus_minimum_capability = 7.5
gpus_minimum_memory = 4GB
```

Here, we must request enough disk space to accommodate all our files, including our container image. Additionally, we request certain GPU options, such as memory and capability. The latest versions of PyTorch (as of March 20, 2026) require a minimum capability of 7.5.

To submit the job, run:

```
condor_submit train.sub
```

This job should take approximately 30 minutes. You can watch the progress of your job with:
```
condor_watch_q
```

When your job is complete, you should see an updated `model.pth` in the current working directory. Use `ls -lh` to confirm that the model.pth file is updated.

```
ls -lh model.pth
```

### Run inference using the cat/dog classifier

Let's run some inference jobs using the model we just trained. If you are in the training directory, move out of the training directory and into the inference directory.

```
cd ../infer
```

We will submit 10 inference jobs on sets of images to classify how cat- or dog-like the images are. Because there are no dependencies between these images, we can submit each set of images (saved as zip files in the `data/` subdirectory) as independent jobs.

Let's examine our inference wrapper script, `infer.sh`:

```
#!/bin/bash

# Assign the first argument to "zip"
zip=$1

mkdir data
unzip $zip -d data
rm $zip

python infer.py --data-dir data --model-path model.pth
```

We will pass in a zip file (this will range from `images_01.zip` to `images_10.zip`) as an argument, which is then unzipped into a `data` directory, which the Python script will use with the model to run its inference.

Let's inspect the corresponding submit file, `infer.sub`:

```
batch_name = catdog_infer_$(Cluster)

#=== Job execution / data handling ===#
container_image = osdf:///osg-public/containers/catdog_conda.sif
shell = ./infer.sh $(zipfile)
transfer_input_files = infer.sh, infer.py, ../train/model.pth, ../train/train.py, data/$(zipfile)
transfer_output_files = dog_probs.csv
transfer_output_remaps = "dog_probs.csv = output/dog_probs_$(zipfile).csv"

#=== Stdout/error / HTCondor log ===#
output = logs/$(batch_name).$(Process).out
error = logs/$(batch_name).$(Process).err
log = logs/$(batch_name).log

#=== Resource requirements ===#
request_cpus = 1
request_memory = 4GB
request_disk = 15GB
request_gpus = 1

#=== GPU options ===#
gpus_minimum_capability = 7.5
gpus_minimum_memory = 4GB

queue zipfile from data_list.txt
```

Much of it is similar to `train.sub` from the previous training step, with a few key differences:
- The `queue <variable> from <list>` syntax allows HTCondor to submit 10 independnt jobs based on the list of zip files listed in `data_list.txt`. Each zip file (i.e., `images_01.zip`) is assigned to the variable, `$(zipfile)`.
- We transfer input files using relative paths.
- Because the output is always named `dog_probs.csv`, this will be overwritten after each of the 10 jobs are complete. To avoid overwriting the same file, we use `transfer_output_remaps` with unique filenames, based on the original zip file's name.
- This job uses some code from the original `train.py`, therefore `train.py` is included in the input files.

Submit the job with:

```
condor_submit infer.sub
```

You should see that you've submitted 10 jobs. To watch the status of your jobs, use `condor_watch_q`. When your jobs complete, you should have 10 new csv files with probabilities of the "dogginess" of the images in the zip files.

## Other considerations

- [Check your log file](https://portal.osg-htc.org/documentation/htc_workloads/workload_planning/htcondor_job_submission/#5-examine-the-results) for resource usage and optimize your requests for more throughput.
- Automate workflows with [DAGMan](https://portal.osg-htc.org/documentation/htc_workloads/automated_workflows/dagman-workflows/).
- [Checkpoint your jobs](https://portal.osg-htc.org/documentation/htc_workloads/submitting_workloads/checkpointing-on-OSPool/) for longer trainings and/or to improve throughput.

## Related pages
- [GPU jobs](https://portal.osg-htc.org/documentation/htc_workloads/specific_resource/gpu-jobs/)
- [Request variable amounts of memory](https://portal.osg-htc.org/documentation/htc_workloads/specific_resource/retry-request-memory/)
- [Easily submit multiple jobs](https://portal.osg-htc.org/documentation/htc_workloads/submitting_workloads/submit-multiple-jobs/)
- [Google Slides from April 21, 2026 training](https://docs.google.com/presentation/d/1RvjDtVf0xx1pqFdbgmMY5wkPVr1B5hir6bpoqlIgF9Q/edit?usp=sharing)
