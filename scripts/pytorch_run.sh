#!/bin/bash

#SBATCH -N 2 
#SBATCH -p medusa
#SBATCH --time=72:00:00
#SBATCH -w medusa[07-08]

node_name=$1
num_nodes=$2
#num_cores=40

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
input1=(10 100 1000 10000 100000 50 500 5000 50000)
#input1=(50 500 5000 50000)
input1=(100)
input2=(10 100 1000)
#input2=(5000 50000)
input2=(50)
filter1=(5 10 500)
filter1=(10)
filter2=(5)
#filter2=(1 2 5 20 10 100)

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
                	                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run_dist.py ${i1} ${i2} ${f1} ${f2} ${num_nodes}>>${result_dir}/${node_name}_pytorch_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
				done
			fi
		done
	done
done
