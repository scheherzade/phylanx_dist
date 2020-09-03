#!/bin/bash

#SBATCH -N 1 
#SBATCH -p medusa
#SBATCH --time=72:00:00

node_name=$1
num_nodes=$2

script_dir="/work/sshirzad/phylanx_dist/scripts"
result_dir="/work/sshirzad/phylanx_dist/results"
phylanx_bin_dir="/home/sshirzad/src/phylanx/build_release_clang_no_hpxmp_medusa/bin"


batch=(100000)
length=(500)
out_channels=(5)
filter_length=(10)

thr=(1 4 8 16 24 32 40)
export PATH=${phylanx_bin_dir}:$PATH

#rm  ${result_dir}/*.dat
export OMP_NUM_THREADS=1

for num_cores in ${thr[@]}
do
	for b in ${batch[@]}
	do
	        for l in ${length[@]}
	        do
	                for fl in ${filter_length}
	                do
	                        if [ $b -ge $fl ]
	                        then
	                                for oc in ${out_channels[@]}
	                                do
	                                        echo "input ${b}x${l}x3 filter ${oc}x${fl}x3"
	                                        touch ${result_dir}/${node_name}_impl_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
	                                        rm ${result_dir}/${node_name}_impl_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
	                                        srun -p ${node_name} -N ${num_nodes} ${phylanx_bin_dir}/conv1d_instrumented_test --batch=${b} --length=${l} --channel=3 --filter_length=${fl} --out_channels=${oc} --hpx:localities=${num_nodes} --hpx:threads=${num_cores} >>${result_dir}/${node_name}_impl_${b}_${l}_${oc}_${fl}_${num_nodes}_${num_cores}.dat
	                                done
	                        fi
	                done
	        done
	done
done