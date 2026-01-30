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

#anvi-run-hmms -c assembly_out/contig_anvio/contigs.db --num-threads 4 --just-do-it

#anvi-display-contigs-stats assembly_out/contig_anvio/contigs.db

#anvi-profile -i assembly_out/contig_anvio/BGR_130305_sorted.bam -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/BGR_130305_profile/ --force-overwrite
#anvi-profile -i assembly_out/contig_anvio/BGR_130708_sorted.bam -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/BGR_130708_profile/ --force-overwrite
#anvi-profile -i assembly_out/contig_anvio/BGR_130527_sorted.bam -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/BGR_130527_profile/ --force-overwrite

#anvi-merge assembly_out/contig_anvio/BGR_130305_profile/PROFILE.db assembly_out/contig_anvio/BGR_130708_profile/PROFILE.db assembly_out/contig_anvio/BGR_130527_profile/PROFILE.db -o assembly_out/contig_anvio/merged_profiles/ -c assembly_out/contig_anvio/contigs.db --enforce-hierarchical-clustering

#anvi-cluster-contigs -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C METABAT2 --driver metabat2 --just-do-it --log-file assembly_out/contig_anvio/metabat2.log
#anvi-summarize -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/SUMMARY_METABAT2 -C METABAT2

#anvi-estimate-genome-completeness -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -C METABAT2

#anvi-estimate-genome-completeness --list-collections -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db

#anvi-interactive -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C METABAT2

anvi-cluster-contigs -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C MAXBIN2 --driver maxbin2  --just-do-it --log-file  assembly_out/contig_anvio/maxbin2.log
anvi-summarize -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -o  assembly_out/contig_anvio/SUMMARY_MAXBIN2 -C MAXBIN2

## Day4

#anvi-estimate-genome-completeness -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -C METABAT2

#anvi-interactive -p  assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C METABAT2



#cd metagenomics/
#mkdir -p assembly_out/contig_anvio/METABAT_BIN_25/gunc_out_25
#gunc run -i  assembly_out/contig_anvio/METABAT_BIN_25/metabat_bin_25.fasta -r $WORK/databases/gunc/gunc_db_progenomes2.1.dmnd --out_dir  assembly_out/contig_anvio/METABAT_BIN_25/gunc_out_25 --detailed_output --threads 12
#mkdir -p assembly_out/contig_anvio/METABAT_BIN_27/gunc_out_27
#gunc run -i  assembly_out/contig_anvio/METABAT_BIN_27/metabat_bin_27.fasta -r $WORK/databases/gunc/gunc_db_progenomes2.1.dmnd --out_dir  assembly_out/contig_anvio/METABAT_BIN_27/gunc_out_27 --detailed_output --threads 12

#mkdir -p assembly_out/contig_anvio/METABAT_BIN_25/gunc_out
#gunc plot -d assembly_out/contig_anvio/METABAT_BIN_25/gunc_out_25/diamond_output/*.diamond.progenomes_2.1.out -g assembly_out/contig_anvio/METABAT_BIN_25/gunc_out_25/gene_calls/gene_counts.json --out_dir assembly_out/contig_anvio/METABAT_BIN_25/gunc_out

#mkdir -p assembly_out/contig_anvio/METABAT_BIN_27/gunc_out
#gunc plot -d assembly_out/contig_anvio/METABAT_BIN_27/gunc_out_27/diamond_output/*.diamond.progenomes_2.1.out -g assembly_out/contig_anvio/METABAT_BIN_27/gunc_out_27/gene_calls/gene_counts.json --out_dir assembly_out/contig_anvio/METABAT_BIN_27/gunc_out


#cp assembly_out/contig_anvio/merged_profiles/PROFILE.db assembly_out/contig_anvio/merged_profiles/PROFILE_refined.db

#anvi-refine -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE_refine.db --bin-id METABAT_BIN_25 -C METABAT2 

#anvi-refine -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE_refine.db --bin-id METABAT_BIN_27 -C METABAT2 