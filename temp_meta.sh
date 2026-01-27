#!/bin/bash
#SBATCH --job-name=assmbly
#SBATCH --output=assmbly.out
#SBATCH --error=assmbly.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --partition=base
#SBATCH --time=5:00:00
#SBATCH --reservation=biol217


#load necessary modules
module load gcc12-env/12.1.0
module load micromamba
eval "$(micromamba shell hook --shell=bash)"
export MAMBA_ROOT_PREFIX=$WORK/.micromamba

cd $WORK/


# create directory
#mkdir -p test1 test2
#touch test1/file1.txt test2/test4.txt  test1/test1.csv test1/test2.txt test2/test3.txt



#for x in test*/*.txt
#do
#echo "working on $x"
#echo "ending of file" >> "$x"
#done

#micromamba activate .micromamba/envs/00_anvio/

# ##----------------- End -------------
module purge
jobinfo