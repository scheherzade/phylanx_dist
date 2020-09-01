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

cpp_dir='/home/shahrzad/repos/phylanx_dist/data/phylanx_master'
impl_dir='/home/shahrzad/repos/phylanx_dist/data/phylanx_impl'
pytorch_dir='/home/shahrzad/repos/phylanx_dist/data/pytorch_rerun'

dirs=[cpp_dir, impl_dir, pytorch_dir]
results=dp.read_files(dirs)

dp.validate_output_size(results)

dp.plot_num_nodes(results,mode='time')
dp.plot_batch(results)
dp.plot_length(results)
dp.plot_f_length(results)
dp.plot_f_out(results)

results_one_node_first_run=dp.read_one_node('/home/shahrzad/repos/phylanx_dist/data/results_one_node')
dp.plot_one_node_speedup(results_one_node_first_run)
dp.plot_one_node_time(results_one_node_first_run)

results_one_node=dp.read_one_node('/home/shahrzad/repos/phylanx_dist/data/results_one_node_impl_rerun')
dp.plot_one_node_speedup(results_one_node)
dp.plot_one_node_time(results_one_node)
