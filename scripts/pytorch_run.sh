#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
input1=(10 100 1000 10000 100000)
input2=(10 100 1000)
filter1=(10 50)
filter2=(10 50 100)

#rm  ${result_dir}/*.dat

for i1 in ${input1[@]}
do
	for i2 in ${input2[@]}
	do
		for f1 in ${filter1[@]}
		do
			if [ $i2 -ge $f1 ]
			then
	        	        for f2 in ${filter2[@]}
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
