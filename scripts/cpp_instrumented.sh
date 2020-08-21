#!/bin/bash

#SBATCH -N 8 
#SBATCH -p marvin 
#SBATCH --time=72:00:00

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
phylanx_bin_dir="/home/sshirzad/src/phylanx/build_release_clang_no_hpxmp_medusa/bin"
node_name="medusa"
num_nodes=2
input1=(10)
# 100 1000 10000 100000)
input2=(20)
#200 2000)
filter1=(10)
#100)
filter2=(10)
#100 1000)
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
					srun -p medusa -N 2 ${phylanx_bin_dir}/conv1d_dist_instrumented_test --batch=${i1} --length=${i2} --channel=3 --k_length=${f1} --k_channel=3 --k_out=${f2} --hpx:localities=${num_nodes}>>${result_dir}/${node_name}_instrumented_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
				done
			fi
		done
	done
done
