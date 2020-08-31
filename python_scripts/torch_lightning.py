import os
import torch
import torch.nn.functional as F
from torchvision.datasets import MNIST
from torch.utils.data import DataLoader, random_split
from torchvision import transforms
import pytorch_lightning as pl


trainer = pl.Trainer(cpus=4, num_nodes=2,distributed_backend='horovod')
