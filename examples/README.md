# NZ GREEN Grid Household Electricity Demand Study: Data R Package
[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [Grid Spy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys

NB: *None* of the data is held in this repo so *none* of the code here will work unless you also have access to the data.

## Example code

The code in this folder provides R/Rmd code for simple extraction and analysis of the cleaned safe project data. You will need to download the [cleaned data package](https://cfsotago.github.io/GREENGridData/) and to adjust your file paths to suit your setup before running the code. The code makes extensive use of package functions so make sure you install it first. You may need to look at the [package function code](../R/) to understand what these do.

 * _testHouseholdPower.R_ - R script which runs the .Rmd file of the same name with parameters to load a given household's Grid Spy data file and creates a mean power (W) profile plot for all circuits by year and month - very useful for data checking. It also shows how to link the Grid Spy data to the households attribute data;
 * _extractCleanGridSpy1minCircuit.R_ - searches across the safe Grid Spy data for a given string in the circuit labels between two dates (inclusive). It saves the results as a .csv.gz file. Has been tested for 'Heat Pump' and 'Hot Water'. This code is best run from the command line e.g. using `> Rscript extractCleanGridSpy1minCircuit.R` (more info on [Rscript](https://www.rdocumentation.org/packages/utils/versions/3.5.1/topics/Rscript));
 * _testCircuitExtract.R_ - R script which runs the .Rmd file of the same name with parameters to use pre-extracted `circuit` circuit data (see extractCleanGridSpy1minCircuit.R) and the household attribute data to conduct basic analysis of electricity demand.
 * _extract_per_house_totals.r_ - example code to attempt to correctly sum the relevant circuits in each house to give total power demand at each r_dateTime. This make use of a .csv data table (see the package data folder) which specifies the circuits within each house.

You can probably find better (and quicker) ways to do these. #YMMV.

## Known issues

We keep a log of [issues](https://github.com/dataknut/nzGREENGridDataR/issues?q=is%3Aissue+label%3Aexamples) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/dataknut/nzGREENGridDataR/issues?q=is%3Aissue+label%3Aexamples).


