#!/bin/bash          
CFG="B"
CUDA_DEVICE=0
#-------> LRS
LR=0.0001
STN_LR=0.0001
STN_LR_HIGH=0.0001
#------> LAMBDAS
EDGE_LAMBDA=0.0
REC_LAMBDA=0.0
L1_LAMBDA=10.0
L2_LAMBDA=0.0
GAN_LAMBDA=1.0
SMOOTH_LAMBDA=50.0
ALPHA_REG=0.0
CYCLE_LAMBDA=0.0
#-------> G CONFIG
NGF=32
N_BLOCKS=3
NET_G="resnet_${N_BLOCKS}blocks"
#-------> D CONFIG
NDF=32
NET_D="basic" #'n_layers' #""
N_LAYERS_D=3
#-------> Train CONFIG
ITTER_DECAY=100
ITTER=100
DISPLAY_FREQ=200
SAVE_EPOCH_FREQ=5
TBVIS_GRAD_UPDATE_RATE=100
DATASET_DIR='/home/moaba/aligning_cyclegan/datasets'
DATASET_NAME="EXP_523" #"agrinet_greenhouse" #"EXP_541" #"EXP_523" #"agrinet_extra_large_data"
MODEL="mirnet"
DIRECTION="AtoB"
DATASET_MODE="agrinet"
BATCH=10
NORM="instance"
NO_DROPOUT="--no_dropout"
INIT_TYPE="kaiming"
DESC_STR="RESNET_${N_BLOCKS}_FLTRS_${NGF}_COMBINED_ALPHA_${ALPHA_REG}_BATCH_${BATCH}"
OUTPUT_NAME="$DATASET_${DATASET_NAME}_CFG_${CFG}_LR_${LR}_STNLR_${STN_LR}_EDGE_${EDGE_LAMBDA}REC_${REC_LAMBDA}_L1_${L1_LAMBDA}_L2_${L2_LAMBDA}_GAN_${GAN_LAMBDA}_SMOOTH_${SMOOTH_LAMBDA}_CYCLE_${CYCLE_LAMBDA}_${DIRECTION}_${DESC_STR}"
TRAIN_WITH_GAN="--stn_train_with_gan"
TRAIN_WITH_L1="--stn_train_with_l1"
G_TRAIN_WITH_L1="" #"" #"--g_train_with_l1"
G_TRAIN_WITH_GAN="" #"--g_train_with_gan"
TRAIN_WITH_EDGE="" #"--stn_train_with_edge"
CONDITION_ON_STN="" #"--stn_condition_on_discriminator"
TBVIS_ENABLE="" #"--tbvis_enable"
if [ $# -eq 0 ]; then
	echo "Initialzed vars"
elif [ "$1" == "run" ]; then
	CUDA_VISIBLE_DEVICES=${CUDA_DEVICE} python train.py --dataroot ${DATASET_DIR}/${DATASET_NAME}/\
	--dataset_mode ${DATASET_MODE} --name ${OUTPUT_NAME} --model ${MODEL}\
	--save_epoch_freq ${SAVE_EPOCH_FREQ} --niter ${ITTER} --niter_decay ${ITTER_DECAY} --direction ${DIRECTION}\
	--display_freq ${DISPLAY_FREQ}  --stn_cfg ${CFG} --netG ${NET_G} --input_nc 3 --output_nc 1 --lambda_L1 ${L1_LAMBDA}\
	--stn_lr ${STN_LR} --stn_lr_high ${STN_LR_HIGH} --lr ${LR} --lambda_stn_reg\
	${SMOOTH_LAMBDA} ${TBVIS_ENABLE} --tbvis_grads_update_rate ${TBVIS_GRAD_UPDATE_RATE} --ngf ${NGF}\
	--batch ${BATCH} --norm ${NORM} --init_type ${INIT_TYPE} ${TRAIN_WITH_GAN} ${TRAIN_WITH_L1} ${TRAIN_WITH_EDGE} ${CONDITION_ON_STN} --ndf ${NDF} \
        --netD ${NET_D} --n_layers_D ${N_LAYERS_D} ${NO_DROPOUT} --alpha_reg ${ALPHA_REG} --checkpoints_dir ./checkpoints \
	${G_TRAIN_WITH_L1}  ${G_TRAIN_WITH_GAN}
elif [ "$1" == "nohup" ]; then
	CUDA_VISIBLE_DEVICES=${CUDA_DEVICE} nohup python train.py --dataroot ${DATASET_DIR}/${DATASET_NAME}/\
	--dataset_mode ${DATASET_MODE} --name ${OUTPUT_NAME} --model ${MODEL} \
	--save_epoch_freq ${SAVE_EPOCH_FREQ} --niter ${ITTER} --niter_decay ${ITTER_DECAY} --direction ${DIRECTION}\
	--display_freq ${DISPLAY_FREQ}  --stn_cfg ${CFG} --netG ${NET_G} --input_nc 3 --output_nc 1 --lambda_L1 ${L1_LAMBDA}\
	--stn_lr ${STN_LR} --stn_lr_high ${STN_LR_HIGH} --lr ${LR} --lambda_stn_reg\
	${SMOOTH_LAMBDA} ${TBVIS_ENABLE} --tbvis_grads_update_rate ${TBVIS_GRAD_UPDATE_RATE} --ngf ${NGF}\
	--batch ${BATCH} --norm ${NORM} --init_type ${INIT_TYPE} ${TRAIN_WITH_GAN} ${TRAIN_WITH_L1} ${TRAIN_WITH_EDGE} ${CONDITION_ON_STN} --ndf ${NDF} \
        --netD ${NET_D} --n_layers_D ${N_LAYERS_D} ${NO_DROPOUT} --alpha_reg ${ALPHA_REG} --checkpoints_dir ./checkpoints\
        ${G_TRAIN_WITH_L1} ${G_TRAIN_WITH_GAN}	&
fi
