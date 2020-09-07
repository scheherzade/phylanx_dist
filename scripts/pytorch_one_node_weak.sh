#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa 
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2
#num_cores=40

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"

batch=(10000)
length=(100)
out_channels=(100)
filter_length=(20)

thr=(1 4 8 16 24 32 40)
export PATH=${phylanx_bin_dir}:$PATH

#rm  ${result_dir}/*.dat

for num_cores in ${thr[@]}
do
export OMP_NUM_THREADS=${num_cores}

	for rb in ${batch[@]}
	do
	        b=$((num_cores*rb))
		for l in ${length[@]}
		do
			for fl in ${filter_length[@]}
			do
				if [ $l -ge $fl ]
				then
		        	        for oc in ${out_channels[@]}
		        	        do
						echo "input ${b}x${l}x3 filter ${oc}x${fl}x3"
						touch ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
						rm ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
	                	                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run.py ${b} ${l} ${oc} ${fl} >>${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
					done
				fi
			done
		done
	done
done

