#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 20
#SBATCH --mem 300G
#SBATCH --partition gpu
#SBATCH --gpus-per-node=2
#SBATCH --gres gpu:2
#SBATCH --qos dlav
#SBATCH --account civil-459-2023
#SBATCH --time=60:00:00

module load gcc/8.4.0-cuda python/3.7.7 cuda/11.1.1
source /home/ceren/pan_bev_4/bin/activate

CUDA_VISIBLE_DEVICES=0 \
python3 -m torch.distributed.launch --nproc_per_node=1 --master_addr=$(hostname -I | cut -d ' ' -f 1
) --master_port=$(python3 get_port.py) eval_panoptic_bev.py \
                                    --run_name=test5 \
                                    --project_root_dir=/home/ceren/PanopticBEV \
                                    --seam_root_dir=/home/ceren/PanopticBEV/data/nuScenes_panopticbev\
                                    --dataset_root_dir=/work/scitas-share/datasets/Vita/civil-459/NuScenes_full/US \
                                    --mode=test \
                                    --test_dataset=nuScenes \
                                    --resume=/home/ceren/PanopticBEV/experiments/bev_train_run14/saved_models/model_latest.pth \
                                    --config=nuscenes.ini \
