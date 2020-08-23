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

directory='/home/shahrzad/repos/phylanx_dist/all_results'
data_files=glob.glob(directory+'/*.dat')
configs=[]
results={}

for filename in data_files:
    (node, run_type, batch, length, k_length, k_out, num_nodes) = filename.split('/')[-1].replace('.dat','').split('_')    
    num_nodes=int(num_nodes)
    f=open(filename, 'r')
    data=f.readlines()
    if len(data)>0:
        if run_type=='pytorch':
            d_time=[float(data[0].replace('\n',''))]
            d_size=data[1].split('[')[1].split('])\n')[0]
        else:
            d_time=[float(d.split(': ')[1].split('\n')[0]) for d in data if ':' in d]        
            if run_type=='physl' and len(data)>num_nodes:
                d_size=data[-1].split('(')[1].split(')\n')[0]
            else:
                d_size=""
                        
        if node not in results.keys():
            results[node]={}
        if num_nodes not in results[node].keys():
            results[node][num_nodes]={}
        config=batch+'-'+length+'-'+k_length+'-'+k_out
        if config not in results[node][num_nodes].keys():
            results[node][num_nodes][config]={}
            configs.append(config)
        if run_type not in results[node][num_nodes][config].keys():
            results[node][num_nodes][config][run_type]={'time':max(d_time), 'size':d_size}

plot_dir='/home/shahrzad/repos/phylanx_dist/plots'
#comparison of different runs pytorch and physl            
j=1
for node in results.keys():     
    for no in results[node].keys():
        run_types=['physl','instrumented','pytorch']
        all_results=[]
        plt.figure(j)
        plt.axes([0, 0, 2, 1])
        for config in results[node][no].keys():
            rs=[]
            for run_type in run_types:
                if run_type in results[node][no][config].keys():
                    rs.append(results[node][no][config][run_type]['time'])
                else:
                    rs.append(0)
                all_results.append(rs)            
                
        for run_type in run_types:     
            results_r=[all_results[i][run_types.index(run_type)] for i in range(len(all_results)) if all_results[i][run_types.index(run_type)]!=0]
            plt.scatter([i for i in range(len(results_r))], results_r,marker='.',label=run_type)
       
        plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
        plt.title("run on "+node+" on "+str(no)+" nodes")
        plt.savefig(plot_dir+'/all_configs/'+node+'_'+str(no),bbox_inches='tight')
        j=j+1


#comparison of different runs different nodes          
j=1
for node in results.keys():    
    run_types=['instrumented','pytorch']
    num_nodes=[k for k in results[node].keys()]
    num_nodes.sort()
    configs=[k for k in results[node][1].keys()]
    configs.sort()
    
    for config in configs:
        plt.figure(j)                 
        for run_type in run_types:            
            plt.scatter([k for k in num_nodes if k in results[node].keys() and config in results[node][k] and run_type in results[node][k][config]], [results[node][k][config][run_type]['time'] for k in num_nodes if k in results[node].keys() and config in results[node][k] and run_type in results[node][k][config]], marker='.', label=run_type)
                      
        plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
        plt.title("run on "+node+" "+config)
        plt.savefig(plot_dir+'/based_on_num_nodes/'+node+'_'+config,bbox_inches='tight')
        j=j+1
                
        
#effect of batch size        
j=1
for node in results.keys():    
    run_types=['instrumented','pytorch']
    num_nodes=[k for k in results[node].keys()]
    configs=[k for k in results[node][1].keys()]
    num_nodes.sort()
    configs.sort()
    
    not_batches=list(set(['-'.join([config.split('-')[i] for i in range(len(config.split('-'))) if i!=0]) for config in configs]))

    for nbatch in not_batches:        
        for no in num_nodes:
            p1_batches=[c for c in results[node][no].keys() if c.endswith('-'+nbatch)]
            p1_batches.sort()

            plt.figure(j)                 
            for run_type in run_types:            
                plt.scatter([p1.split('-')[0] for p1 in p1_batches if run_type in results[node][no][p1].keys()],[results[node][no][p1][run_type]['time'] for p1 in p1_batches if run_type in results[node][no][p1].keys()], marker='.', label=run_type)
                                            
            plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
            plt.title("run on "+node+" on "+str(no)+" nodes "+nbatch)
            plt.xlabel('batch size')
            plt.savefig(plot_dir+'/based_on_batches/'+node+'_'+str(no)+'_'+nbatch,bbox_inches='tight')

            j=j+1
            
            
