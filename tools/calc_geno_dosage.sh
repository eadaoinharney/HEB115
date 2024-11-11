#!/bin/bash
#
# To use:
# bash calc_geno_dosage.sh {pointer to input vcf file} {pointer to output file location}
###################

input_vcf=$1
output_file=$2

#Pull SNP position info
grep -v "#" ${input_vcf} | awk '{print $1 "," $2}' > temp1

#Calculate dosage
grep -v "#" ${input_vcf} | awk '{print $10}' | awk -F "," '{print 10^(-1*$1/10) "," 10^(-1*$2/10) "," 10^(-1*$3/10)}' | \
 awk -F "," '{print $1/($1+$2+$3) "," $2/($1+$2+$3) "," $3/($1+$2+$3)}' | awk -F "," '{print $1 "," $2 "," $3 "," $2+$3*2}' > temp2

#Create header for output file
echo "chr,position,p_homo_ref,p_het,p_homo_alt,dosage" > ${output_file}
paste -d "," temp1 temp2 >> ${output_file}

#Delete temporary files
rm -f temp1
rm -f temp2 
