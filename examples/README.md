# # NZ GREEN Grid Household Electricity Demand Study: Data R Package
[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys

NB: *None* of the data is held in this repo so *none* of the code here will work unless you also have access to the data.

## Example code

The code in this folder provides R/Rmd code for simple extraction and analysis of the cleaned safe project data. You can probably find better (and quicker) ways to do this. #YMMV.

 * extractCleanGridSpy1minCircuits.R - searches across the safe grid spy data for a given string in the circuit labels between two dates (inclusive). It saves the results as a .csv.gz file. Has been used to extract 'Heat Pump' and 'Hot Water' profiles. This code is best run from the command line e.g. using `> Rscript extractCleanGridSpy1minCircuits.R` (more info on [Rscript](https://www.rdocumentation.org/packages/utils/versions/3.5.1/topics/Rscript));
 * testHouseholdPower.Rmd - loads a given grid spy data file and produces a mean power (W) profile plot for all circuits by year and month. Produces the matching pdf output.

The code maked extensive use of package functions. You will need to look at the [package function code](../../R/) to understand what has been done.

We keep a log of [issues](https://github.com/dataknut/nzGREENGridDataR/issues?q=is%3Aissue+label%3Aexamples) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/dataknut/nzGREENGridDataR/issues?q=is%3Aissue+label%3Aexamples).

## Known issues
