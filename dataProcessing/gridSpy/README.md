# NZ GREEN Grid Household Electricity Demand Study: Data R Package

## 1 minute electricity power (W) data

The code here processes the original Grid Spy data files to produce the ['safe' form held on the UK Data Service](http://reshare.ukdataservice.ac.uk/853334/). To do this it:

 * checks the available files
 * skips files which do not contain data (grid spy files are empty .xml if no data is available for a given household)
 * imputes data and time formats
 * loads all data for a given household
 * cleans the data
 * saves the data for each household to 1 file
 * saves meta data on each file processed
 * saves two checkPlots for each household as a very useful eye-ball of data quality and power demand profiles

The code makes extensive use of package functions. You will need to look at the [package function code](../../R/) to understand what has been done.

We keep a log of [issues](https://github.com/dataknut/nzGREENGridDataR/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3AgridSpy) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/dataknut/nzGREENGridDataR/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3AgridSpy).

## Known issues

### Monitor re-use

Two Grid Spy monitoring kits were re-used during the project. These were:

 * rf_15 
 * rf_17

The household attribute data provides information on the dates these were switched to new households and the relevant [checkPlots](../../checkPlots) also give you a clue.
