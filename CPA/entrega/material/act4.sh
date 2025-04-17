#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=10:00
#SBATCH --partition=cpa

echo "----------------------- CODESP1 -----------------------"
OMP_NUM_THREADS=2 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=4 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=8 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=16 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=32 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=64 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=128 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=256 OMP_SCHEDULE=static ./codesp1
echo "\n \n \n"
echo "----------------------- CODESP2 -----------------------"
OMP_NUM_THREADS=2 OMP_SCHEDULE=static,1 ./codesp2
OMP_NUM_THREADS=4 OMP_SCHEDULE=static,1 ./codesp2
OMP_NUM_THREADS=8 OMP_SCHEDULE=static,1 ./codesp2
OMP_NUM_THREADS=16 OMP_SCHEDULE=static,1 ./codesp2
OMP_NUM_THREADS=32 OMP_SCHEDULE=static,1 ./codesp2
OMP_NUM_THREADS=64 OMP_SCHEDULE=static,1 ./codesp2
OMP_NUM_THREADS=128 OMP_SCHEDULE=static,1 ./codesp1
OMP_NUM_THREADS=256 OMP_SCHEDULE=static,1 ./codesp1