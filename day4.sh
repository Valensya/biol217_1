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

#anvi-estimate-genome-completeness -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -C METABAT2 --debug

#anvi-estimate-genome-completeness --list-collections -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db


### from
#ssh -L localhost:8080:localhost:8080 sunamNNN@caucluster.rz.uni-kiel.de
#ssh -L localhost:8080:localhost:8080 nNNN
# in new terminal


#anvi-interactive -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C METABAT2

#micromamba activate 00_gunc
#mkdir -p assembly_out/contig_anvio/METABAT__20/gunc_out_20
#gunc run -i  assembly_out/contig_anvio/METABAT__20/METABAT__20-contigs.fasta -r $WORK/databases/gunc/gunc_db_progenomes2.1.dmnd --out_dir assembly_out/contig_anvio/METABAT__20/gunc_out_20 --detailed_output --threads 12
#mkdir -p assembly_out/contig_anvio/METABAT__29/gunc_out_29
#gunc run -i  assembly_out/contig_anvio/METABAT__29/METABAT__29-contigs.fasta -r $WORK/databases/gunc/gunc_db_progenomes2.1.dmnd --out_dir  assembly_out/contig_anvio/METABAT__29/gunc_out_29 --detailed_output --threads 12

#mkdir -p assembly_out/contig_anvio/METABAT__31/gunc_out_31
#gunc run -i  assembly_out/contig_anvio/METABAT__31/METABAT__31-contigs.fasta -r $WORK/databases/gunc/gunc_db_progenomes2.1.dmnd --out_dir  assembly_out/contig_anvio/METABAT__31/gunc_out_31 --detailed_output --threads 12

#mkdir -p assembly_out/contig_anvio/METABAT__20/gunc_out
#gunc plot -d assembly_out/contig_anvio/METABAT__20/gunc_out_20/diamond_output/*.diamond.progenomes_2.1.out -g assembly_out/contig_anvio/METABAT__20/gunc_out_20/gene_calls/gene_counts.json --out_dir assembly_out/contig_anvio/METABAT__20/gunc_out

#mkdir -p assembly_out/contig_anvio/METABAT__29/gunc_out
#gunc plot -d assembly_out/contig_anvio/METABAT__29/gunc_out_29/diamond_output/*.diamond.progenomes_2.1.out -g assembly_out/contig_anvio/METABAT__29/gunc_out_29/gene_calls/gene_counts.json --out_dir assembly_out/contig_anvio/METABAT__29/gunc_out

#mkdir -p assembly_out/contig_anvio/METABAT__31/gunc_out
#gunc plot -d assembly_out/contig_anvio/METABAT__31/gunc_out_31/diamond_output/*.diamond.progenomes_2.1.out -g assembly_out/contig_anvio/METABAT__31/gunc_out_31/gene_calls/gene_counts.json --out_dir assembly_out/contig_anvio/METABAT__31/gunc_out

#cp assembly_out/contig_anvio/merged_profiles/PROFILE.db assembly_out/contig_anvio/merged_profiles/PROFILE_refined.db


### from
#ssh -L localhost:8080:localhost:8080 sunamNNN@caucluster.rz.uni-kiel.de
#ssh -L localhost:8080:localhost:8080 nNNN
# in new terminal

#anvi-refine -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE_refined.db --bin-id METABAT__20 -C METABAT2 
#anvi-refine -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE_refined.db --bin-id METABAT__29 -C METABAT2 
#anvi-refine -c assembly_out/contig_anvio/contigs.db -p assembly_out/contig_anvio/merged_profiles/PROFILE_refined.db --bin-id METABAT__31 -C METABAT2 

anvi-interactive -p assembly_out/contig_anvio/merged_profiles/PROFILE.db -c assembly_out/contig_anvio/contigs.db -C METABAT2





