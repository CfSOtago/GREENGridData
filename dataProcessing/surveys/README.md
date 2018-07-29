# NZ GREEN Grid Data processing code
[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys

NB: *None* of the data is held in this repo so *none* of the code here will work unless you also have access to the data.

## Household attributes

The code in this folder constructs (and describes) the available household attribute data collected during the project. It saves the data as a .csv file and produces a [report](../../reports/surveyProcessingReport.pdf).

The code maked extensive use of package functions. You will need to look at the [package function code](../../R/) to understand what has been done.

We keep a log of [issues](https://github.com/dataknut/nzGREENGridDataR/issues?q=is%3Aissue+label%3AhhAttributes) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/dataknut/nzGREENGridDataR/issues?q=is%3Aissue+label%3AhhAttributes).

## Known issues

### Monitor re-use

Two Grid Spy monitoring kits were re-used during the project. These were:

 * rf_15 
 * rf_17

The household attribute data provides information on the dates these were switched to new households (see the household attribute [report](../../reports/surveyProcessingReport.pdf)). The relevant [checkPlots](../../checkPlots) also give you a clue.