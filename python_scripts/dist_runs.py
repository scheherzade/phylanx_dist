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

directory='/home/shahrzad/repos/phylanx_dist/phylanx_results'
data_files=glob.glob(directory+'/*.dat')

configs=[]
results={}
for filename in data_files:
    (node, run_type, batch, length, k_length, k_out, num_nodes) = filename.split('/')[-1].replace('.dat','').split('_')    
    f=open(filename, 'r')
    data=f.readlines()
    if len(data)>0:
        data=[float(d.split(': ')[1].split('\n')[0]) for d in data]
        
        if node not in results.keys():
            results[node]={}
        if run_type not in results[node].keys():
            results[node][run_type]={}
        if batch+'-'+length+'-'+k_length+'-'+k_out not in results[node][run_type].keys():
            results[node][run_type][batch+'-'+length+'-'+k_length+'-'+k_out]=max(data)
            configs.append(batch+'-'+length+'-'+k_length+'-'+k_out)
            

for node in results.keys():            
    physl_data=[results[node]['physl'][k] for k in configs]    
    instrumented_data=[results[node]['instrumented'][k] for k in configs]
    plt.scatter(configs,physl_data,marker='.',label='physl')
    plt.scatter(configs,physl_data,marker='.',label='instrumented')
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
