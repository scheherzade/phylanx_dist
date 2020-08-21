#!/bin/bash

#SBATCH -N 8
#SBATCH -p medusa
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
phylanx_bin_dir="/home/sshirzad/src/phylanx/build_release_clang_no_hpxmp_medusa/bin"
input1=(10 100 1000 10000 100000)
input2=(10 100 1000)
filter1=(10 50)
filter2=(10 50 100)
export PATH=${phylanx_bin_dir}:$PATH

#rm  ${result_dir}/*.dat
export OMP_NUM_THREADS=1

for i1 in ${input1[@]}
do
	for i2 in ${input2[@]}
	do
		for f1 in ${filter1[@]}
		do
			if [[ $i2 -ge $f1 ]]
			then
	        	        for f2 in ${filter2[@]}
	        	        do
					echo "input ${i1}x${i2}x3 filter ${f1}x${f2}x3"
					echo "${phylanx_bin_dir}/test_conv1d_instrumented_test --batch=${i1} --length=${i2} --channel=3 --k_length=${f1} --k_channel=3 --k_out=${f2} --hpx:localities=${num_nodes}"

					touch ${result_dir}/${node_name}_instrumented_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
					rm ${result_dir}/${node_name}_instrumented_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
					srun -p ${node_name} -N ${num_nodes} ${phylanx_bin_dir}/conv1d_dist_instrumented_test --batch=${i1} --length=${i2} --channel=3 --k_length=${f1} --k_channel=3 --k_out=${f2} --hpx:localities=${num_nodes}>>${result_dir}/${node_name}_instrumented_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat

					touch ${result_dir}/${node_name}_physl_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
                                        rm ${result_dir}/${node_name}_physl_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
                                        srun -p ${node_name} -N ${num_nodes} physl ~/src/phylanx/tests/performance/conv1d_dist_test.physl ${i1} ${i2} 3 ${f1} 3 ${f2} --hpx:localities=${num_nodes}>>${result_dir}/${node_name}_physl_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat

				done
			fi
		done
	done
done
