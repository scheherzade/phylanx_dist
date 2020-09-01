#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
phylanx_bin_dir="/home/sshirzad/src/phylanx/build_release_clang_no_hpxmp_medusa/bin"
#input1=(10 100 1000 10000 100000 50 500 5000 50000)
#input1=(50 500 5000 50000)
input1=(100000)
#input2=(10 100 1000 50 500 5000 50000)
input2=(500)
filter1=(10)
#filter1=(10 50 5 100 500)
#filter2=(10 50 100)
#filter2=(1 2 5 20 10 50 100)
filter2=(5)
thr=(1 4 8 16 24 32 40)
export PATH=${phylanx_bin_dir}:$PATH

#rm  ${result_dir}/*.dat
export OMP_NUM_THREADS=1

for num_cores in ${thr[@]}
do
	for i1 in ${input1[@]}
	do
		for i2 in ${input2[@]}
		do
			for f1 in ${filter1[@]}
			do
				if [ $i2 -ge $f1 ]
				then
		        	        for f2 in ${filter2[@]}
		        	        do
						echo "input ${i1}x${i2}x3 filter ${f1}x${f2}x3"
						touch ${result_dir}/${node_name}_cpp_${i1}_${i2}_${f1}_${f2}_${num_nodes}_${num_cores}.dat
						rm ${result_dir}/${node_name}_cpp_${i1}_${i2}_${f1}_${f2}_${num_nodes}_${num_cores}.dat
						srun -p ${node_name} -N ${num_nodes} ${phylanx_bin_dir}/conv1d_dist_instrumented_test --batch=${i1} --length=${i2} --channel=3 --filter_length=${f1} --out_channels=${f2} --hpx:localities=${num_nodes} --hpx:threads=${num_cores}>>${result_dir}/${node_name}_cpp_${i1}_${i2}_${f1}_${f2}_${num_nodes}_${num_cores}.dat
					done
				fi
			done
		done
	done
done
