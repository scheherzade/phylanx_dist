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
length=(10 100 1000)
out_channels=(5 10)
filter_length=(5 10 100)


#rm  ${result_dir}/*.dat

for i1 in ${batch[@]}
do
	for i2 in ${length[@]}
	do
		for f1 in ${filter_length[@]}
		do
			if [ $i2 -ge $f1 ]
			then
	        	        for f2 in ${out_channels[@]}
	        	        do
					echo "input ${i1}x${i2}x3 filter ${f1}x${f2}x3"
					touch ${result_dir}/${node_name}_pytorch_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
					rm ${result_dir}/${node_name}_pytorch_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
                	                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run.py ${i1} ${i2} ${f1} ${f2} >>${result_dir}/${node_name}_pytorch_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
				done
			fi
		done
	done
done
