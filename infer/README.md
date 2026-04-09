# Inference

Files needed to run inference jobs for a cat/dog classifier.

* `infer.py` - The Python script for our inference.
* `infer.sh` - The shell script that wraps around `infer.py` and handles data, inputs, and outputs.
* `infer.sub` - The HTCondor job submit file which specifies how to run our job and what resources we need.
* `data/` - The directory containing our inference dataset. Each zip file contains 1250 jpg files.
* `data_list.txt` - A text file listing each zip file in our inference dataset. This is used in `infer.sub` to submit multiple jobs from a single `condor_submit` command. You can easily generate a file like this using `ls data/ > data_list.txt`.
