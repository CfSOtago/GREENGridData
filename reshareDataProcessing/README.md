# NZ GREEN Grid Household Electricity Demand Study: Data R Package

## Example code

The scripts in the `code` folder provide example R/Rmd code for simple extraction and analysis of the cleaned [safe project data](http://reshare.ukdataservice.ac.uk/853334/). To use the code you will need to:

 * [register](https://beta.ukdataservice.ac.uk/myaccount/credentials) to use and download the [data](http://reshare.ukdataservice.ac.uk/853334/);
 * install the [GREEN Grid R data package](https://github.com/CfSOtago/GREENGridData);
 * adjust the file paths to suit your local setup before running the code. 
 
The code makes extensive use of package functions so make sure you install it first. You may need to look at the [package function code](../R/) to understand what these do.

The code also generally uses the extremely fast [data.table](https://rdatatable.gitlab.io/data.table/) instead of [readr](https://readr.tidyverse.org/) (for loading data) and [dplyr]https://dplyr.tidyverse.org/ (for processing data) so be warned.

Outputs from the scripts can be found in the `outputs` folder for reference.

### imputeTotalPower.R
This script imputes the total power demand per household for each 1 minute period and creates a new data file for each household with just the total imputed power for each minute. It also creates a single (_very large_) file of all imputed power per minute for all households. This data is _not_ in the [reshare archive held on the UK Data Service](http://reshare.ukdataservice.ac.uk/853334/) as you can create it easily from the archived data using this code.

The code uses a circuits-to-sum definition file from the [/publicData](https://github.com/dataknut/GREENGridData/tree/master/publicData) folder to do so. Reports on the results of doing so can be found at https://cfsotago.github.io/GREENGridData/. 

### settingTimezones1minPower.R

Gives examples of how to set timezones when analysing the data in a timezone other than "Pacific/Auckland".

### testHousehold1minPower.R
R script which runs the .Rmd file of the same name with parameters to load a given household's Grid Spy data file and creates a mean power (W) profile plot for all circuits by year and month - very useful for data checking. It also shows how to link the Grid Spy data to the household's attribute data.

### extractCircuitFrom1minPower.R

Searches across the safe Grid Spy data for a given string in the circuit labels between two dates (inclusive). It saves the results as a .csv.gz file. Has been tested for 'Heat Pump' and 'Hot Water'. This code is best run from the command line e.g. using `> Rscript extractCleanGridSpy1minCircuit.R` (more info on [Rscript](https://www.rdocumentation.org/packages/utils/versions/3.5.1/topics/Rscript))

### testCircuitExtract.R

R script which runs the .Rmd file of the same name with parameters to use a pre-extracted `circuit` circuit data (created using the above `extractCleanGridSpy1minCircuit.R` script) and the household attribute data to conduct basic analysis of electricity demand.

### linkCircuitExtractToHouseholds.R

Links an extracted circuits file (see above) to household data for further analysis.

### codeHouseholdAttributes.R
Coding of household (category) variables
 
### testHouseholdAttributes.R

Test analysis of household (category) variables

### Other

There are also some .Rmd examples which test the results of the data extraction and processing.

You can probably find better (and quicker) ways to do these. #YMMV.

### Issues

We keep a log of [issues](https://github.com/CfSOtago/GREENGridData/issues) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/CfSOtago/GREENGridData/issues).

