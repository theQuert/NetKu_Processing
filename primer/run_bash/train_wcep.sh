#!/bin/bash

cd ../script

# wcep dataset
DATA_NAME="wcep"


# Fully supervised PRIMER model on wcep
MODEL_NAME="PRIMER_wcep"
MODEL_PATH="PRIMER_wcep"
nohup python primer_main.py  \
                --batch_size 1 \
                --gpus 1  \
                --mode train \
                --model_path ../models/$MODEL_NAME/  \
                --dataset_name ${DATA_NAME} \
                --primer_path ../${MODEL_PATH} \
                --num_workers 0 \
                --progress_bar_refresh_rate 50 \
        > ../train_${DATA_NAME}_${MODEL_NAME}.out 2>&1
