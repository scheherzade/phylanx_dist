import argparse
import sys

parser = argparse.ArgumentParser(description='Parameters')

if len(sys.argv) not in [5, 6]:
    print("This program requires the following 4 or 5 arguments seperated by a space, channel is set to 3 by default if 4 arguments provided ")
    print("batch length kernel_size out_channels in_channels")
    exit(-57)


parser.add_argument('integers', type=int, nargs=len(sys.argv)-1,
                    help='batch, length, kernel_size, out_channels')

args = parser.parse_args()
#print("Command Line: " ,args.integers[0], args.integers[1], args.integers[2], args.integers[3])

batch = args.integers[0]
length = args.integers[1]
out_channels = args.integers[2]
kernel_size = args.integers[3]

if len(sys.argv)==6:
    in_channels = args.integers[4]
else:
    in_channels=3

import torch.distributed as dist
import torch.nn.parallel as par  
import torch.nn as nn
import torch
import time
import numpy as np

#torch.set_num_threads(40)
a=np.random.rand(batch, in_channels, length)
array = torch.tensor(a).float()
conv1 = nn.Conv1d(in_channels=in_channels,out_channels=out_channels, kernel_size=kernel_size, bias=False)

t_start = time.time()
out = conv1(array).double()
t_end = time.time()
t = t_end-t_start 
print(t)
print("output size:", out.size())
