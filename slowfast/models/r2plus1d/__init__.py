"""Implemented R(2 + 1)D network."""

from os.path import isfile

import torch
import torch.nn as nn
import torchvision.models.video as models

from slowfast.models import head_helper
from slowfast.models.r2plus1d import video_resnet


class R2Plus1D(nn.Module):
    """R(2+1)D Baseline"""

    def __init__(self, cfg):
        """
        The `__init__` method of any subclass should also contain these
            arguments.

        Args:
            cfg (CfgNode): model building configs, details are in the
                comments of the config file.
        """
        super(R2Plus1D, self).__init__()
        self.num_pathways = 1
        self._construct_network(cfg)

    def _construct_network(self, cfg):
        """
        R(2 + 1)D

        Args:
            cfg (CfgNode): model building configs, details are in the
                comments of the config file.
        """

        # define the encoder
        pretrained = cfg.MODEL.get("PRETRAINED", True)
        self.encoder = video_resnet.__dict__[cfg.MODEL.ARCH](pretrained=pretrained)

        # temporary hardcoding
        # Temporal pooling: [n_frames // 8, 1, 1]
        # this is because R2+1D18 reduces the T dimension by a factor of 8
        assert cfg.DATA.NUM_FRAMES > 8, "Temporal pooling requires NUM_FRAMES > 8.\
            Current NUM_FRAMES = {}".format(cfg.DATA.NUM_FRAMES)

        self.head = head_helper.ResNetRoIHead(
            dim_in=[512],
            num_classes=cfg.MODEL.NUM_CLASSES,
            # pool_size=[[cfg.DATA.NUM_FRAMES // 8, 1, 1]],
            pool_size=[[cfg.DATA.NUM_FRAMES // 8, 1, 1]],
            resolution=[[cfg.DETECTION.ROI_XFORM_RESOLUTION] * 2],
            scale_factor=[cfg.DETECTION.SPATIAL_SCALE_FACTOR],
            dropout_rate=cfg.MODEL.DROPOUT_RATE,
            act_func=cfg.MODEL.HEAD_ACT,
            aligned=cfg.DETECTION.ALIGNED,
        )

    def forward(self, x, bboxes=None):

        # y = [] # Don't modify x list in place due to activation checkpoint.
        # for pathway in range(self.num_pathways):
        #     y.append(self.encoder(x[pathway]))
        # x = self.head(y, bboxes)

        for pathway in range(self.num_pathways):
            x[pathway] = self.encoder(x[pathway])
        x = self.head(x, bboxes)

        return x

    def freeze_fn(self, freeze_mode):

        if freeze_mode == 'bn_parameters':
            print("Freezing all BN layers\' parameters.")
            for m in self.modules():
                if isinstance(m, nn.BatchNorm3d):
                    # shutdown parameters update in frozen mode
                    m.weight.requires_grad_(False)
                    m.bias.requires_grad_(False)
        elif freeze_mode == 'bn_statistics':
            print("Freezing all BN layers\' statistics.")
            for m in self.modules():
                if isinstance(m, nn.BatchNorm3d):
                    # shutdown running statistics update in frozen mode
                    m.eval()


if __name__ == "__main__":
    
    from tools.run_net import parse_args, load_config

    # load cfg
    from os.path import join, abspath
    args = parse_args()
    args.cfg_file = join(abspath(__file__), "../../../../configs/AVA/R2PLUS1D/16x4_R18_SHORT_v2.2.yaml")
    cfg = load_config(args)

    # set number of frames
    cfg.DATA.NUM_FRAMES = 32

    # load model
    model = R2Plus1D(cfg)

    x = torch.randn(1, 3, cfg.DATA.NUM_FRAMES, 112, 112)
    # 5 boxes for the 1st sample
    boxes = torch.randn(5, 4)
    boxes = torch.hstack([torch.zeros(5).view((-1, 1)), boxes])
    y = model([x], boxes)
    assert y.shape == torch.Size([5, 80])

    # set number of frames
    cfg.DATA.NUM_FRAMES = 16

    # load model
    model = R2Plus1D(cfg)

    x = torch.randn(1, 3, cfg.DATA.NUM_FRAMES, 256, 256)
    # 5 boxes for the 1st sample
    boxes = torch.randn(5, 4)
    boxes = torch.hstack([torch.zeros(5).view((-1, 1)), boxes])
    y = model([x], boxes)
    assert y.shape == torch.Size([5, 80])
