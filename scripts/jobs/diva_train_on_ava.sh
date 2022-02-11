# helper script to run sample training run
parent="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
repo="$( dirname $(dirname $parent))"
export PYTHONPATH=$repo

# get inputs from the user
while getopts "c:n:b:" OPTION; do
    case $OPTION in
        c) cfg=$OPTARG;;
        n) num_gpus=$OPTARG;;
        b) batch_size=$OPTARG;;
        *) exit 1 ;;
    esac
done

# check cfg is given
if [ "$cfg" ==  "" ];then
       echo "cfg is a required argument; Please use -c <relative path to config> to pass config file."
       echo "You can choose configs from:"
       ls $repo/configs/*
       exit
fi

# set number of GPUs as 4 if not specified
if [ "$num_gpus" ==  "" ];then
       num_gpus=4
fi

# set batch size as 60 if not specified
if [ "$batch_size" ==  "" ];then
       batch_size=60
fi

# set num workers to be 2
num_workers=2

echo "::::::::::::::: Running training for $cfg :::::::::::::::"

# configure output paths
expt_folder="${cfg%.yaml}"
IFS='/' read -r -a array <<< $expt_folder
expt_folder="${array[-2]}--${array[-1]}"
output_dir=/ssd/pbagad/expts/SlowFast-ssl/$expt_folder/
mkdir -p $output_dir
logs_dir=$output_dir/logs/
mkdir -p $logs_dir

# configure data paths
FRAME_DIR="/ssd/pbagad/datasets/AVA/frames/"
FRAME_LIST_DIR="/ssd/pbagad/datasets/AVA/annotations/"
ANNOTATION_DIR="/ssd/pbagad/datasets/AVA/annotations/"

# display metadata
echo ":: Output dir: "$output_dir
echo ":: Data picked from: $(dirname $FRAME_DIR)"
echo ":: Number of GPUs: $num_gpus"
echo ":: Batch size: $batch_size"
echo ":: Number of workers: $num_workers"
echo ":: Repository: $repo"

# run training
python tools/run_net.py \
    --cfg $cfg \
    --init_method tcp://localhost:9998 \
    NUM_GPUS $num_gpus \
    TRAIN.BATCH_SIZE $batch_size \
    DATA_LOADER.NUM_WORKERS $num_workers \
    OUTPUT_DIR $output_dir \
    AVA.FRAME_DIR $FRAME_DIR \
    AVA.FRAME_LIST_DIR $FRAME_LIST_DIR \
    AVA.ANNOTATION_DIR $ANNOTATION_DIR \
    TEST.BATCH_SIZE $num_gpus \
    > $logs_dir/train_logs.txt 