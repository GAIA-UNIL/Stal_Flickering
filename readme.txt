Written by G. Mariethoz, version 1.0, 2019

This is a set of Matlab functions to analyze the statistical properties of speleothem growth time series.  

The methodology followed is described in this article:
Mariethoz, G., B.F.J. Kelly, and A. Baker, 
Quantifying the value of laminated stalagmites for paleoclimate reconstructions. 
Geophysical Research Letters, 2012. 39(5).

Usage: 
All files should be in the same folder, including the data file as in .csv format.
Data file: should contain one column with laminates counts, and another column with the growth rates.
The main script to open is compute_stal_stats.m

The user should specify the following
line 3: the name of the data .csv file
line 4: the number of the column containing the date of each laminate
line 5: the number of the column containing the growth rates

