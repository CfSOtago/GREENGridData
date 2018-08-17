# nzGREENGridDataR - The GREEN Grid Data R Package

This package contains the code used to prepare a cleaned, anonymised data package from the [NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study. This package is (will be) available for third party research use via the UK Dataservice's ReShare service. The data processing code auto-generates a number of reports which form the data documentation.

[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [GridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Dwelling & appliance surveys
 * Occupant time-use diaries (focused on energy use)

NB: Version 1 of the data package does not include the time-use diaries.

----

## Documentation

The most recent versions of the data documentation:

 * [Project and research data overview](ggOverviewReport.html) report
 * [Grid Spy data processing](gridSpy1mProcessingReport.html) report
 * [Survey data processing](surveyProcessingReport.html) report
 
Check that the versions of the reports match the version of the data you have access to.

## Data

Access to the data:

 * Link to anonymised data package (when live via [ReShare](http://reshare.ukdataservice.ac.uk/))

## Code

 * The [GREEN Grid Data R Package](https://github.com/dataknut/nzGREENGridDataR) can be forked, cloned or installed as an R package. We encourage feedback and contributions but inevitably #YMMV;
 * NB: *None* of the data is held in this repo so *none* of the code here will work unless you also have access to the data. 
