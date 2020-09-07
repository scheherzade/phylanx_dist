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
length=(500)
out_channels=(100)
filter_length=(20)

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
	           			for r in {1..6}
                                        do
						echo "input ${b}x${l}x3 filter ${oc}x${fl}x3 ${r} run"
						touch ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${r}.dat
						rm ${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${r}.dat
                		                srun -p ${node_name} -N ${num_nodes}  python3 pytorch_run.py ${b} ${l} ${oc} ${fl} >>${result_dir}/${node_name}_pytorch_${b}_${l}_${oc}_${fl}_${num_nodes}_${r}.dat
					done
				done
			fi
		done
	done
done
