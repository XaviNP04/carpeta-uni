#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=5:00
#SBATCH --partition=cpa

OMP_NUM_THREADS=32 OMP_SCHEDULE=static ./codesp1
OMP_NUM_THREADS=32 OMP_SCHEDULE=static ./codesp2

OMP_NUM_THREADS=32 OMP_SCHEDULE=static,1 ./codesp1
OMP_NUM_THREADS=32 OMP_SCHEDULE=static,1 ./codesp2

OMP_NUM_THREADS=32 OMP_SCHEDULE=dynamic,1 ./codesp1
OMP_NUM_THREADS=32 OMP_SCHEDULE=dynamic,1 ./codesp2