#effect of batch length       
j=1
for node in results.keys():    
    run_types=['instrumented','pytorch']
    num_nodes=[k for k in results[node].keys()]
    configs=[k for k in results[node][1].keys()]
    num_nodes.sort()
    configs.sort()
    
    not_batches=list(set(['-'.join([config.split('-')[i] for i in range(len(config.split('-'))) if i!=1]) for config in configs]))

    for nbatch in not_batches:        
        for no in num_nodes:
            p1_batches=[c for c in results[node][no].keys() if '-'.join([c.split('-')[i] for i in range(len(c.split('-'))) if i!=1])==nbatch]
            p1_batches.sort()
      
            plt.figure(j)                 
            for run_type in run_types:            
                plt.scatter([p1.split('-')[1] for p1 in p1_batches if run_type in results[node][no][p1].keys()],[results[node][no][p1][run_type]['time'] for p1 in p1_batches if run_type in results[node][no][p1].keys()], marker='.', label=run_type)
                                            
            plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
            plt.title("run on "+node+" on "+str(no)+" nodes "+nbatch)
            plt.xlabel('length')
            plt.savefig(plot_dir+'/based_on_length/'+node+'_'+str(no)+'_'+nbatch,bbox_inches='tight')

            j=j+1
            
            
#effect of batch length       
j=1
for node in results.keys():    
    run_types=['instrumented','pytorch']
    num_nodes=[k for k in results[node].keys()]
    configs=[k for k in results[node][1].keys()]
    num_nodes.sort()
    configs.sort()
    
    not_batches=list(set(['-'.join([config.split('-')[i] for i in range(len(config.split('-'))) if i!=2]) for config in configs]))

    for nbatch in not_batches:        
        for no in num_nodes:
            p1_batches=[c for c in results[node][no].keys() if '-'.join([c.split('-')[i] for i in range(len(c.split('-'))) if i!=2])==nbatch]
            p1_batches.sort()
      
            plt.figure(j)                 
            for run_type in run_types:            
                plt.scatter([p1.split('-')[2] for p1 in p1_batches if run_type in results[node][no][p1].keys()],[results[node][no][p1][run_type]['time'] for p1 in p1_batches if run_type in results[node][no][p1].keys()], marker='.', label=run_type)
                                            
            plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
            plt.title("run on "+node+" on "+str(no)+" nodes "+nbatch)
            plt.xlabel('lfilter_ength')
            plt.savefig(plot_dir+'/based_on_filter_length/'+node+'_'+str(no)+'_'+nbatch,bbox_inches='tight')

            j=j+1
            
            
#effect of batch filter_out      
j=1
for node in results.keys():    
    run_types=['instrumented','pytorch']
    num_nodes=[k for k in results[node].keys()]
    configs=[k for k in results[node][1].keys()]
    num_nodes.sort()
    configs.sort()
    
    not_batches=list(set(['-'.join([config.split('-')[i] for i in range(len(config.split('-'))) if i!=3]) for config in configs]))

    for nbatch in not_batches:        
        for no in num_nodes:
            p1_batches=[c for c in results[node][no].keys() if '-'.join([c.split('-')[i] for i in range(len(c.split('-'))) if i!=3])==nbatch]
            p1_batches.sort()
      
            plt.figure(j)                 
            for run_type in run_types:            
                plt.scatter([p1.split('-')[3] for p1 in p1_batches if run_type in results[node][no][p1].keys()],[results[node][no][p1][run_type]['time'] for p1 in p1_batches if run_type in results[node][no][p1].keys()], marker='.', label=run_type)
                                            
            plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
            plt.title("run on "+node+" on "+str(no)+" nodes "+nbatch)
            plt.xlabel('out_channel')
            plt.savefig(plot_dir+'/based_on_out_channel/'+node+'_'+str(no)+'_'+nbatch,bbox_inches='tight')

            j=j+1