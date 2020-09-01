#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 24 00:40:21 2020

@author: shahrzad
"""
import os
import tempfile
import torch
import torch.distributed as dist
import torch.nn as nn
import torch.optim as optim
import torch.multiprocessing as mp
import time
from torch.nn.parallel import DistributedDataParallel as DDP

import argparse
import sys

if not len(sys.argv) == 6 :
    print("This program requires the following 4 arguments seperated by a space, channel is set to 3 by default ")
    print("batch length kernel_size out_channels")
    exit(-57)

parser = argparse.ArgumentParser(description='Parameters')
parser.add_argument('integers', type=int, nargs=5,
                    help='batch, length, kernel_size, out_channels')


args = parser.parse_args()
#print("Command Line: " ,args.integers[0], args.integers[1], args.integers[2], args.integers[3])

batch = args.integers[0]
length = args.integers[1]
kernel_size = args.integers[2]
out_channels = args.integers[3]
num_cores = args.integers[4]

def setup(rank, world_size):
    os.environ["CUDA_VISIBLE_DEVICES"]=""
    os.environ['MASTER_ADDR'] = '10.242.35.38' 
    os.environ['MASTER_PORT'] = '12355'
    print("setup",rank,world_size)
    # initialize the process group
    dist.init_process_group("gloo", rank=rank, world_size=world_size)


def cleanup():
    dist.destroy_process_group()
    
class ToyModel(nn.Module):
    def __init__(self):
        super(ToyModel, self).__init__()
        self.net1 = nn.Conv1d(in_channels=3,out_channels=out_channels, kernel_size=kernel_size, bias=False)

    def forward(self, x):
        return self.net1(x)


def demo_basic(rank, world_size):
    print(f"Running basic DDP example on rank {rank}.")
    setup(rank, world_size)

    # create model and move it to GPU with id rank
    model = ToyModel()
    ddp_model = DDP(model, device_ids=None, output_device=None)
#    loss_fn = nn.MSELoss()
#    optimizer = optim.SGD(ddp_model.parameters(), lr=0.001)
#
#    optimizer.zero_grad()

    input=torch.randn((batch, 3, length),requires_grad=False) 
    t=time.time()
    outputs = ddp_model(input)
    print(time.time()-t)

#    labels = torch.randn(20, 5).to(rank)
#    loss_fn(outputs, labels).backward()
#    optimizer.step()
    cleanup()


def run_demo(demo_fn, world_size):
    mp.spawn(demo_fn,
             args=(world_size,),
             nprocs=world_size,
             join=True)

if __name__ == "__main__":    
    t1=time.time()
    run_demo(demo_basic, num_cores)
    print(time.time() - t1)
