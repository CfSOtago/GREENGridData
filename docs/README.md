# NZ GREEN Grid Household Electricity Demand Study: Data R Package

This package contains the code used to prepare a cleaned, anonymised data archive from the [NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study. This archive is (will be) available for third party research use via the UK Data Service's ReShare service. The data processing code auto-generates a number of reports which form the data documentation.

[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) household electricity demand study data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [GridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Dwelling & appliance surveys
 * Occupant time-use diaries (focused on energy use)

----
## Publications to date

 * Giraldo Ocampo, Diana. 2015. “[Developing an Energy-Related Time-Use Diary for Gaining Insights into New Zealand Households’ Electricity Consumption](http://hdl.handle.net/10523/5957).” Master’s thesis, Centre for Sustainability: University of Otago;
 * Jack, M. W., K. Suomalainen, J. J. W. Dew, and D. Eyers. 2018. “[A Minimal Simulation of the Electricity Demand of a Domestic Hot Water Cylinder for Smart Control]((https://www.sciencedirect.com/science/article/pii/S0306261917316197)).” Applied Energy 211: 104–12;
 * Stephenson, Janet, Rebecca Ford, Nirmal-Kumar Nair, Neville Watson, Alan Wood, and Allan Miller. 2017. “[Smart Grid Research in New Zealand–A Review from the GREEN Grid Research Programme](https://doi.org/10.1016/j.rser.2017.07.010).” Renewable and Sustainable Energy Reviews 82 (1): 1636–45;
 * Suomalainen, Kiti, Michael Jack, David Byers, Rebecca Ford, and Janet Stephenson. 2017. “[Comparative Analysis of Monitored and Self-Reported Data on Electricity Use](https://ieeexplore.ieee.org/document/7977557/).” In Environment and Electrical Engineering and 2017 IEEE Industrial and Commercial Power Systems Europe (EEEIC/I&CPS Europe), 2017 IEEE International Conference on, 1–4. IEEE.

## Data archives

See:

* Anderson, Ben and Eyers, David and Ford, Rebecca and Giraldo Ocampo, Diana and Peniamina, Rana and Stephenson, Janet and Suomalainen, Kiti and Wilcocks, Lara and Jack, Michael (2018). [New Zealand grid household electricity demand study 2014-2018](https://dx.doi.org/10.5255/UKDA-SN-853334). [Data Collection]. Colchester, Essex: UK Data Service. 10.5255/UKDA-SN-853334

Check that the versions of the reports match the version of the data you have access to.

### Version 1 - August 2018

Access to the data:

 * Version 1 od the [data](https://dx.doi.org/10.5255/UKDA-SN-853334) includes:
   - powerData.zip: 1 minute power demand data for each circuit in each household. One file per household;
   - ggHouseholdAttributesSafe.csv.zip: anonymised household attribute data;
   - checkPlots.zip: 
      - simple line charts of mean power per month per year for each circuit monitored for each household. These are a useful check;
      - tile plots (heat maps/carpet plots) of the number of observations per hour per day. Also a useful check...

Terms of Use:

This is _not_ open access data. It is, however, licensed under the minimally restrictive:

 * Safeguarded data: licenced under the [UK Data Archive End User Licence conditions](http://reshare.ukdataservice.ac.uk/legal/#Safeguarded)

In using the data you (will) agree to these T&Cs.

Documentation:

 * [Research data overview](overviewReport_v1.0.html) report;
 * [Household electricity demand data](gridSpy1mProcessingReport_v1.0.html) processing and documentation report;
 * [Household attribute data](householdAttributeProcessingReport_v1.0.html) processing and documentation report.

> NB: Version 1 of the data package does not include any time-use diary data. 

## Code

NB: *None* of the data is held in this repo so *none* of the code below will work unless you also have access to the data. 

 * The [GREEN Grid Data R Package](https://github.com/CfSOtago/GREENGridData) can be forked, cloned or installed as an R package. Amongst other things it contains:
    - dataProcessing - R scripts to process data and generate data quality reports. These will not run without access to the original study data but you can review them to understand why the anonymised data looks the way it does;
    - docs - the data archive documentation published via the [github pages](https://cfsotago.github.io/GREENGridData/) that you are now reading;
    - examples - R script examples to show how the clean anonymised data can be analysed.

We encourage [feedback](https://github.com/CfSOtago/GREENGridData/issues) and [contributions](https://github.com/CfSOtago/GREENGridData/pulls) but inevitably #[YMMV](https://en.wiktionary.org/wiki/YMMV).
