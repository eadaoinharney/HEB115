# change_to_ignore.py
# By: Éadaoin Harney
# September 2023
#
# This script takes in an ind file and outputs one with all pops not listed the keepfile changed to Ignore
#
# to run:
# python change_to_ignore.py --infile {infile} --popfile {popfile} --outfile {outfile}
#----------------------------------------------------------------------------------------------------
import argparse
import numpy as np

#----------------------------------------------------------------------------------------------------
def main(indfile, popfile, outfile, byind):

	data = np.loadtxt(fname = indfile, dtype = str )
	keepfile = np.loadtxt(fname = popfile, dtype = str)

	if not byind:

		for row in data:
			if row[2] not in keepfile:
				row[2] = 'Ignore'

	else:

		for row in data:
			if row[0] not in keepfile:
				row[2] = 'Ignore'


	file = open(outfile, 'w')
	for row in data:
		for col in row:
			file.write("%s	" %col)
		file.write("\n")

	file.close()



#----------------------------------------------------------------------------------------------------
if __name__ == "__main__":

	parser = argparse.ArgumentParser(description="Use this script to create a new .ind file where all of the populations that are not listed in the provided popfile are changed to Ignore")

	parser.add_argument('--indfile', help='a pointer to ind file to modify', required=True)
	parser.add_argument('--popfile', help='a pointer to a file containing list of populations to retain in modified ind file. One pop per line', required=True)
	parser.add_argument('--outfile', help='the location where the output file should be written', required=True)
	parser.add_argument('--byind', action="store_true", help='include this flag if the popfile you provided is actually a list of individual IDs rather than population IDs')

	args = parser.parse_args()

	main(indfile=args.indfile,
		popfile=args.popfile,
		outfile=args.outfile,
		byind=args.byind)

