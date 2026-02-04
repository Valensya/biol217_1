#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=2:00:00
#SBATCH --job-name=reademption
#SBATCH --output=reademption.out
#SBATCH --error=reademption.err
#SBATCH --partition=base
#SBATCH --reservation=biol217

module load gcc12-env/12.1.0
module load micromamba/1.4.2
eval "$(micromamba shell hook --shell=bash)"
micromamba activate $WORK/.micromamba/envs/10_grabseqs

#cd transcriptom

#mkdir fastq_raw
#cd fastq_raw

# set proxy environment to download the data and use the internet in the backend
#work in the terminal
#grabseqs sra -t 4 -m fastq_raw/metadata.csv SRR4018514
#grabseqs sra -t 4 -m fastq_raw/metadata.csv SRR4018515
#grabseqs sra -t 4 -m fastq_raw/metadata.csv SRR4018516
#grabseqs sra -t 4 -m fastq_raw/metadata.csv SRR4018517


# Activate the environment:
module load gcc12-env/12.1.0
module load micromamba/1.4.2
eval "$(micromamba shell hook --shell=bash)"
micromamba activate $WORK/.micromamba/envs/08_reademption

# go to the directory you want to work in
#cd $WORK
cd transcriptom

# create folders
#reademption create --project_path READemption_analysis_2 --species methanosarcina="Methanosarcina mazei Gö1"


# download reference genome
#wget -O READemption_analysis_2/input/methanosarcina_reference_sequences/GCF_000007065.1_ASM706v1_genomic.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/007/065/GCF_000007065.1_ASM706v1/GCF_000007065.1_ASM706v1_genomic.fna.gz

# download annotation
#wget -O READemption_analysis_2/input/methanosarcina_annotations/GCF_000007065.1_ASM706v1_genomic.gff.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/007/065/GCF_000007065.1_ASM706v1/GCF_000007065.1_ASM706v1_genomic.gff.gz

# unzip them
#gunzip READemption_analysis_2/input/methanosarcina_reference_sequences/GCF_000007065.1_ASM706v1_genomic.fna.gz
#gunzip READemption_analysis_2/input/methanosarcina_annotations/GCF_000007065.1_ASM706v1_genomic.gff.gz

# analysis

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=0-04:00:00
#SBATCH --job-name=rna_seq_methanosarcina
#SBATCH --output=rna_seq_methanosarcina.out
#SBATCH --error=rna_seq_methanosarcina.err
#SBATCH --partition=base
#SBATCH --reservation=biol217

module load gcc12-env/12.1.0
module load micromamba/1.4.2
eval "$(micromamba shell hook --shell=bash)"
micromamba activate $WORK/.micromamba/envs/08_reademption



# align reads to reference
#reademption align -p 4 --poly_a_clipping --project_path READemption_analysis_2 --fastq

# calculate read coverage
#reademption coverage -p 4 --project_path READemption_analysis_2

# quantify gene expression
#reademption gene_quanti -p 4 --features CDS,tRNA,rRNA --project_path READemption_analysis_2

# calculate differential expression using DESeq2
#reademption deseq -l mut_R1.fastq.gz,mut_R2.fastq.gz,wt_R1.fastq.gz,wt_R2.fastq.gz -c mut,mut,wt,wt -r 1,2,1,2 --libs_by_species methanosarcina=mut_R1,mut_R2,wt_R1,wt_R2 --project_path READemption_analysis_2

# visualization
#reademption viz_align --project_path READemption_analysis_2
#reademption viz_gene_quanti --project_path READemption_analysis_2
reademption viz_deseq --project_path READemption_analysis_2

# environment cleanup
#micromamba deactivate
#module purge
#jobinfo




