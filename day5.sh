#!/bin/bash
#SBATCH --job-name=metaquast
#SBATCH --output=metaquast.out
#SBATCH --error=metaquast.err
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

cd $WORK 
micromamba env list
micromamba activate 00_anvio

cd metagenomics/


#anvi-run-scg-taxonomy -c assembly_out/contig_anvio/contigs.db -T 20 -P 2

#anvi-estimate-scg-taxonomy -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE.db --metagenome-mode --compute-scg-coverages --update-profile-db-with-taxonomy  > temp.txt

#mkdir -p assembly_out/contig_anvio/SUMMARY_METABAT2_FINAL
#anvi-summarize -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -o assembly_out/contig_anvio/SUMMARY_METABAT2_FINAL -C METABAT2 --force-overwrite



mkdir -p assembly_out/contig_anvio/ANI
anvi-dereplicate-genomes -i seq.csv --program fastANI --similarity-threshold 0.95 -o assembly_out/contig_anvio/ANI --log-file log_ANI -T 10  --force-overwrite