#!/bin/bash
#SBATCH --job-name=assemble
#SBATCH --output=assemble.out
#SBATCH --error=assemble.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --partition=base
#SBATCH --time=1:30:00
#SBATCH --reservation=biol217


#load necessary modules
module load gcc12-env/12.1.0
module load micromamba
eval "$(micromamba shell hook --shell=bash)"
export MAMBA_ROOT_PREFIX=$WORK/.micromamba


#cd $WORK 
#cd genomics/
#micromamba env list
#micromamba activate 01_short_reads_qc

## 1.1 fastqc 
#mkdir -p $WORK/genomics/0_raw_reads/shot_reads_fastqc_raw

#for i in 0_raw_reads/short_reads/*.gz
#do 
  #fastqc $i -o 0_raw_reads/shot_reads_fastqc_raw/ -t 8
#done


## 1.2 fastp cleaned
#mkdir -p $WORK/genomics/0_raw_reads/shot_reads_fastp_raw

#fastp -i 0_raw_reads/short_reads/241155E_R1.fastq.gz \
 #-I 0_raw_reads/short_reads/241155E_R2.fastq.gz \
 #-R 0_raw_reads/shot_reads_fastp_raw/fastp_report \
 #-h 0_raw_reads/shot_reads_fastp_raw/report.html \
 #-o 0_raw_reads/shot_reads_fastp_raw/241155E_R1_clean.fastq.gz \
 #-O 0_raw_reads/shot_reads_fastp_raw/241155E_R2_clean.fastq.gz \
  #--trim_front1 15 --trim_front2 15 -t 6 -T 6 -q 25



## 1.3 fastqc again
#mkdir -p $WORK/genomics/0_raw_reads/shot_reads_fastqc_clean

#for i in 0_raw_reads/shot_reads_fastp_raw/*.gz
#do 
  #fastqc $i -o 0_raw_reads/shot_reads_fastqc_clean/ -t 16
#done


#micromamba deactivate
#jobinfo

#eval "$(micromamba shell hook --shell=bash)"
#cd $WORK
#micromamba activate .micromamba/envs/02_long_reads_qc

#2.1 Long reds plot
#cd $WORK/genomics/0_raw_reads/long_reads/
#mkdir -p filter
#NanoPlot --fastq 241155E.fastq.gz -o filter -t 6 --maxlength 40000 --minlength 1000 --plots kde --format png --N50 --dpi 300 --store --raw --tsv_stats --info_in_report

#2.2 long read filter
#filtlong --min_length 1000 --keep_percent 90 241155E.fastq.gz | gzip >  241155E_cleaned_filtlong.fastq.gz
#mv 241155E_cleaned_filtlong.fastq.gz filter

#2.3 long read plot again
#mkdir -p filter1
#NanoPlot --fastq filter/241155E_cleaned_filtlong.fastq.gz -o filter1 -t 6 --maxlength 40000 --minlength 1000 --plots kde --format png --N50 --dpi 300 --store --raw --tsv_stats --info_in_report

#micromamba deactivate
#3 Assemble the genome using Uniycler
#echo "---------Unicycler Assembly pipeline started---------"
#eval "$(micromamba shell hook --shell=bash)"

#cd $WORK
##micromamba activate .micromamba/envs/03_unicycler

#cd $WORK/genomics
#mkdir -p 3_hybrid_assembly
#unicycler -1 0_raw_reads/shot_reads_fastp_raw/241155E_R1_clean.fastq.gz -2 0_raw_reads/shot_reads_fastp_raw/241155E_R2_clean.fastq.gz -l 0_raw_reads/long_reads/filter/241155E_cleaned_filtlong.fastq.gz -o 3_hybrid_assembly/ -t 8
#micromamba deactivate
#echo "---------Unicycler Assembly pipeline Completed Successfully---------"

#micromamba deactivate
## 4.1 Quast (5 minutes)
#echo "---------Assembly Quality Check Started---------"
#micromamba env list
#micromamba activate 04_quast
#cd $WORK/genomics/3_hybrid_assembly

#mkdir -p $WORK/genomics/3_hybrid_assembly/quast

#quast.py assembly.fasta --circos -L --conserved-genes-finding --rna-finding \
 #--glimmer --use-all-alignments --report-all-metrics -o quast -t 8

micromamba deactivate

#4.2. CheckM
#micromamba env list
#micromamba activate 04_checkm

#cd $WORK/genomics
#mkdir -p checkm_out

#checkm lineage_wf 3_hybrid_assembly/  ./checkm_out -x fasta --tab_table --file checkm_out/checkm_resalt -r -t 32
#checkm tree_qa checkm_out
#checkm qa checkm_out/lineage.ms checkm_out -o 1 > checkm_out/Final_table_01.csv
#checkm qa checkm_out/lineage.ms checkm_out/ -o 2 > checkm_out/Final_table_checkm.csv
micromamba deactivate


# tree_qa: assess phylogenetic markers found in each bin
# lineage_wf: runs tree, lineage_set, analyze, qa
# qa -> Assess bins for contamination and completeness


#4.3. CheckM2
#micromamba env list
#micromamba activate 04_checkm2

#cd $WORK/genomics
#mkdir -p checkm2

#checkm2 predict --threads 1 --input 3_hybrid_assembly/*.fasta --output-directory ./checkm2 
#micromamba deactivate
#echo "---------Assembly Quality Check Completed Successfully---------"


#
# 5 Annotate the Genomes with Prokka
echo "---------Prokka Genome Annotation Started---------"

cd $WORK
micromamba env list
micromamba activate 05_prokka
cd $WORK/genomics/3_hybrid_assembly
# Prokka creates the output dir on its own

prokka assembly.fasta --outdir 4_annotated_genome --kingdom Bacteria --addgenes --cpus 8
micromamba deactivate
echo "---------Prokka Genome Annotation Completed Successfully---------"
