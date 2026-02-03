#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=2:00:00
#SBATCH --job-name=anvio_pangenomics
#SBATCH --output=anvio_pangenomics.out
#SBATCH --error=anvio_pangenomics.err
#SBATCH --partition=base
#SBATCH --reservation=biol217

module load gcc12-env/12.1.0
module load micromamba/1.4.2
eval "$(micromamba shell hook --shell=bash)"
cd $WORK
micromamba env list
micromamba activate 00_anvio

# create new folder
#mkdir  -p pangenomics/01_anvio_pangenomics

#curl -L https://ndownloader.figshare.com/files/28965090 -o V_jascida_genomes.tar.gz
#tar -zxvf V_jascida_genomes.tar.gz
#ls V_jascida_genomes


cd pangenomics

#ls *fasta | awk 'BEGIN{FS="_"}{print $1}' > genomes.txt

## remove all contigs <2500 nt
#for g in `cat genomes.txt`
#do
    #echo
    #echo "Working on $g ..."
    #echo
    #anvi-script-reformat-fasta ${g}_scaffolds.fasta \
                               #--min-len 2500 \
                              # --simplify-names \
                               #-o ${g}_scaffolds_2.5K.fasta
#done

# generate contigs.db
#for g in `cat genomes.txt`
#do
    #echo
    #echo "Working on $g ..."
    #echo
    #anvi-gen-contigs-database -f ${g}_scaffolds_2.5K.fasta \
                              #-o V_jascida_${g}.db \
                              #--num-threads 4 \
                              #-n V_jascida_${g}
#done


# annotate contigs.db
#for g in *.db
#do
    #anvi-run-hmms -c $g --num-threads 4
    #anvi-run-ncbi-cogs -c $g --num-threads 4
    #anvi-scan-trnas -c $g --num-threads 4
    #anvi-run-scg-taxonomy -c $g --num-threads 4
#done

#4. Visualize contigs.db
#from terminal

#srun --reservation=biol217 --pty --mem=16G --nodes=1 --tasks-per-node=1 --cpus-per-task=1 --partition=base /bin/bash

#module load gcc12-env/12.1.0
#module load micromamba/1.4.2
#eval "$(micromamba shell hook --shell=bash)"
#cd $WORK
#micromamba activate .micromamba/envs/00_anvio/
#anvi-display-contigs-stats pangenomics/V_jascida_genomes/*db

# in new terminal
#ssh -L localhost:8080:localhost:8080 sunam238@caucluster.rz.uni-kiel.de
#ssh -L localhost:8080:localhost:8080 n246


#5. Create external genomes file
#anvi-script-gen-genomes-file --input-dir V_jascida_genomes --output-file  V_jascida_genomes/external-genomes.txt


#6. Investigate contamination
#in ternimal
#cd V_jascida_genomes
#anvi-estimate-genome-completeness -e external-genomes.txt



#7. Visualise contigs for refinement
#anvi-profile -c  V_jascida_genomes/V_jascida_52.db \
             #--sample-name  V_jascida_52 \
             #--output-dir  V_jascida_genomes/V_jascida_52 \
             #--blank


#anvi-interactive -c V_jascida_genomes/V_jascida_52.db \
                 #-p V_jascida_genomes/V_jascida_52/PROFILE.db






#8. Splitting the genome in our good bins
#anvi-split -p V_jascida_genomes/V_jascida_52/PROFILE.db \
           #-c V_jascida_genomes/V_jascida_52.db \
          #-C default1 \
          #-o V_jascida_52_SPLIT

# Here are the files you created
#V_jascida_52_SPLIT/V_jascida_52_CLEAN/CONTIGS.db

#sed 's/V_jascida_52.db/V_jascida_52_SPLIT\/V_jascida_52_CLEAN\/CONTIGS.db/g'  V_jascida_genomes/external-genomes.txt >  V_jascida_genomes/external-genomes-final.txt


#9  Estimate completeness of split vs. unsplit genome:
#anvi-estimate-genome-completeness -e  V_jascida_genomes/external-genomes.txt -o  V_jascida_genomes/genome_completeness.txt


#10. Compute pangenome
#anvi-gen-genomes-storage -e V_jascida_genomes/external-genomes-final.txt \
                         #-o V_jascida_genomes/V_jascida-GENOMES.db

# calculate the pangenome
#anvi-pan-genome -g V_jascida_genomes/V_jascida-GENOMES.db \
                #--project-name V_jascida \
                #--num-threads 8   

# calculate the ANI 
#anvi-compute-genome-similarity -e V_jascida_genomes/external-genomes-final.txt \
                 #-o ani \
                 #-p V_jascida/V_jascida-PAN.db  \
                 #-T 8     


#11. Display the pangenome



anvi-display-pan -p V_jascida/V_jascida-PAN.db \
                 -g V_jascida_genomes/V_jascida-GENOMES.db