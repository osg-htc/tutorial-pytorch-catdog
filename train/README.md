# Training

Files needed for training a cat/dog classifier.

* `train.py` - The Python script for our training.
* `train.sh` - The shell script that wraps around `train.py` and handles data, inputs, and outputs.
* `train.sub` - The HTCondor job submit file which specifies how to run our job and what resources we need.

This example uses an [Apptainer image](../container/catdog_conda.def), so the `request_disk` requirement in the submit file is increased to account for the size of the Apptainer image (9.3 GB).
