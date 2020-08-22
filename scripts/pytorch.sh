#!/bin/bash
node_name=$1
result_dir="/work/sshirzad/phylanx_dist/results"
script_dir="/work/sshirzad/phylanx_dist/scripts"
filename=${script_dir}/pytorch_run.sh

num_nodes=(1)

curr_node=$(sed -n 4' p' ${filename} |cut -d' ' -f3)
sed -i 4's/ '${curr_node}'/ '${node_name}'/' ${filename} 

#rm -rf ${result_dir}/*.dat
for nn in ${num_nodes[@]}
do
        curr_n=$(sed -n 3' p' ${filename} |cut -d' ' -f3)
	sed -i 3's/ '${curr_n}'/ '${nn}'/' ${filename}
	echo "running on $(sed -n 4' p' ${filename} |cut -d' ' -f3) on $(sed -n 3' p' ${filename} |cut -d' ' -f3) nodes"
	sbatch ${filename} $1 ${nn}
	echo "finished"
done

