
import importlib
import fire
import os
import copy
import torch

from _path_init import *
from visualDet3D.networks.utils.registry import DETECTOR_DICT, DATASET_DICT, PIPELINE_DICT
from visualDet3D.utils.utils import cfg_from_file

print('CUDA available: {}'.format(torch.cuda.is_available()))

def main(config: str = "config/config.py",
         gpu: int = 0,
         checkpoint_path: str = "resnet34-333f7ec4.pth"):
    # Read Config
    cfg = cfg_from_file(config)

    # Force GPU selection in command line
    cfg.trainer.gpu = gpu
    torch.cuda.set_device(cfg.trainer.gpu)

    # Create the model
    detector = DETECTOR_DICT[cfg.detector.name](cfg.detector)
    detector = detector.cuda()

    state_dict = torch.load(checkpoint_path, map_location='cuda:{}'.format(cfg.trainer.gpu))
    new_dict = state_dict.copy()
    detector.load_state_dict(new_dict, strict=False)
    detector.eval()

    if 'evaluate_func' in cfg.trainer:
        evaluate_detection = PIPELINE_DICT[cfg.trainer.evaluate_func]
        print("Found evaluate function")
    else:
        raise KeyError("evluate_func not found in Config")

    # Run evaluation
    evaluate_detection(cfg, detector, dataset, None, 0, result_path_split=split_to_test)
    print('finish')


if __name__ == '__main__':
    fire.Fire(main)
