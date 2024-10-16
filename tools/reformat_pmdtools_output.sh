#!/bin/bash

#Takes the input file name as input (so to run write "bash reformat_pmdtools_output.sh {INPUT}"
input_file=$1
output_file=$2

## Print the header (first line of the input file plus 'z' at the beginning)
echo -e "pos\tC->T\tC->A\tC->G\tC->C\tG->A\tG->T\tG->C\tG->G" > ${output_file}

# Process the data block and format each position, accounting for extra blank line
awk '
  NR > 1 {  # Skip the first two lines (header line and blank line)
    if ((NR - 1) % 10 == 1) {  # New position starts every 10 lines (z value and 8 mutation rates + blank line)
      if (z != "") {
        # Print the accumulated results for the previous position
        printf "%s\t%s\n", z, results
      }
      z = $1       # Capture the position (z value)
      results = "" # Reset the results string
    } else if ($1 != "") {
      # Append the rates from the current line to the results string
      if (results != "") {
        results = results "\t" $1
      } else {
        results = $1
      }
    }
  }
  END {
    # Print the last result (since the last block won’t trigger the conditional inside the loop)
    if (z != "") {
      printf "%s\t%s\n", z, results
    }
  }
' "$input_file" >> ${output_file}
