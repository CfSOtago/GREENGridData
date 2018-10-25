# NZ GREEN Grid Household Electricity Demand Study: Data R Package

This package contains the code used to prepare a cleaned, anonymised data archive from the [NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study. This archive is available for third party research use via the UK Data Service's [ReShare](http://reshare.ukdataservice.ac.uk/) service.

[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [GridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Dwelling & appliance surveys
 * Occupant time-use diaries (focused on energy use)

----
## Data archives

The data is archived as:

 * Anderson, Ben and Eyers, David and Ford, Rebecca and Giraldo Ocampo, Diana and Peniamina, Rana and Stephenson, Janet and Suomalainen, Kiti and Wilcocks, Lara and Jack, Michael (2018). [New Zealand GREEN Grid household electricity demand study 2014-2018](https://dx.doi.org/10.5255/UKDA-SN-853334). [Data Collection]. Colchester, Essex: UK Data Service. DOI: [10.5255/UKDA-SN-853334](https://dx.doi.org/10.5255/UKDA-SN-853334)

You will need to register for a (free) UK Data Service account before you can download it. Despite appearances, users from outside the UK _can_ register and download the data but will need to use a [specific form to request a UK Data Service user id](https://beta.ukdataservice.ac.uk/myaccount/credentials). One registered you should be able to log in and download the data.

Please document any errors, problems or queries by raising a [github issue](https://github.com/CfSOtago/GREENGridData/issues) and we will try to respond.

### Version 1 - September 2018

_Access to the data_:

Version 1 of the [data archive](https://dx.doi.org/10.5255/UKDA-SN-853334) includes:
 
 * powerData.zip: 1 minute power demand data for each circuit in each household. One file per household;
 * ggHouseholdAttributesSafe.csv.zip: anonymised household attribute data;
 * checkPlots.zip: 
   - simple line charts of mean power per month per year for each circuit monitored for each household. These are a useful check;
   - tile plots (heat maps/carpet plots) of the number of observations per hour per day. Also a useful check...
 * PDF snapshots of the _live documentation_ found below. 

_Terms of Use_:

This is _not_ open access data. It is, however, licensed as _Safeguarded_ data under the [UK Data Archive End User Licence conditions](http://reshare.ukdataservice.ac.uk/legal/#Safeguarded). You will need to agree to these T&Cs before downloading the data.

_Documentation_:

 * [Research data overview](overviewReport_v1.0.html) report;
 * [Household electricity demand data](gridSpy1mProcessingReport_v1.0.html) processing and documentation report;
 * [Household attribute data](householdAttributeProcessingReport_v1.0.html) processing and documentation report.

> NB: Version 1 of the data package does not include any time-use diary data. 

_Known Problems_:

 * rf_15 & rf_17 grid spy files are in archive and should not be. [Details...](https://github.com/CfSOtago/GREENGridData/issues/19)
 * For others see our [issue list](https://github.com/CfSOtago/GREENGridData/issues?q=is%3Aissue+label%3AdataIssue)
 
## Code repository

NB: *None* of the data is held in this repo so *none* of the code below will work unless you also have access to the data. 

The [GREEN Grid Data R Package](https://github.com/CfSOtago/GREENGridData) can be forked, cloned or installed as an R package. Amongst other things it contains:
 * dataProcessing - R scripts to process data and generate data quality reports. These will not run without access to the original study data but you can review them to understand why the anonymised data looks the way it does;
 * docs - the data archive documentation published via the [github pages](https://cfsotago.github.io/GREENGridData/) that you are now reading;
 * examples - R script examples to show how the clean anonymised data can be analysed.

We encourage [feedback](https://github.com/CfSOtago/GREENGridData/issues) and [contributions](https://github.com/CfSOtago/GREENGridData/pulls) but inevitably #[YMMV](https://en.wiktionary.org/wiki/YMMV).

## Publications to date

 * Anderson, Ben and Eyers, David and Ford, Rebecca and Giraldo Ocampo, Diana and Peniamina, Rana and Stephenson, Janet and Suomalainen, Kiti and Wilcocks, Lara and Jack, Michael (2018). [_New Zealand grid household electricity demand study 2014-2018_](https://dx.doi.org/10.5255/UKDA-SN-853334). [Data Collection]. Colchester, Essex: UK Data Service. DOI: [10.5255/UKDA-SN-853334](https://dx.doi.org/10.5255/UKDA-SN-853334)
 * Jack, Michael & Suomalainen, Kiti (2018). [Potential future changes to residential electricity load profiles – findings from the GridSpy dataset](http://hdl.handle.net/10523/8074). NZ GREEN Grid Technical Report, University of Otago.
 * Jack, M. W., K. Suomalainen, J. J. W. Dew, and D. Eyers. 2018. “[A Minimal Simulation of the Electricity Demand of a Domestic Hot Water Cylinder for Smart Control]((https://www.sciencedirect.com/science/article/pii/S0306261917316197)).” Applied Energy 211: 104–12;
 * Stephenson, Janet, Rebecca Ford, Nirmal-Kumar Nair, Neville Watson, Alan Wood, and Allan Miller. 2017. “[Smart Grid Research in New Zealand–A Review from the GREEN Grid Research Programme](https://doi.org/10.1016/j.rser.2017.07.010).” Renewable and Sustainable Energy Reviews 82 (1): 1636–45;
 * Suomalainen, Kiti, Michael Jack, David Byers, Rebecca Ford, and Janet Stephenson. 2017. “[Comparative Analysis of Monitored and Self-Reported Data on Electricity Use](https://ieeexplore.ieee.org/document/7977557/).” In Environment and Electrical Engineering and 2017 IEEE Industrial and Commercial Power Systems Europe (EEEIC/I&CPS Europe), 2017 IEEE International Conference on 6-9 June 2017. IEEE;
 * Giraldo Ocampo, Diana. 2015. “[Developing an Energy-Related Time-Use Diary for Gaining Insights into New Zealand Households’ Electricity Consumption](http://hdl.handle.net/10523/5957).” Master’s thesis, Centre for Sustainability: University of Otago.
