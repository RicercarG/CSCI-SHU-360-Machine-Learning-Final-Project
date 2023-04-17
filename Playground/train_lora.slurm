srun --nodes=1 --cpus-per-task=2 --mem=32GB --time=1:00:00 --gres=gpu:1 --pty /bin/bash

singularity exec --nv --bind /scratch/yg2709/ml_project_env/overlay-25GB-500K source /ext3/env.sh

which python

cd /scratch/yg2709/CSCI-SHU-360-Machine-Learning-Final-Project/Playground/

pwd

export MODEL_NAME="runwayml/stable-diffusion-v1-5"
export OUTPUT_DIR="/scratch/yg2709/CSCI-SHU-360-Machine-Learning-Final-Project/Playground/sddata/finetune/lora/pokemon"
export HUB_MODEL_ID="pokemon-lora"
export DATASET_NAME="lambdalabs/pokemon-blip-captions"

accelerate launch --mixed_precision="fp16"  train_text_to_image_lora.py \
  --pretrained_model_name_or_path=$MODEL_NAME \
  --dataset_name=$DATASET_NAME \
  --dataloader_num_workers=8 \
  --resolution=512 --center_crop --random_flip \
  --train_batch_size=1 \
  --gradient_accumulation_steps=4 \
  --max_train_steps=15000 \
  --learning_rate=1e-04 \
  --max_grad_norm=1 \
  --lr_scheduler="cosine" --lr_warmup_steps=0 \
  --output_dir=${OUTPUT_DIR} \
  --push_to_hub=False \
  --hub_model_id=${HUB_MODEL_ID} \
  --report_to=wandb \
  --checkpointing_steps=500 \
  --validation_prompt="A pokemon with blue eyes." \
  --seed=1337

exit
