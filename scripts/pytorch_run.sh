#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa 
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2
#num_cores=40

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"

batch=(10 100 1000 10000 100000)
length=(10 100 1000 5000)
out_channels=(100 500)
filter_length=(5 10 20)


rm  ${result_dir}/*.dat

for b in ${batch[@]}
do
	for l in ${length[@]}
	do
		for fl in ${filter_length[@]}
		do
			if [ $l -ge $fl ]
			then
	        	        for oc in ${out_channels[@]}
	        	        do
					echo "input ${b}x${l}x3 filter ${oc}x${fl}x3"
					touch ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}.dat
					rm ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}.dat
                	                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run.py ${b} ${l} ${oc} ${fl} >>${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}.dat
				done
			fi
		done
	done
done
