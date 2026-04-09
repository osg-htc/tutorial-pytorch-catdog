#!/bin/bash

unzip train.zip -d data/
rm train.zip

python train.py \
  --data-dir data \
  --checkpoint-dir . \
  --epochs 10
