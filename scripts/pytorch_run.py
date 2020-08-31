import argparse
import sys

if not len(sys.argv) == 5 :
    print("This program requires the following 4 arguments seperated by a space, channel is set to 3 by default ")
    print("batch length kernel_size out_channels")
    exit(-57)

parser = argparse.ArgumentParser(description='Parameters')
parser.add_argument('integers', type=int, nargs=4,
                    help='batch, length, kernel_size, out_channels')


args = parser.parse_args()
#print("Command Line: " ,args.integers[0], args.integers[1], args.integers[2], args.integers[3])

batch = args.integers[0]
length = args.integers[1]
kernel_size = args.integers[3]
out_channels = args.integers[2]

import torch.distributed as dist
import torch.nn.parallel as par  
import torch.nn as nn
import torch
import time

#torch.set_num_threads(40)

array = torch.rand(batch, 3, length)
conv1 = nn.Conv1d(in_channels=3,out_channels=out_channels, kernel_size=kernel_size, bias=False)

t_start = time.time()
out = conv1(array)
t_end = time.time()
t = t_end-t_start 
print(t)
print("output size:", out.size())
