

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


<!-- * Create and activate conda environment
    ```sh
    conda create -y -n vssl python=3.7
    conda activate vssl
    ```
* Install requirements
    ```sh
    pip install -r setup/requirements-v2.0.txt
    ```
    > `requirements-v1.0.txt` is the requirements without `av` installed.

    > `requirements-v2.0.txt` is the requirements for the latest version of the `av` installed.

* Install additional requirements (for `SlowFast-ssl` repo).
    ```sh
    pip install simplejson
    pip install iopath
    pip install psutil
    pip install opencv-python
    pip install tensorboard
    pip install pytorchvideo
    # pip install 'git+https://github.com/facebookresearch/fairscale'
    ``` -->