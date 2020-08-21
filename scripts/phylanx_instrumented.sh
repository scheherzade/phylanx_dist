#!/bin/bash
node_name=$1
#num_nodes=$2
num_nodes=(2 4 8)
result_dir="/work/sshirzad/phylanx_dist/results"
script_dir="/work/sshirzad/phylanx_dist/scripts"
#rm -rf ${result_dir}/*.dat
for nn in ${num_nodes[@]}
do
	echo "running on ${node_name} on ${nn} nodes"
	sbatch ${script_dir}/cpp_instrumented.sh ${node_name} ${nn}
	echo "finished"
done

