#! /usr/bin/env bash 

datasets="$HOME/data-sets"



# Question 1: Use BEDtools intersect to identify the size of the largest overlap between CTCF and H3K4me3 locations.
H3K4me3="$datasets/bed/encode.h3k4me3.hela.chr22.bed.gz"
tfbs="$datasets/bed/encode.tfbs.chr22.bed.gz"

answer_1=$(bedtools intersect -wo -a $tfbs -b $H3K4me3 | sort -k15nr | cut -f15 | head -n1)
echo "answer-1: $answer_1"


# Question 2: Use BEDtools to calculate the GC content of nucleotides 19,000,000 to 19,000,500 on chr22 of hg19 genome build. Report the GC 
# content as a fraction (e.g., 0.50).
# Made BED file of interval w/ "echo -e "chr22\t19000000\t19000500" > interval.bed 

fasta="$datasets/fasta/hg19.chr22.fa"
interval="$datasets/interval.bed"

answer_2=$(bedtools nuc -fi $fasta -bed $interval | tail -n1 | cut -f5)

echo "answer-2: $answer_2"

# Question 3: Use BEDtools to identify the length of the CTCF ChIP-seq peak (i.e., interval) that has the largest mean signal in
# ctcf.hela.chr22.bg.gz.
ctcf="$datasets/bedtools/ctcf.hela.chr22.bg.gz"

answer_3=$(bedtools map -o mean -c 4 -a $tfbs -b $ctcf | sort -k5rn | head -n1 | awk 'BEGIN {FS="\t"} {print $3 - $2}')

echo "answer-3: $answer_3"




# Question 4: Use BEDtools to identify the gene promoter (defined as 1000 bp upstream of a TSS) with the highest median signal in
# ctcf.hela.chr22.bg.gz. Report the gene name (e.g., 'ABC123')
tss="$datasets/bed/tss.hg19.chr22.bed"

 answer_4=$(bedtools map -c 4 -o median -a $tss -b $ctcf \
 | awk 'BEGIN {OFS="\t"} ($7 != ".")' \
 |sort -k7rn \
 | cut -f4 | head -n1)

echo "answer-4: $answer_4"

# Question 5: Use BEDtools to identify the longest interval on chr22 that is not covered by genes.hg19.bed.gz. Report the interval like
# chr1:100-500.
genes="$datasets/bed/genes.hg19.bed.gz"
hg19="$datasets/genome/hg19.genome"

answer_5=$(bedtools complement -i $genes -g $hg19 \
| awk 'BEGIN {OFS="\t"} ($1 == "chr22") {print $1, $2, $3, $3-$2}' \
| sort -k4rn \
| awk '{print $1":"$2"-"$3}' \
| head -n1)

echo "answer-5: $answer_5"


# Bonus, Question 6: Use one or more BEDtools that we haven't covered in class. Be creative.

