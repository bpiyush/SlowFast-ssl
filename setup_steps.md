### Clone the repository

### Install the dependencies

### Data preparation for AVA

Overall, the data preparation for AVA takes about 20 hours.

1. Symlink the data folder
```sh
cd /path/to/repo/
mkdir -p data

# example: /ssd/pbagad/datasets/AVA
export ROOT_DATA_DIR=/path/to/where/you/want/to/store/AVA-dataset

# symlink
ln -s $ROOT_DATA_DIR data/ava/
```

2. Download: This step takes about 3.5 hours.
```sh
cd scripts/prepare-ava/
bash download_data.sh
```

3. Cut each video from its 15th to 30th minute: This step takes about 14 hours.
```sh
bash cut_videos.sh
```

4. Extract frames: This step takes about 1 hour.
```sh
bash extract_frames.sh
```

5. Download annotations: This step takes about 30 minutes.
```sh
bash download_annotations.sh
```

6. Setup exception videos that may have failed the first time. For me, there was this video `I8j6Xq2B5ys.mp4` that failed the first time. See `scripts/prepare-ava/exception.sh` to re-run the steps for such videos.

### Data preparation for Charades

This, overall, takes about 2 hours.

1. Symlink the data folder
```sh
ln -s /ssd/pbagad/datasets/charades data/charades
```

2. Download and unzip RGB frames
```sh
cd scripts/prepare-charades/
bash download_data.sh
```

3. Download the split files
```sh
bash download_annotations.sh
```