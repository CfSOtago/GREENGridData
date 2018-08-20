# NZ GREEN Grid Household Electricity Demand Study: Data R Package

This package contains the code used to prepare a cleaned, anonymised data archive from the [NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study. This archive is (will be) available for third party research use via the UK Data Service's ReShare service. The data processing code auto-generates a number of reports which form the data documentation.

[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [GridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Dwelling & appliance surveys
 * Occupant time-use diaries (focused on energy use)

----
## Data archives

Check that the versions of the reports match the version of the data you have access to.

### Version 1 - August 2018

Access to the data:

 * Link to anonymised data archive (when live via [ReShare](http://reshare.ukdataservice.ac.uk/))
 
Details:

 * [Research data overview](overviewReport_v1.0.html) report;
 * [Grid Spy data](gridSpy1mProcessingReport_v1.0.html) processing and documentation report;
 * [Survey data](surveyProcessingReport_v1.0.html) processing and documentation report.

Version 1 of the data package does not include the time-use diaries. 

## Code

NB: *None* of the data is held in this repo so *none* of the code below will work unless you also have access to the data. 

 * The [GREEN Grid Data R Package](https://github.com/CfSOtago/GREENGridData) can be forked, cloned or installed as an R package. Amongst other things it contains:
    - dataProcessing - R scripts to process data and generate data quality reports. These will not run without access to the original study data but you can review them to understand why the anonymised data looks the way it does;
    - docs - the data archive documentation published via the [github pages](https://cfsotago.github.io/GREENGridData/) that you are now reading;
    - examples - R script examples to show how the clean anonymised data can be analysed.

We encourage [feedback](https://github.com/CfSOtago/GREENGridData/issues) and [contributions](https://github.com/CfSOtago/GREENGridData/pulls) but inevitably #[YMMV](https://en.wiktionary.org/wiki/YMMV).
