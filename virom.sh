

#command
How many free viruses are in the BGR_140717 sample?
grep ">" -c 01_GENOMAD/BGR_140717/BGR_140717_Viruses_Genomad_Output/BGR_140717_modified_summary/BGR_140717_modified_virus.fna

How many proviruses are in the BGR_140717 sample?
grep ">" -c 01_GENOMAD/BGR_140717/BGR_140717_Proviruses_Genomad_Output/proviruses_summary/proviruses_virus.fna

How many Caudoviricetes viruses are in all samples together? (Use the filtered version)
grep -c "Caudoviricetes" 02_CHECK_V/BGR_*/MVP_02_BGR_*_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv


How many Unclassified viruses are in all samples together? (Use the filtered version)
grep -c "Unclassified" 02_CHECK_V/BGR_*/MVP_02_BGR_*_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv

What other taxonomies are there across all files? Below, paste a table with (at least) taxonomy, Genome type and Host type.
grep -v "Caudoviricetes" 02_CHECK_V/BGR_*/MVP_02_BGR_*_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv |grep -v "Unclassified" |grep -v "Sample"

How many High-quality and Complete viruses are in all samples together? (Use the filtered version and focus on the CheckV quality)
cut -f 8 02_CHECK_V/BGR_*/MVP_02_BGR_*_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv | grep -e "High-quality" -e "Complete" |grep -c ""
Bonus: If you do cut -f 1,8 (and skip the counting), you can see which samples the viruses came from (since you are cutting two columns, Sample and checkv_quality).


Create a table based on the CheckV quality with the columns Sample, Low-quality, Medium-quality, High-quality, Complete. Fill it with the amount of viruses for each of the categories. Tip: If you are tight on time, just save the output and make it pretty later!
for x in BGR_130305  BGR_130527  BGR_130708  BGR_130829  BGR_130925  BGR_131021  BGR_131118  BGR_140106  BGR_140121  BGR_140221  BGR_140320  BGR_140423  BGR_140605  BGR_140717  BGR_140821  BGR_140919  BGR_141022  BGR_150108; 
do 
echo $x; 
echo  "Low-quality"; 
cut -f 8 02_CHECK_V/"$x"/MVP_02_"$x"_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv | grep -c "Low-quality" ; 
echo  "Medium-quality"; 
cut -f 8 02_CHECK_V/"$x"/MVP_02_"$x"_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv | grep -c "Medium-quality"; 
echo  "High-quality"; 
cut -f 8 02_CHECK_V/"$x"/MVP_02_"$x"_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv | grep -c "High-quality"; 
echo  "Complete"; 
cut -f 8 02_CHECK_V/"$x"/MVP_02_"$x"_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv | grep -c "Complete"; 
done


For the Complete viruses from all samples, extract all the lines (from the same output file you just used to answer previous questions) so we can take a closer look. Also add a header so we know what each column contains.
grep "Complete" 02_CHECK_V/BGR_*/MVP_02_BGR_*_Filtered_Relaxed_Merged_Genomad_CheckV_Virus_Proviruses_Quality_Summary.tsv


Clustering and Abundance

    Understanding the output: Find the clustering output. What is the difference between the three tsv files? Tip: Just look at the file names.

    How many cluster representatives are there?
    grep -c "" 03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Quality_Summary.tsv

Bonus: If you are unsure, if there is really only one line per cluster representative, you can do this instead:
cut -f 1 03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Quality_Summary.tsv |sort|uniq |wc -l


Here, we extract the first column (that has the identifyers of all cluster representatives). Then, we sort it and use only the unique lines (sorting is needed to ensure that uniq works properly). 
Counting is done using the alternative method mentioned above, but you could also do grep -c "".

How many of the cluster representatives are proviruses?
cut -f 5 03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Quality_Summary.tsv | grep -c "Yes"


What clusters do the complete viruses from 8) belong to? How large are the clusters?
grep -e "BGR_131021_NODE_96_length_46113_cov_32.412567" -e "BGR_140121_NODE_54_length_34619_cov_66.823718" -e "BGR_140717_NODE_168_length_31258_cov_37.020094" 03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Quality_Summary.tsv

You could leave it here and manually count the cluster members. If you want to be a bit more fancy, you could do this:

To get the number of cluster members per cluster, we first iterate through the three clusters we are interested in and print their name. Then, we extract column 2 (which has all cluster members) from the file with all the clusters and limit the selection to only that one cluster we are interested in. 
Afterwards, we grep comma, since the cluster members are comma separated. By using -o with grep, we have it print only the matches, one per line. Counting needs to be done in a seperate command. grep "," -o -c returns 1 (since it is only one line). 
So we need to count after piping the output. Now we know the amount of commas. To get the amount of cluster members, we need to add one, since the last member doesn't have a comma written behind it.


