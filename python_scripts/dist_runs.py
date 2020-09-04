#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 21 12:43:56 2020

@author: shahrzad
"""

import csv
import glob
import numpy as np
import matplotlib.pyplot as plt
import dist_plots as dp


dirs=['all_modes','pytorch','pytorch_allocate']
alias=['shahrzad','bita','master','pytorch','pytorch_alloc']
#results=dp.read_files(dirs,mode='dirs')

modes=['shahrzad','bita','master','pytorch','pytorch-alloc']
results=dp.read_files(dirs,modes,mode='run_type')

dp.plot_num_nodes(results,dirs,mode='speedup')
dp.plot_num_nodes(results,dirs,mode='time')
dp.plot_batch(results,modes)









cpp_dir='/home/shahrzad/repos/phylanx_dist/data/phylanx_master'
impl_dir='/home/shahrzad/repos/phylanx_dist/data/phylanx_impl'
pytorch_dir='/home/shahrzad/repos/phylanx_dist/data/pytorch_rerun'

dirs=['master', 'impl', 'pytorch_rerun','bita_modified']
results=dp.read_files(dirs)

dp.validate_output_size(results)

dp.plot_num_nodes(results,dirs,mode='speedup')
dp.plot_batch(results,dirs)
dp.plot_length(results)
dp.plot_f_length(results)
dp.plot_f_out(results)

dirs=['bita_modified']
results_one_node=dp.read_one_node(dirs)
for node in results_one_node.keys():
    for num_nodes in results_one_node[node].keys():
        for config in results_one_node[node][num_nodes]:
            run_types=[rt for rt in results_one_node[node][num_nodes][config].keys()]
            size_ref=results_one_node[node][num_nodes][config][run_types[0]][1]['size']
            if size_ref=="":
                size_ref=results_one_node[node][num_nodes][config][run_types[1]][1]['size']

            for run_type in run_types:
                size_1=results_one_node[node][num_nodes][config][run_type][1]['size']
                if size_1!="":
                    for num_cores in results_one_node[node][num_nodes][config][run_type].keys():
                        size_i=results_one_node[node][num_nodes][config][run_type][num_cores]['size']
                        if size_i!=size_1 or size_i!=size_ref:
                            print('error', config, run_type, size_1, size_i, size_ref,num_cores)
                            


dp.plot_one_node_speedup(results_one_node,dirs)
dp.plot_one_node_time(results_one_node,dirs)
