#!/bin/bash
#SBATCH --job-name=metaquast
#SBATCH --output=metaquast.out
#SBATCH --error=metaquast.err
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

cd $WORK 
micromamba env list
micromamba activate 00_anvio

cd metagenomics/
#cd assembly_out/
#mkdir metaquast_out

#metaquast final.contigs.fa -o metaquast_out/ -t 6 -m 1000

#date
#mkdir contig_anvio

#anvi-script-reformat-fasta final.contigs.fa -o ./contig_anvio/contigs.anvio.fa --min-len 1000 --simplify-names --report-file ./contig_anvio/final_conversion.txt


#bowtie2-build  contig_anvio/contigs.anvio.fa  contig_anvio/contigs.anvio.fa.index

#bowtie2 -1 out/BGR_130305_clean_R1.fastq.gz -2 out/BGR_130305_clean_R2.fastq.gz -x assembly_out/contig_anvio/contigs.anvio.fa.index -S  assembly_out/contig_anvio/BGR_130305.sam --very-fast
#bowtie2 -1 out/BGR_130708_clean_R1.fastq.gz -2 out/BGR_130708_clean_R2.fastq.gz -x assembly_out/contig_anvio/contigs.anvio.fa.index -S assembly_out/contig_anvio/BGR_130708.sam --very-fast
#bowtie2 -1 out/BGR_130527_clean_R1.fastq.gz -2 out/BGR_130527_clean_R2.fastq.gz -x assembly_out/contig_anvio/contigs.anvio.fa.index -S assembly_out/contig_anvio/BGR_130527.sam --very-fast

#samtools view -Sb assembly_out/contig_anvio/BGR_130305.sam > assembly_out/contig_anvio/BGR_130305.bam
#samtools view -Sb assembly_out/contig_anvio/BGR_130708.sam > assembly_out/contig_anvio/BGR_130708.bam
#samtools view -Sb assembly_out/contig_anvio/BGR_130527.sam > assembly_out/contig_anvio/BGR_130527.bam


#anvi-init-bam assembly_out/contig_anvio/BGR_130305.bam  -o assembly_out/contig_anvio/BGR_130305_sorted.bam
#anvi-init-bam assembly_out/contig_anvio/BGR_130708.bam  -o assembly_out/contig_anvio/BGR_130708_sorted.bam
#anvi-init-bam assembly_out/contig_anvio/BGR_130527.bam  -o assembly_out/contig_anvio/BGR_130527_sorted.bam

#anvi-gen-contigs-database  -f  assembly_out/contig_anvio/contigs.anvio.fa -o assembly_out/contig_anvio/contigs.db -n biol217 --force-overwrite

#anvi-run-hmms -c assembly_out/contig_anvio/contigs.db --num-threads 4

#anvi-display-contigs-stats assembly_out/contig_anvio/contigs.db

#anvi-profile -i assembly_out/contig_anvio/BGR_130305_sorted.bam -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/BGR_130305_profile/
#anvi-profile -i assembly_out/contig_anvio/BGR_130708_sorted.bam -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/BGR_130708_profile/
#anvi-profile -i assembly_out/contig_anvio/BGR_130527_sorted.bam -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/BGR_130527_profile/

#anvi-merge assembly_out/contig_anvio/BGR_130305_profile/PROFILE.db assembly_out/contig_anvio/BGR_130708_profile/PROFILE.db assembly_out/contig_anvio/BGR_130527_profile/PROFILE.db -o assembly_out/contig_anvio/merged_profiles/ -c assembly_out/contig_anvio/contigs.db --enforce-hierarchical-clustering

anvi-cluster-contigs -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C METABAT2 --driver metabat2 --just-do-it --log-file assembly_out/contig_anvio/metabat2.log
anvi-summarize -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/SUMMARY_METABAT2 -C METABAT2