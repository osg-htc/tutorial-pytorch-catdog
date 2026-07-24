## Run PyTorch jobs on the OSPool (Notebook version)
In this tutorial, we will use PyTorch to train a cat/dog classifier to distinguish between images of cats and dogs. To download the materials for this tutorial, use this command in your `/home` directory on the Access Point in the [OSPool notebooks](https://notebook.ospool.osg-htc.org/) and switch to the PEARC26 branch:

```
git clone https://github.com/osg-htc/tutorial-pytorch-catdog.git
git switch pearc26
```

The github repository contains:
- Definition files for PyTorch containers
- Files and [notebook](train/train.ipynb) for training a cat/dog classifier
- Files and [notebook](infer/infer.ipynb) for running inference with the cat/dog classifier

## Other considerations

- [Check your log file](https://portal.osg-htc.org/documentation/htc_workloads/workload_planning/htcondor_job_submission/#5-examine-the-results) for resource usage and optimize your requests for more throughput.
- Automate workflows with [DAGMan](https://portal.osg-htc.org/documentation/htc_workloads/automated_workflows/dagman-workflows/).
- [Checkpoint your jobs](https://portal.osg-htc.org/documentation/htc_workloads/submitting_workloads/checkpointing-on-OSPool/) for longer trainings and/or to improve throughput.

## Related pages
- [GPU jobs](https://portal.osg-htc.org/documentation/htc_workloads/specific_resource/gpu-jobs/)
- [Request variable amounts of memory](https://portal.osg-htc.org/documentation/htc_workloads/specific_resource/retry-request-memory/)
- [Easily submit multiple jobs](https://portal.osg-htc.org/documentation/htc_workloads/submitting_workloads/submit-multiple-jobs/)
- [Google Slides from April 21, 2026 training](https://docs.google.com/presentation/d/1RvjDtVf0xx1pqFdbgmMY5wkPVr1B5hir6bpoqlIgF9Q/edit?usp=sharing)
