# Usage: bash create_conda_env.sh
# Outcome: Creates a conda environment `slowfast` for the project

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
REMOVE_ALL=$(tput sgr0)

echo "::: $YELLOW Checking conda installation ... $REMOVE_ALL"

if ! command -v conda --version &> /dev/null
then
    echo "::: ERROR: conda is not installed"
    exit 1
else
    echo "::: conda is installed with version $(conda --version)"
fi

echo "::: $YELLOW Creating conda environment ... $REMOVE_ALL"
conda create -y -n slowfast python=3.9
conda activate slowfast

echo "::: $YELLOW Installing torch-packages ... $REMOVE_ALL"
# check your apt pytorch version
pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 \
    -f https://download.pytorch.org/whl/torch_stable.html

# install other packages
echo "::: $YELLOW Checking GCC version: $(gcc --version) ... $REMOVE_ALL"
echo "::: $YELLOW Installing other packages ... $REMOVE_ALL"
pip install simplejson
conda install av -y -c conda-forge
conda install -y -c iopath iopath
pip install psutil
pip install opencv-python
pip install tensorboard
conda install -y -c conda-forge moviepy
pip install pytorchvideo
pip install 'git+https://github.com/facebookresearch/fairscale'
pip install -U 'git+https://github.com/facebookresearch/fvcore.git' \
    'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
git clone https://github.com/facebookresearch/detectron2 detectron2_repo
pip install -e detectron2_repo
pip install scikit-learn
pip install pyhocon

echo "::: $GREEN Done! $REMOVE_ALL"

echo "::: $YELLOW Testing the environment: $REMOVE_ALL"
conda activate slowfast
python -c "import torch; print('Torch: 'torch.__version__)"
python -c "import torchvision; print('Torchvision: 'torchvision.__version__)"
python -c "import torchaudio; print('Torchaudio: 'torchaudio.__version__)"
python -c "import detectron2; print('detectron2: 'detectron2.__version__)"