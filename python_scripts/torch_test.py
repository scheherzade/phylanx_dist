#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 13:56:55 2020

@author: shahrzad
"""

"""run.py:"""
#!/usr/bin/env python
import os
import torch
import torch.distributed as dist
from torch.multiprocessing import Process
import torch.nn as nn

def run(rank, size):
    """ Distributed function to be implemented later. """
    pass

def init_process(rank, size, fn, backend='gloo'):
    """ Initialize the distributed environment. """
    os.environ['MASTER_ADDR'] = '127.0.0.1'
    os.environ['MASTER_PORT'] = '29500'
    dist.init_process_group(backend, rank=rank, world_size=size)
    fn(rank, size)


if __name__ == "__main__":
    size = 2
    processes = []
    for rank in range(size):
        p = Process(target=init_process, args=(rank, size, run))
        p.start()
        processes.append(p)

    for p in processes:
        p.join()
        
@torch.no_grad()
def init_weights(m):
    print(m)
    if type(m) == nn.Linear:
        m.weight.fill_(1.0)
        print(m.weight)
        
net = nn.Sequential(nn.Linear(2, 2), nn.Linear(2, 2))
net.apply(init_weights)


with torch.no_grad():
    array = torch.rand(10, 3, 5,requires_grad=True)
net = nn.Conv1d(in_channels=3,out_channels=2, kernel_size=4, bias=False)
out=net(array)

def init_weights(m):
    array = torch.rand(10, 3, 5,requires_grad=True)
    out=m(array)
    return out
#    print(m)
#    if type(m) == nn.Conv1d:
#        m.weight.fill_(1.0)
#        print(m.weight)
        
net = nn.Conv1d(in_channels=3,out_channels=2, kernel_size=4, bias=False)
a=net.apply(init_weights)

conv1 = nn.Conv1d(in_channels=3,out_channels=2, kernel_size=10, bias=False)
conv1d.apply(init_weights)