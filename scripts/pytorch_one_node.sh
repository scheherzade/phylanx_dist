#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa 
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2
#num_cores=40

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"


batch=(100000)
length=(1000)
out_channels=(10)
filter_length=(100)

thr=(1 4 8 16 24 32 40)
export PATH=${phylanx_bin_dir}:$PATH

#rm  ${result_dir}/*.dat

for num_cores in ${thr[@]}
do
export OMP_NUM_THREADS=${num_cores}

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
						touch ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
						rm ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
	                	                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run.py ${b} ${l} ${fl} ${oc} >>${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
					done
				fi
			done
		done
	done
done

