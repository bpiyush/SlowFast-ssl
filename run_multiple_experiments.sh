cfg_1=configs/Charades/VSSL/32x8_112x112_R18_gdt_seed_1.yaml
cfg_2=configs/Charades/VSSL/32x8_112x112_R18_gdt_seed_2.yaml
cfg_3=configs/Charades/VSSL/32x8_112x112_R18_gdt_seed_3.yaml

CUDA_VISIBLE_DEVICES=0 bash scripts/jobs/train_on_charades.sh -c $cfg_1 -b 16 -n 1 &
CUDA_VISIBLE_DEVICES=1 bash scripts/jobs/train_on_charades.sh -c $cfg_2 -b 16 -n 1 &
CUDA_VISIBLE_DEVICES=2 bash scripts/jobs/train_on_charades.sh -c $cfg_3 -b 16 -n 1
