#import StringIO
import operator
import csv
import numpy as np
import codecs
from collections import defaultdict

import glob
import sys
import pandas as pd

fileOutName = sys.argv[1] + ".csv"
fout = open(fileOutName, 'w')
file_names = glob.glob("timing*")
for file_name in file_names:
	faultN = file_name.split("_")[1]
    	#print faultN
	with open(file_name) as f:
        	#for line in f:
		#print file_name
		arr = np.loadtxt(file_name)
		time = np.min(arr, axis=0)
		ind_min = np.argmin(arr, axis=0)
		index = ind_min + 1
		#print minimum, "  ", ind_min
		powerFileName = sys.argv[1] + "_" + str(faultN) + "_" + str(index) + ".csv"
		print (powerFileName)


#		columns = defaultdict(list) # each value in each column is appended to a list

		fi = open(powerFileName, 'rb')
		data = fi.read()
		fi.close()

		df = pd.read_csv(powerFileName)
		df = df.dropna(thresh=2)
		watts = df[' W']   #df.W
		#print (watts)
		energy = sum(watts)
		print (energy)
		
		fout.write(str(faultN) + "," + str(time) +  "," + str(energy) + "," + str(len(watts)) + "," + str(powerFileName) + "\n") 

 #	incsv = csv.reader(pf)
#			column = 3                # Python counts from 0
#			datatype = float          
#			data = (datatype(row[column]) for row in incsv)    # NB: a generator expressioin, not a list
#			dataN = data[1:]
#			print sum(dataN) / len(dataN) 	
#	least_value = min(data)
#	print least_value

		

		

#with open('timing.csv', 'rb') as inf:
#	incsv = csv.reader(inf)
#	column = 0                # the second column (Python counts from 0, per @MRAB's comment)
#	datatype = float          # or int, as appropriate (per MvG)
#	data = (datatype(row[column]) for row in incsv)    # NB: a generator expression, not a list
#	least_value = min(data)
#	print least_value


	#for word in array:
