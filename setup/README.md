

## Setup

* Create conda environment and install dependencies:
    ```sh
    bash setup/create_env.sh slowfast-charades
    ```
    This will create and activate a conda environment called `slowfast-charades`.
    Please activate it for further steps.
    ```sh
    conda activate slowfast-charades
    ```
* Symlink the dataset folder. Suppose Charades and AVA datasets are stored inside `/path/to/datasets/`. Then, run the following from the repo:
    ```sh
    ln -s /path/to/datasets data
    ```
* Symlink the pre-trained models for initialization. Suppose all your VSSL pre-trained checkpoints are at `/path/to/checkpoints_pretraining`
    ```sh
    ls -s /path/to/checkpoints_pretraining checkpoints_pretraining
    ```


## Experiments on Charades

### Fine-tuning a pre-trained VSSL model

To run fine-tuning on Charades, using `r2plus1d_18` backbone initialized from Kinetics-400 supervised pretraining, we use the following command(s):
```sh
conda activate slowfast-charades
cd /path/to/repo/
export PYTHONPATH=$PWD

cfg=configs/Charades/VSSL/32x8_112x112_R18_supervised.yaml
bash scripts/jobs/train_on_charades.sh -c $cfg
```
This assumes that you have setup data folders symlinked into the repo. This shall save outputs in `./outputs/` folder. You can check `./outputs/<expt-folder-name>/logs/train_logs.txt` to see the training progress.


### Evaluating a fine-tuned VSSL model