for x in BGR_131021_NODE_96_length_46113_cov_32.412567 BGR_140121_NODE_54_length_34619_cov_66.823718 BGR_140717_NODE_168_length_31258_cov_37.020094; 
do 
echo $x; 
cut -f 2 03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Quality_Summary.tsv | grep "$x" | grep "," -o |grep "" -c; 
done

Right now, the output for this module is spread across multiple files, which is inconvenient and happens a lot in bioinformatics. Luckily, each file has a column where the sample information is listed anyways, so we can merge them. Task: Merge all CoverM files for all the samples (order doesn't matter) using e.g. the cat command (not cut). 
Remember to exclude the headers and keep only one. Your finished file should have 96733 lines total.
grep --no-filename -v "Sample" 04_READ_MAPPING/BGR_*/*_CoverM.tsv >04_READ_MAPPING/tmp_CoverM_output.tsv

Next, we extract the header of one of the original files and store it in another temporary file. You could also copy and paste the header manually. 
But since it is a tab separated values file, and tab characters behave weird when being copied (to put it simple), it is better to do it like this.

grep "Sample" 04_READ_MAPPING/BGR_150108/BGR_150108_CoverM.tsv >04_READ_MAPPING/tmp.tsv

Now, all that is left is to concatenate both files (here, the file order matters since we want the header to be on top!) 
and remove all temporary files (be very careful when removing files using wildcards!!!).
cat 04_READ_MAPPING/tmp.tsv 04_READ_MAPPING/tmp_CoverM_output.tsv >04_READ_MAPPING/merged_CoverM_output.tsv
rm 04_READ_MAPPING/tmp*

Using the file you just created, how abundant are the complete viruses in different samples (RPKM)? Create a table.
Here, we are looking for multiple patterns using grep. It will result in a file that is ordered by sample, not by virus.
grep -e "BGR_131021_NODE_96_length_46113_cov_32.412567" -e "BGR_140121_NODE_54_length_34619_cov_66.823718" -e "BGR_140717_NODE_168_length_31258_cov_37.020094" 04_READ_MAPPING/merged_CoverM_output.tsv

To have it nicer for parsing it into a table, we can run it in a for loop to force it to sort by virus. 
In addition, we here extract only the columns that are interesting to us (Sample, Contig, RPKM).

for x in "BGR_131021_NODE_96_length_46113_cov_32.412567" "BGR_140121_NODE_54_length_34619_cov_66.823718"  "BGR_140717_NODE_168_length_31258_cov_37.020094" ;
do 
grep "$x" 04_READ_MAPPING/merged_CoverM_output.tsv | cut -f 1,2,11 ; 
done > 04_READ_MAPPING/merged_viruses_RPKM.tsv

You can redirect (>) the output to a file as well (won't have a header), if you add this at the end:
..... ; done > 04_READ_MAPPING/merged_viruses_RPKM.tsv


Using the file you just created, how abundant are the complete viruses in different samples (RPKM)? Create a table.
grep -e "BGR_131021_NODE_96_length_46113_cov_32.412567" -e "BGR_140121_NODE_54_length_34619_cov_66.823718" -e "BGR_140717_NODE_168_length_31258_cov_37.020094" 04_READ_MAPPING/merged_CoverM_output.tsv

 for x in "BGR_131021_NODE_96_length_46113_cov_32.412567" "BGR_140121_NODE_54_length_34619_cov_66.823718"  "BGR_140717_NODE_168_length_31258_cov_37.020094" ; 
 do echo $x; 
 grep "$x" 06_FUNCTIONAL_ANNOTATION/MVP_06_All_Sample_Filtered_Conservative_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Gene_Annotation_GENOMAD_PHROGS_PFAM_Filtered.tsv | cut  -f23 |sort | uniq; 
 done



Если хочешь видеть ген + координаты + аннотацию, лучше та
for x in "BGR_131021_NODE_96_length_46113_cov_32.412567" \
         "BGR_140121_NODE_54_length_34619_cov_66.823718" \
         "BGR_140717_NODE_168_length_31258_cov_37.020094"
do
  echo "==== $x ===="

  grep "$x" 06_FUNCTIONAL_ANNOTATION/MVP_06_All_Sample_Filtered_Conservative_Merged_Genomad_CheckV_Representative_Virus_Proviruses_Gene_Annotation_GENOMAD_PHROGS_PFAM_Filtered.tsv \
  | cut -f1,4,5,23 |sort | uniq \
  | column -t
done