#!/bin/bash
node_name=$1
if [ $# -eq 2 ]
then
	type=$2
else
	type="both"
fi
result_dir="/work/sshirzad/phylanx_dist/results"
script_dir="/work/sshirzad/phylanx_dist/scripts"
hpx_build_dir="$HOME/src/hpx/build_release_clang_no_hpxmp_${node_name}_main/"
phylanx_build_dir="$HOME/src/phylanx/build_release_clang_no_hpxmp_${node_name}/"

mkdir -p ${result_dir}/info
rm ${reult_dir}/info/*

cp ${hpx_build_dir}/info/* ${result_dir}/info/
cp ${phylanx_build_dir}/info/* ${result_dir}/info/

filename=${script_dir}/cpp_impl.sh

num_nodes=(1 2 4 6 8)
#num_nodes=(6)

curr_node=$(sed -n 4' p' ${filename} |cut -d' ' -f3)
sed -i 4's/ '${curr_node}'/ '${node_name}'/' ${filename} 

#rm -rf ${result_dir}/*.dat
for nn in ${num_nodes[@]}
do
        curr_n=$(sed -n 3' p' ${filename} |cut -d' ' -f3)
	sed -i 3's/ '${curr_n}'/ '${nn}'/' ${filename}
	echo "running on $(sed -n 4' p' ${filename} |cut -d' ' -f3) on $(sed -n 3' p' ${filename} |cut -d' ' -f3) nodes"
	sbatch ${filename} $1 ${nn} ${type} 
	echo "finished"
done

