# NZ GREEN Grid Household Electricity Demand Study: Data R Package

# imputeTotalPower.R
This script imputes the total power demand per household for each 1 minute period and creates a new data file with the total appended to the cleaned data. This data is _not_ in the [reshare archive held on the UK Data Service](http://reshare.ukdataservice.ac.uk/853334/) as you can create it easily from the archived data using this code.

It uses a circuits-to-sum definition file from the /data folder to do so. Reports on the results of doing so can be found at https://cfsotago.github.io/GREENGridData/. 

## processGridSpy1mData.R

(called from makeFile_processGridSpy1mData.R)

This code processes the original Grid Spy data files to produce the ['safe' form held on the UK Data Service](http://reshare.ukdataservice.ac.uk/853334/). To do this it:

 * checks the available files
 * skips files which do not contain data (grid spy files are empty .xml if no data is available for a given household)
 * imputes data and time formats
 * loads all data for a given household
 * cleans the data
 * saves the data for each household to 1 file
 * saves meta data on each file processed
 * saves several checkPlots for each household as a very useful eye-ball of data quality, circuit labels and power demand profiles

The code makes extensive use of package functions. You will need to look at the [package function code](../../R/) to understand what has been done. You will _not_ be able to run this code without access to the original Grid Spy data held on University of Otago's restricted-access High-Capacity Storage [(HCS) filestore](https://www.otago.ac.nz/its/services/hosting/otago068353.html).



# Issues

We keep a log of [issues](https://github.com/CfSOtago/GREENGridData/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3AgridSpy) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/CfSOtago/GREENGridData/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3AgridSpy).
