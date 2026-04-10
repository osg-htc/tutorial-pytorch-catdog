# tutorial-pytorch-catdog

This repository contains files demonstrating how to run PyTorch workflows on the Open Science Pool. Use this repository as a reference as you start creating your own PyTorch workflows.

> [!WARNING]
> This workflow is designed for OSPool systems. If you are running this workflow on other HTCondor systems, we recommend consulting your local support staff.

## Contents
* `train/` - Submit a training job that generates a model file (`model.pth`) that can be used in inference workflows.
* `infer/` - Submit multiple jobs that run inference on multiple zip files, locally and on other pools.
* `container/` - Reference files for building the software environment in these examples.

## Training slides
[Google Slides](https://docs.google.com/presentation/d/1RvjDtVf0xx1pqFdbgmMY5wkPVr1B5hir6bpoqlIgF9Q/edit?usp=sharing)
