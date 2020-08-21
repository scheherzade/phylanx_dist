#!/bin/bash
script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
hpx_bin_dir="~/src/phylanx/build_release_clang_no_hpxmp_medusa/bin"
node_name=$1
num_nodes=$2
input1=(100000)
input2=(2000)
filter1=(100)
filter2=(1000)
export PATH=${hpx_bin_dir}:$PATH

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
					touch ${result_dir}/${node_name}_physl_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
					rm ${result_dir}/${node_name}_physl_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
					physl ~/src/phylanx/tests/performance/conv1d_dist_test.physl ${i1} ${i2} 3 ${f1} 3 ${f2} --hpx:localities=${num_nodes}>>${result_dir}/${node_name}_physl_${i1}_${i2}_${f1}_${f2}_${num_nodes}.dat
				done
			fi
		done
	done
done
