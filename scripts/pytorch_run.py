import torch.distributed as dist
import torch.nn.parallel as par  
import torch.nn as nn
import torch
import time

#torch.set_num_threads(1)

array = torch.rand(180000,3,400)
conv1 = nn.Conv1d(in_channels=3,out_channels=100,kernel_size=10)

t_start = time.time()
out = conv1(array)
t_end = time.time()
t = t_end-t_start 
print(t)
