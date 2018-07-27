---
params:
  localData: ""
title: 'Processing report: NZ GREEN Grid project 1 minute electricity
  power data'
author: 'Ben Anderson (b.anderson@soton.ac.uk, `@dataknut`)'
date: 'Last run at: 2018-07-27 11:42:51'
output:
  html_document:
    code_folding: hide
    fig_caption: true
    keep_md: true
    number_sections: true
    self_contained: no
    toc: true
    toc_float: true
    toc_depth: 2
  pdf_document:
    fig_caption: yes
    keep_tex: yes
    number_sections: yes
    toc: yes
    toc_depth: 2
bibliography: '/Users/ben/bibliography.bib'
---






\newpage

# Report circulation:

 * Public
 
# License


This work is made available under the Creative Commons [Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License](https://creativecommons.org/licenses/by-sa/4.0/).

This means you are free to:

 * _Share_ — copy and redistribute the material in any medium or format
 * _Adapt_ — remix, transform, and build upon the material for any purpose, even commercially.
 
Under the following terms:

 * _Attribution_ — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
 * ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
 * No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

## Notices:

 * You do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation.
 * No warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material. #YMMV

For the avoidance of doubt and explanation of terms please refer to the full [license notice](https://creativecommons.org/licenses/by-sa/4.0/) and [legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode).
 
# Citation

If you wish to use any of the material from this report please cite as:

 * Anderson, B. (2018) Processing report: NZ GREEN Grid project 1 minute electricity  power data, [Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/), University of Otago: Dunedin. XX replace with UKDA DOI when available XX

\newpage

# Introduction


The NZ GREEN Grid project recruited a sample of c 25 households in each of two regions of New Zealand. The first sample was recruited in early 2014 and the second in early 2015. Research data includes:

 * 1 minute electricity power (W) data was collected for each dwelling circuit using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power). The power values represent mean(W) over the minute preceeding the observation timestamp.
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys
 
We are working towards releasing 'clean' (anonymised) versions of this research data for re-use.
 

## Purpose

This report is intended to produce summary data quality statistics for the original GREEN grid Grid Spy household power demand monitoring data. This data was used to create a derived 'safe' dataset using the code in the [nzGREENGridDataR](https://github.com/dataknut/nzGREENGridDataR) repository.

The cleaned 'safe' data has _no_ identifying information such as names, addresses, email addresses, telephone numbers and is therefore safe to share across all partners and to archive/release for research purposes via the UK Data Service's [ReShare](http://reshare.ukdataservice.ac.uk/) service.

The data contains a unique household id which can be used to link it to the anonymised NZ GREEN Grid household level data which will also be archived/release for research purposes via the UK Data Service's [ReShare](http://reshare.ukdataservice.ac.uk/) service.

## Requirements:

This report uses data quality statistics produced when processing the original grid spy 1 minute data downloads.

## History

Generally tracked via our github [repo](https://github.com/dataknut/nzGREENGridDataR):

 * [report history](https://github.com/dataknut/nzGREENGridDataR/commits/master/dataProcessing/gridSpy/buildGridSpy1mReport.Rmd)
 * [general issues](https://github.com/dataknut/nzGREENGridDataR/issues)
 
## Support



This work was supported by:

 * The [University of Otago](https://www.otago.ac.nz/);
 * The [University of Southampton](https://www.southampton.ac.uk/);
 * The New Zealand [Ministry of Business, Innovation and Employment (MBIE)](http://www.mbie.govt.nz/) through the [NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) project;
 * [SPATIALEC](http://www.energy.soton.ac.uk/tag/spatialec/) - a [Marie Skłodowska-Curie Global Fellowship](http://ec.europa.eu/research/mariecurieactions/about-msca/actions/if/index_en.htm) based at the University of Otago’s [Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/staff/otago673896.html) (2017-2019) & the University of Southampton's Sustainable Energy Research Group (2019-202).
 

# Original Data: Quality checks

The original data files files are stored on the University of Otago's High-Capacity Central File Storage [HCS](https://www.otago.ac.nz/its/services/hosting/otago068353.html) at:

 * ~/Data/NZGreenGrid/gridspy/1min_orig/

Data collection is ongoing and this section reports on the availability of data files collected up to the time at which the most recent safe file was created.


```
## Parsed with column specification:
## cols(
##   file = col_character(),
##   hhID = col_character(),
##   fileName = col_character(),
##   fullPath = col_character(),
##   fSize = col_integer(),
##   fMTime = col_datetime(format = ""),
##   fMDate = col_date(format = ""),
##   dateColName = col_character(),
##   dateExample = col_character(),
##   dateFormat = col_character()
## )
```

Overall we have 2,802 files from 5 households. However a large number of files contain no data as the monitoring devices have either been removed (households have moved or withdrawn from the study) or data transfer has failed. We therefore flag these files as 'to be ignored' as they have 1 of two file sizes (43 or 2751 bytes).

Of the 2,802 files,  2,125 (75.84%) were labelled as 'ignore' as their file sizes indicated that they contained no data.

## Data file quality checks

The following chart shows the distribution of all files over time using their sizes. Note that white indicates the presence of small files which may not contain observations.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/allFileSizesPlot-1.png)<!-- -->

```
## Saving 7 x 5 in image
```
As we can see, relatively large files were donwloaded (manually) in June and October 2016 before an automated download process was implemented from January 2017. 

The following chart shows the same chart but only for files which we think contain data.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/loadedFileSizesPlot-1.png)<!-- -->

```
## Saving 7 x 5 in image
```
As we can see this removes a large number of the autmatically downloaded files.

## Date format checks

As noted above, the original data was downloaded in two ways:

 * Manual download of large samples of data. In this case the dateTime of the observation appears to have been stored in NZ time and appears also to have varying dateTime formats (d/m/y, y/m/d etc);
 * Automatic download of daily data. In this case the dateTime of the observation is stored as UTC

Resolving and cleaning these variations and uncertainties have required substantial effort and in some cases the date has had to be inferred from the file names.

The following table lists up to 10 of the 'date NZ' files which are set by default - do they look OK to assume the default dateFormat? Compare the file names with the dateExample...


```r
# list default files with NZ time
aList <- fListCompleteDT[dateColName == "date NZ" & dateFormat %like% "default", 
                         .(file, fSize, dateColName, dateExample, dateFormat)]

cap <- paste0("First 10 (max) of ", nrow(aList), 
              " files with dateColName = 'date NZ' and default dateFormat")

knitr::kable(caption = cap, head(aList))
```



|file                             |    fSize|dateColName |dateExample |dateFormat                                |
|:--------------------------------|--------:|:-----------|:-----------|:-----------------------------------------|
|rf_01/1Jan2014-24May2014at1.csv  |  6255737|date NZ     |2014-01-06  |ymd - default (but day/month value <= 12) |
|rf_06/24May2014-24May2015at1.csv | 19398444|date NZ     |2014-06-09  |ymd - default (but day/month value <= 12) |

The following table lists up to 10 of the 'date UTC' files which are set by default - do they look OK to assume the default dateFormat? Compare the file names with the dateExample...


```r
# list default files with UTC time
aList <- fListCompleteDT[dateColName == "date UTC" & dateFormat %like% "default", 
                         .(file, fSize, dateColName, dateExample, dateFormat)]

cap <- paste0("First 10 (max) of ", nrow(aList), 
              " files with dateColName = 'date UTC' and default dateFormat")

knitr::kable(caption = cap, head(aList, 10))
```



|file                             |  fSize|dateColName |dateExample |dateFormat                                |
|:--------------------------------|------:|:-----------|:-----------|:-----------------------------------------|
|rf_06/10Apr2018-11Apr2018at1.csv | 156944|date UTC    |2018-04-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Dec2017-11Dec2017at1.csv | 156601|date UTC    |2017-12-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Feb2018-11Feb2018at1.csv | 153353|date UTC    |2018-02-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Jan2018-11Jan2018at1.csv | 153982|date UTC    |2018-01-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Jul2018-11Jul2018at1.csv | 158338|date UTC    |2018-07-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Jun2018-11Jun2018at1.csv | 156641|date UTC    |2018-06-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Mar2018-11Mar2018at1.csv | 156471|date UTC    |2018-03-09  |ymd - default (but day/month value <= 12) |
|rf_06/10May2018-11May2018at1.csv | 156683|date UTC    |2018-05-09  |ymd - default (but day/month value <= 12) |
|rf_06/10Nov2017-11Nov2017at1.csv | 155639|date UTC    |2017-11-09  |ymd - default (but day/month value <= 12) |
|rf_06/11Apr2018-12Apr2018at1.csv | 157181|date UTC    |2018-04-10  |ymd - default (but day/month value <= 12) |

After final cleaning, the final date formats are:


|dateColName                                                 |dateFormat                                | nFiles|minDate    |maxDate    |
|:-----------------------------------------------------------|:-----------------------------------------|------:|:----------|:----------|
|Unknown - ignore as fsize ( 2751 ) < dataThreshold ( 3000 ) |NA                                        |    604|NA         |NA         |
|Unknown - ignore as fsize ( 43 ) < dataThreshold ( 3000 )   |NA                                        |   1521|NA         |NA         |
|date NZ                                                     |dmy - definite                            |      1|27/03/2015 |27/03/2015 |
|date NZ                                                     |mdy - definite                            |      1|5/26/2016  |5/26/2016  |
|date NZ                                                     |ymd - default (but day/month value <= 12) |      2|2014-01-06 |2014-06-09 |
|date NZ                                                     |ymd - definite                            |      6|2014-05-24 |2016-05-26 |
|date UTC                                                    |dmy - inferred                            |      3|11-10-16   |24/03/15   |
|date UTC                                                    |ymd - default (but day/month value <= 12) |    265|2016-10-11 |2018-07-12 |
|date UTC                                                    |ymd - definite                            |    399|2015-05-24 |2018-07-17 |

Results to note:

 * The non-loaded files only have 2 distinct file sizes, confirming that they are unlikely to contain useful data. 
 * There are a range of dateTme formats - these are fixed in the data cleaning process
 * Following detailed checks there are now 0 files which are still labelled as having ambiguous dates;
 
# Processed Data: Quality checks

In this section we analyse the data files that have a file size > 3000 bytes and which have been used to create the safe data. Things to note:

 * As inidcated above, we assume that any files smaller than this value have no observations. This is based on:
     * Manual inspection of several small files
     * The identical (small) file sizes involved
 * We have had to deal with quite a lot of duplication some of which was caused by the different date formats, especially where they run through Daylight Savings Time (DST) changes.
 
The following table shows the number of files per household that are actually processed to make the safe version together with the min/max file save dates (not the observed data dates).


```r
# check files to load
t <- fListCompleteDT[dateColName %like% "date", .(nFiles = .N,
                       meanSize = mean(fSize),
                       minFileDate = min(fMDate),
                       maxFileDate = max(fMDate)), keyby = .(hhID)]

knitr::kable(caption = "Summary of household files to load", t)
```



|hhID  | nFiles|   meanSize|minFileDate |maxFileDate |
|:-----|------:|----------:|:-----------|:-----------|
|rf_01 |      3| 15548174.7|2016-09-20  |2016-09-30  |
|rf_06 |    256|   616879.7|2016-05-25  |2018-07-19  |
|rf_45 |      4| 10513812.0|2016-06-08  |2017-11-21  |
|rf_46 |    411|   605048.1|2016-06-08  |2018-02-21  |
|rf_47 |      3| 17544847.0|2016-05-25  |2016-09-20  |


## Circuit label checks

The following table shows the number of files for each household with different circuit labels. In theory each household should only have one set of unique circuit labels.


```
## Parsed with column specification:
## cols(
##   hhID = col_character(),
##   fullPath = col_character(),
##   nObs = col_integer(),
##   minDateTime = col_datetime(format = ""),
##   maxDateTime = col_datetime(format = ""),
##   TZ_orig = col_character(),
##   dateFormat = col_character(),
##   mDateTime = col_datetime(format = ""),
##   fSize = col_integer(),
##   nCircuits = col_integer(),
##   circuitLabels = col_character()
## )
```



|hhID  |circuitLabels                                                                                                                                                                                                                                                                                                                          | nFiles|
|:-----|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------:|
|rf_01 |Heating$1633, Hot water$1636, Kitchen power$1632, Lights$1635, Mains$1634, Range$1637                                                                                                                                                                                                                                                  |      3|
|rf_06 |Hot Water - Controlled$2248, Incomer - Uncontrolled$2249, Kitchen$2246, Laundry, Downstairs & Lounge$2245, Lighting$2244, Oven & Hob$2247                                                                                                                                                                                              |    256|
|rf_45 |Heat Pump$4160, Hot Water - Controlled$4158, Incomer - Uncontrolled$4157, Kitchen Appliances$4161, Laundry & Garage Fridge$4162, Lighting$4159                                                                                                                                                                                         |      4|
|rf_46 |Heat Pumps (2x) & Power$4232, Heat Pumps (2x) & Power$4399, Hot Water - Controlled$4231, Hot Water - Controlled$4400, Incomer - Uncontrolled$4230, Incomer - Uncontrolled$4401, Incomer Voltage$4405, Kitchen & Bedrooms$4229, Kitchen & Bedrooms$4402, Laundry & Bedrooms$4228, Laundry & Bedrooms$4403, Lighting$4233, Lighting$4404 |    411|
|rf_47 |Heat Pump & 2 x Bathroom Heat$4171, Incomer - All$4170, Kitchen Power & Heat, Lounge$4174, Laundry, Garage & 2 Bedrooms$4173, Lighting$4172, Wall Oven$4169                                                                                                                                                                            |      3|

Things to note:

 * rf_25 has an aditional unexpected "Incomer 1 - Uncontrolled$2757" circuit in some files but it's value is always NA so it has been ignored.
 * rf_46 had multiple circuit labels caused by apparent typos. These have been re-labelled.


If this is not the case then this implies that:

 * some of the circuit labels for these households may have been changed during the data collection process;
 * some of the circuit labels may have character conversion errors which have changed the labels during the data collection process;
 * at least one file from one household has been saved to a folder containing data from a different household (unfortunately the raw data files do _not_ contain household IDs in the data or the file names which would enable checking/preventative filtering). This will be visible in the table if two households appear to share _exactly_ the same list of circuit labels.

Some or all of these may be true at any given time.

Errors are easy to spot in the following plot where a hhID spans 2 or more circuit labels.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/plotCircuitLabelIssuesAsTile-1.png)<!-- -->

```
## Saving 7 x 8 in image
```

The following table provides more detail to aid error checking. Check for:

 * 2+ adjacent rows which have exactly the same circuit labels but different hh_ids. This implies some data from one household has been saved in the wrong folder;
 * 2+ adjacent rows which have different circuit labels but identical hh_ids. This could imply the same thing but is more likely to be errors/changes to the circuit labelling. 
 
If the above plot and this table flag a lot of errors then some re-naming of the circuit labels (column names) may be necessary. 

> NB: As before, the table is only legible in the html version of this report because latex does a very bad job of wrapping table cell text. A version is saved in /Users/ben/github/dataknut/nzGREENGridDataR/checkStats/circuitLabelMetaDataCheckTable.csv for viewing in e.g. xl.


|hhID  |circuitLabels                                                                                                                                                                                                                                                                                                                          | nFiles|minObsDate          |maxObsDate          |minFileDate         |maxFileDate         |    nObs|
|:-----|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------:|:-------------------|:-------------------|:-------------------|:-------------------|-------:|
|rf_01 |Heating$1633, Hot water$1636, Kitchen power$1632, Lights$1635, Mains$1634, Range$1637                                                                                                                                                                                                                                                  |      3|2014-01-05 11:00:00 |2015-10-20 02:50:00 |2016-09-20 02:58:11 |2016-09-30 00:16:15 |  855836|
|rf_06 |Hot Water - Controlled$2248, Incomer - Uncontrolled$2249, Kitchen$2246, Laundry, Downstairs & Lounge$2245, Lighting$2244, Oven & Hob$2247                                                                                                                                                                                              |    256|2014-06-08 12:00:00 |2018-07-19 11:59:00 |2016-05-25 10:26:07 |2018-07-19 16:03:06 | 3108716|
|rf_45 |Heat Pump$4160, Hot Water - Controlled$4158, Incomer - Uncontrolled$4157, Kitchen Appliances$4161, Laundry & Garage Fridge$4162, Lighting$4159                                                                                                                                                                                         |      4|2015-03-24 11:00:00 |2016-10-15 01:08:00 |2016-06-08 03:01:50 |2017-11-21 01:20:05 |  821472|
|rf_46 |Heat Pumps (2x) & Power$4232, Heat Pumps (2x) & Power$4399, Hot Water - Controlled$4231, Hot Water - Controlled$4400, Incomer - Uncontrolled$4230, Incomer - Uncontrolled$4401, Incomer Voltage$4405, Kitchen & Bedrooms$4229, Kitchen & Bedrooms$4402, Laundry & Bedrooms$4228, Laundry & Bedrooms$4403, Lighting$4233, Lighting$4404 |    411|2015-03-26 11:00:00 |2018-02-19 22:08:00 |2016-06-08 03:11:57 |2018-02-21 15:03:24 | 2529107|
|rf_47 |Heat Pump & 2 x Bathroom Heat$4171, Incomer - All$4170, Kitchen Power & Heat, Lounge$4174, Laundry, Garage & 2 Bedrooms$4173, Lighting$4172, Wall Oven$4169                                                                                                                                                                            |      3|2015-03-24 11:00:00 |2016-05-08 02:38:00 |2016-05-25 04:53:18 |2016-09-20 02:51:12 | 1180942|

 
## Observations

The following plots show the number of observations per day per household. In theory we should not see:

 * dates before 2014 or in to the future. These may indicate:
    * date conversion errors;
 * more than 1440 observations per day. These may indicate:
    * duplicate time stamps - i.e. they have the same time stamps but different power (W) values or different circuit labels. These may be expected around the DST changes in April/September. These can be examined on a per household basis using the rf_xx_timePlot.png plots to be found in the repo [checkPlots](https://github.com/dataknut/nzGREENGridDataR/tree/master/dataProcessing/gridSpy/checkPlots) folder;
    * observations from files that are in the 'wrong' rf_XX folder and so are included in the 'wrong' household as 'duplicate' time stamps.

If present both of the latter may have been implied by the table above and would have evaded the de-duplication filter which simply checks each complete row against all others within it's consolidated household dataset (a _within household absolute duplicate_ check).


```
## Parsed with column specification:
## cols(
##   hhID = col_character(),
##   date = col_date(format = ""),
##   nObs = col_integer(),
##   meanPower = col_double(),
##   sdPowerW = col_double(),
##   minPowerW = col_double(),
##   maxPowerW = col_double(),
##   circuitLabels = col_character(),
##   nCircuits = col_integer()
## )
```

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/loadedFilesObsPlots-1.png)<!-- -->

```
## Saving 7 x 5 in image
```

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/loadedFilesObsPlots-2.png)<!-- -->

```
## Saving 7 x 5 in image
```

The following table shows the min/max observations per day and min/max dates for each household. As above, we should not see:

 * dates before 2014 or in to the future (indicates date conversion errors)
 * more than 1440 observations per day (indicates potentially duplicate observations)
 * non-integer counts of circuits as it suggests some column errors
 
 We should also not see NA in any row (indicates date conversion errors). 
 
 If we do see any of these then we still have data cleaning work to do!


|hhID  | minObs| maxObs| meanN_Circuits|minDate    |maxDate    |
|:-----|------:|------:|--------------:|:----------|:----------|
|rf_01 |     12|   8871|        6.00000|2014-01-06 |2015-10-20 |
|rf_06 |   2460|   8825|        6.00000|2014-06-09 |2018-07-19 |
|rf_45 |   4770|   8758|        6.00000|2015-03-25 |2016-10-15 |
|rf_46 |   2526|  19357|       12.84489|2015-03-27 |2018-02-20 |
|rf_47 |   3156|   8818|        6.00000|2015-03-25 |2016-05-08 |


Finally we show the total number of households which we think are still sending data.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/liveDataHouseholds-1.png)<!-- -->

```
## Saving 7 x 5 in image
```

# Runtime




Analysis completed in 12.18 seconds ( 0.2 minutes) using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com) with R version 3.5.0 (2018-04-23) running on x86_64-apple-darwin15.6.0.

# R environment

R packages used:

 * base R - for the basics [@baseR]
 * data.table - for fast (big) data handling [@data.table]
 * lubridate - date manipulation [@lubridate]
 * ggplot2 - for slick graphics [@ggplot2]
 * readr - for csv reading/writing [@readr]
 * dplyr - for select and contains [@dplyr]
 * progress - for progress bars [@progress]
 * knitr - to create this document & neat tables [@knitr]
 * kableExtra - for extra neat tables [@kableExtra]
 * nzGREENGrid - for local NZ GREEN Grid project utilities

Session info:


```
## R version 3.5.0 (2018-04-23)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: macOS High Sierra 10.13.6
## 
## Matrix products: default
## BLAS: /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.5/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] kableExtra_0.9.0       knitr_1.20             readr_1.1.1           
##  [4] nzGREENGrid_0.1.0      rmarkdown_1.10         ggplot2_2.2.1         
##  [7] hms_0.4.2              lubridate_1.7.4        dplyr_0.7.5           
## [10] data.table_1.11.4      nzGREENGridDataR_0.1.0
## 
## loaded via a namespace (and not attached):
##  [1] progress_1.2.0    tidyselect_0.2.4  reshape2_1.4.3   
##  [4] purrr_0.2.5       lattice_0.20-35   colorspace_1.3-2 
##  [7] viridisLite_0.3.0 htmltools_0.3.6   yaml_2.1.19      
## [10] rlang_0.2.1       pillar_1.2.3      glue_1.2.0       
## [13] sp_1.3-1          bindrcpp_0.2.2    jpeg_0.1-8       
## [16] bindr_0.1.1       plyr_1.8.4        stringr_1.3.1    
## [19] munsell_0.5.0     gtable_0.2.0      rvest_0.3.2      
## [22] RgoogleMaps_1.4.2 mapproj_1.2.6     evaluate_0.10.1  
## [25] labeling_0.3      highr_0.7         proto_1.0.0      
## [28] Rcpp_0.12.17      geosphere_1.5-7   openssl_1.0.1    
## [31] backports_1.1.2   scales_0.5.0      rjson_0.2.20     
## [34] png_0.1-7         digest_0.6.15     stringi_1.2.3    
## [37] grid_3.5.0        rprojroot_1.3-2   tools_3.5.0      
## [40] magrittr_1.5      maps_3.3.0        lazyeval_0.2.1   
## [43] tibble_1.4.2      crayon_1.3.4      pkgconfig_2.0.1  
## [46] xml2_1.2.0        prettyunits_1.0.2 assertthat_0.2.0 
## [49] httr_1.3.1        rstudioapi_0.7    R6_2.2.2         
## [52] ggmap_2.6.1       compiler_3.5.0
```

# References
