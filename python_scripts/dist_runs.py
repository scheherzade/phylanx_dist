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

directory='/home/shahrzad/repos/phylanx_dist/all_results'
results=dp.read_files(directory)

dp.plot_num_nodes(results)
dp.plot_batch(results)
dp.plot_length(results)
dp.plot_f_length(results)
dp.plot_f_out(results)


results_one_node=dp.read_one_node()
dp.plot_one_node(results_one_node)
