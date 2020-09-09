#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa 
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2
#num_cores=40

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
thr=(1 4 8 16 24 32 40)

batch=(100000)
length=(500)
in_channels=3
out_channels=(100)
filter_length=(20)

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
		           			for r in {1..6}
	                                        do
							echo "input ${b}x${l}x${in_channels} filter ${oc}x${fl}x${in_channels} ${r} run"
							touch ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}_${r}_ch${in_channels}.dat
							rm ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}_${r}_ch${in_channels}.dat
	                		                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run.py ${b} ${l} ${oc} ${fl} ${in_channels}>>${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}_${r}_ch${in_channels}.dat
						done
					done
				fi
			done
		done
	done
done
