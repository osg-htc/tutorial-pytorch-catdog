#!/bin/bash

# Assign the first argument to "zip"
zip=$1

mkdir data
unzip $zip -d data
rm $zip

python infer.py --data-dir data --model-path model.pth
