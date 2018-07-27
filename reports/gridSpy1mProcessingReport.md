---
params:
  localData: ""
title: 'Processing report: NZ GREEN Grid project 1 minute electricity
  power data'
author: 'Ben Anderson (b.anderson@soton.ac.uk, `@dataknut`)'
date: 'Last run at: 2018-07-27 16:06:11'
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

# About

## Report circulation:

 * Public - this report is intended to accompany the data release.
 
## License


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
 
## Citation

If you wish to use any of the material from this report please cite as:

 * Anderson, B. (2018) Processing report: NZ GREEN Grid project 1 minute electricity  power data, [Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/), University of Otago: Dunedin. 
 
> XX replace with UKDA DOI when available XX

## History

Code history is generally tracked via our github [repo](https://github.com/dataknut/nzGREENGridDataR):

 * [Report history](https://github.com/dataknut/nzGREENGridDataR/commits/master/dataProcessing/gridSpy/buildGridSpy1mReport.Rmd)
 * [General issues](https://github.com/dataknut/nzGREENGridDataR/issues)
 
## Requirements:

This report uses data quality statistics produced when processing the original grid spy 1 minute data downloads using https://github.com/dataknut/nzGREENGridDataR/blob/master/dataProcessing/gridSpy/processGridSpy1mData.R.

## Support


This work was supported by:

 * The [University of Otago](https://www.otago.ac.nz/);
 * The [University of Southampton](https://www.southampton.ac.uk/);
 * The New Zealand [Ministry of Business, Innovation and Employment (MBIE)](http://www.mbie.govt.nz/) through the [NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) project;
 * [SPATIALEC](http://www.energy.soton.ac.uk/tag/spatialec/) - a [Marie Skłodowska-Curie Global Fellowship](http://ec.europa.eu/research/mariecurieactions/about-msca/actions/if/index_en.htm) based at the University of Otago’s [Centre for Sustainability](http://www.otago.ac.nz/centre-sustainability/staff/otago673896.html) (2017-2019) & the University of Southampton's Sustainable Energy Research Group (2019-202).
 
\newpage

# Introduction


The NZ GREEN Grid project recruited a sample of c 25 households in each of two regions of New Zealand. The first sample was recruited in early 2014 and the second in early 2015. Research data includes:

 * 1 minute electricity power (W) data was collected for each dwelling circuit using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power). The power values represent mean(W) over the minute preceeding the observation timestamp.
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys
 
We are working towards releasing 'clean' (anonymised) versions of this research data for re-use.
 
This report provides summary data quality statistics for the original GREEN grid Grid Spy household power demand monitoring data. This data was used to create a derived 'safe' dataset using the code in the [nzGREENGridDataR](https://github.com/dataknut/nzGREENGridDataR) repository.

# Original Data: Quality checks

The original data files files are stored on the University of Otago's High-Capacity Central File Storage [HCS](https://www.otago.ac.nz/its/services/hosting/otago068353.html). The data used to generate this report was at:

 * /Volumes/hum-csafe/Research Projects/GREEN Grid/_RAW DATA/GridSpyData/


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
##   dateExample = col_date(format = ""),
##   dateFormat = col_character()
## )
```

```
## Warning in rbind(names(probs), probs_f): number of columns of result is not
## a multiple of vector length (arg 1)
```

```
## Warning: 31 parsing failures.
## row # A tibble: 5 x 5 col     row col         expected     actual   file                             expected   <int> <chr>       <chr>        <chr>    <chr>                            actual 1  1237 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… file 2  1802 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… row 3  2367 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… col 4  3499 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… expected 5  4066 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG…
## ... ................. ... .......................................................................... ........ .......................................................................... ...... .......................................................................... .... .......................................................................... ... .......................................................................... ... .......................................................................... ........ ..........................................................................
## See problems(...) for more details.
```

Data collection is ongoing and this section reports on the availability of data files collected up to the time at which the most recent safe file was created (2018-07-27 14:36:18).

Overall we have 24,884 files from 44 households. However a large number of files (14,752 or 59.28%) have 1 of two file sizes (43 or 2751 bytes) and we have determined that they contain no data as the monitoring devices have either been removed (households have moved or withdrawn from the study) or data transfer has failed. We therefore flag these files as 'to be ignored'.

## Input data file quality checks

The following chart shows the distribution of _all_ files over time using their sizes. Note that white indicates the presence of small files which may not contain observations.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/allFileSizesPlot-1.png)<!-- -->

```
## Saving 7 x 5 in image
```
As we can see, relatively large files were donwloaded (manually) in June and October 2016 before an automated download process was implemented from January 2017. A final manual download appears to have taken place in early December 2017.

The following chart shows the same chart but _only_ for files which we think contain data.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/loadedFileSizesPlot-1.png)<!-- -->

```
## Saving 7 x 5 in image
```
As we can see this removes a large number of the autmatically downloaded files.

## Input date format checks

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
|rf_02/1Jan2014-24May2014at1.csv  |  6131625|date NZ     |2014-03-03  |ymd - default (but day/month value <= 12) |
|rf_06/24May2014-24May2015at1.csv | 19398444|date NZ     |2014-06-09  |ymd - default (but day/month value <= 12) |
|rf_10/24May2014-24May2015at1.csv | 24386048|date NZ     |2014-07-09  |ymd - default (but day/month value <= 12) |
|rf_11/24May2014-24May2015at1.csv | 23693893|date NZ     |2014-07-08  |ymd - default (but day/month value <= 12) |
|rf_12/24May2014-24May2015at1.csv | 21191785|date NZ     |2014-07-09  |ymd - default (but day/month value <= 12) |

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


|dateColName                                                 |dateFormat                                | nFiles|meanFSizeKb |minFSizeKb |maxFSizeKb |minFDate   |maxFDate   |
|:-----------------------------------------------------------|:-----------------------------------------|------:|:-----------|:----------|:----------|:----------|:----------|
|Unknown - ignore as fsize ( 2751 ) < dataThreshold ( 3000 ) |NA                                        |   1812|2.686523    |2.686523   |2.686523   |2017-01-11 |2017-11-08 |
|Unknown - ignore as fsize ( 43 ) < dataThreshold ( 3000 )   |NA                                        |  12940|0.04199219  |0.04199219 |0.04199219 |2017-01-11 |2018-07-26 |
|date NZ                                                     |dmy - definite                            |      1|4,097.157   |4,097.157  |4,097.157  |2016-09-29 |2016-09-29 |
|date NZ                                                     |mdy - definite                            |      2|13,833.84   |9,067.765  |18,599.92  |2016-10-25 |2016-10-25 |
|date NZ                                                     |ymd - default (but day/month value <= 12) |     12|16,862.1    |2,652.745  |27,267.51  |2016-09-20 |2016-10-13 |
|date NZ                                                     |ymd - definite                            |     67|11,248.34   |228.9131   |31,502.92  |2016-09-19 |2016-10-13 |
|date UTC                                                    |dmy - inferred                            |     28|27,304.84   |569.8506   |53,282.66  |2016-05-25 |2017-11-21 |
|date UTC                                                    |ymd - default (but day/month value <= 12) |   3957|315.9203    |20.63379   |40,318.22  |2016-09-19 |2018-07-14 |
|date UTC                                                    |ymd - definite                            |   6065|294.3571    |21.20605   |50,810.54  |2016-06-08 |2018-07-26 |

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
|rf_02 |      3| 10134268.3|2016-09-20  |2016-09-30  |
|rf_06 |    263|   604662.9|2016-05-25  |2018-07-26  |
|rf_07 |    263|   645692.3|2016-05-25  |2018-07-26  |
|rf_08 |      5| 23989121.0|2016-05-25  |2017-11-21  |
|rf_09 |      2| 14344605.0|2016-09-21  |2016-09-21  |
|rf_10 |    358|   525455.0|2016-05-25  |2018-03-30  |
|rf_11 |    565|   387593.9|2016-05-25  |2018-07-26  |
|rf_12 |      2| 10713096.0|2016-09-21  |2016-09-21  |
|rf_13 |    497|   440250.0|2016-05-25  |2018-07-26  |
|rf_14 |    329|   424262.0|2016-06-08  |2017-12-31  |
|rf_15 |      2| 10553143.0|2016-09-21  |2016-09-21  |
|rf_16 |      1| 20037376.0|2016-09-20  |2016-09-20  |
|rf_17 |    234|   363774.8|2016-09-21  |2018-07-26  |
|rf_18 |      2| 14374309.5|2016-09-21  |2016-09-21  |
|rf_19 |    565|   513990.0|2016-05-25  |2018-07-26  |
|rf_20 |      2| 14665810.0|2016-09-21  |2016-09-21  |
|rf_21 |      4| 23058797.8|2016-05-25  |2016-10-12  |
|rf_22 |    371|   533704.5|2016-05-25  |2018-01-16  |
|rf_23 |    565|   400680.1|2016-05-25  |2018-07-26  |
|rf_24 |    533|   404668.3|2016-05-25  |2018-07-26  |
|rf_25 |      3| 12341581.3|2016-06-08  |2017-11-21  |
|rf_26 |    471|   365829.7|2016-05-25  |2018-07-26  |
|rf_27 |      3| 22607698.7|2016-05-25  |2016-09-21  |
|rf_28 |      2|  2297483.0|2016-06-08  |2016-09-19  |
|rf_29 |    555|   317248.0|2016-05-25  |2018-07-26  |
|rf_30 |      5| 13695336.0|2016-05-25  |2016-10-13  |
|rf_31 |    565|   314895.2|2016-05-25  |2018-07-26  |
|rf_32 |      2| 13934454.0|2016-06-08  |2016-09-20  |
|rf_33 |    530|   275592.6|2016-06-08  |2018-06-22  |
|rf_34 |      7| 14106275.3|2016-05-25  |2016-10-13  |
|rf_35 |    134|   573648.6|2016-05-25  |2017-11-21  |
|rf_36 |    490|   282969.5|2016-06-08  |2018-07-05  |
|rf_37 |    564|   280662.5|2016-06-08  |2018-07-26  |
|rf_38 |    201|   385707.5|2016-06-08  |2017-11-21  |
|rf_39 |    441|   339265.1|2016-05-25  |2018-07-26  |
|rf_40 |      2|  9299902.0|2016-06-08  |2016-09-20  |
|rf_41 |    556|   249753.1|2016-06-08  |2018-07-26  |
|rf_42 |     45|  1315953.6|2016-06-08  |2017-11-21  |
|rf_43 |      4|  9442492.0|2016-05-25  |2016-09-28  |
|rf_44 |    565|   315733.5|2016-05-25  |2018-07-26  |
|rf_45 |      4| 10513812.0|2016-06-08  |2017-11-21  |
|rf_46 |    411|   605048.1|2016-06-08  |2018-02-21  |
|rf_47 |      3| 17544847.0|2016-05-25  |2016-09-20  |


## Circuit label checks

The following table shows the number of files for each household with different circuit labels. In theory each household should only have one set of unique circuit labels. If not:

 * some of the circuit labels for these households may have been changed during the data collection process;
 * some of the circuit labels may have character conversion errors which have changed the labels during the data collection process;
 * at least one file from one household has been saved to a folder containing data from a different household (unfortunately the raw data files do _not_ contain household IDs in the data or the file names which would enable checking/preventative filtering). This will be visible in the table if two households appear to share _exactly_ the same list of circuit labels.

Some or all of these may be true at any given time.

> NB: The table is only legible in the html version of this report because latex does a very bad job of wrapping table cell text. A version is saved in https://github.com/dataknut/nzGREENGridDataR/tree/master/checkStats for viewing in e.g. xl.


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



|hhID  |circuitLabels                                                                                                                                                                                     | nFiles|minObsDate          |maxObsDate          |minFileDate         |maxFileDate         |    nObs|
|:-----|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------:|:-------------------|:-------------------|:-------------------|:-------------------|-------:|
|rf_01 |Heating$1633, Hot water$1636, Kitchen power$1632, Lights$1635, Mains$1634, Range$1637                                                                                                             |      3|2014-01-05 11:00:00 |2015-10-20 02:50:00 |2016-09-20 02:58:11 |2016-09-30 00:16:15 |  855836|
|rf_02 |Cooking Bath tile heat$1573, Fridge$1572, Heating$1576, Hot Water$1574, Lights$1577, Mains$1575                                                                                                   |      3|2014-03-02 11:00:00 |2015-05-28 04:23:00 |2016-09-20 02:53:43 |2016-09-30 00:14:19 |  592592|
|rf_06 |Hot Water - Controlled$2248, Incomer - Uncontrolled$2249, Kitchen$2246, Laundry, Downstairs & Lounge$2245, Lighting$2244, Oven & Hob$2247                                                         |    263|2014-06-08 12:00:00 |2018-07-26 11:59:00 |2016-05-25 10:26:07 |2018-07-26 16:03:04 | 3128876|
|rf_07 |Incomer 1 - Uncontrolled$2726, Incomer 2 - Uncontrolled$2725, Kitchen Appliances & Laundry$2722, Microwave$2721, Oven$2724, Workshop$2723                                                         |    263|2014-07-13 12:00:00 |2018-07-26 11:59:00 |2016-05-25 10:44:03 |2018-07-26 16:03:04 | 3380609|
|rf_08 |Heat Pump$2092, Hot Water - Controlled$2094, Incomer - Uncontrolled$2093, Kitchen$2089, Laundry & 2nd Fridge Freezer$2090, Oven & Hob$2091                                                        |      5|2014-05-28 12:00:00 |2017-05-15 02:02:00 |2016-05-25 05:48:18 |2017-11-21 01:09:19 | 2536195|
|rf_09 |Heat Pump & Bedroom 2$2731, Incomer 1 - Uncont - Inc Hob$2729, Incomer 2 - Uncont - Inc Oven$2730, Kitchen Appliances$2727, Laundry$2732, Lounge, Dining & Bedrooms$2728                          |      2|2014-07-13 12:00:00 |2015-07-16 02:42:00 |2016-09-21 01:26:07 |2016-09-21 01:26:55 |  529363|
|rf_10 |Bedrooms & Lounge$2602, Heat Pump$2598, Incomer - All$2599, Kitchen Appliances$2601, Laundry & Garage$2597, Oven$2600                                                                             |    358|2014-07-08 12:00:00 |2018-03-29 06:28:00 |2016-05-25 10:16:08 |2018-03-30 15:03:07 | 3734792|
|rf_11 |Heat Pump & Lounge$2590, Hob$2589, Hot Water Cpbd Heater- Cont$2586, Incomer - Uncontrolled$2585, Kitchen Appliances & Laundry$2588, Spa - Uncontrolled$2587                                      |    565|2014-07-07 12:00:00 |2018-07-26 11:59:00 |2016-05-25 06:15:06 |2018-07-26 16:03:06 | 4353936|
|rf_12 |Incomer 1 - Hot Water - Cont$2626, Incomer 2 - Uncontrolled$2625, Incomer 3 - Uncontrolled$2627, Kitchen Appliances & Lounge$2630, Laundry, Fridge & Microwave$2628, Oven$2629                    |      2|2014-07-08 12:00:00 |2015-06-02 20:07:00 |2016-09-21 00:44:42 |2016-09-21 00:46:01 |  410063|
|rf_13 |Downstairs (inc 1 Heat Pump)$2212, Hot Water - Controlled$2208, Incomer - Uncontrolled$2209, Kitchen & Laundry$2213, Oven & Hob$2210, Upstairs Heat Pumps$2211                                    |    497|2014-06-05 12:00:00 |2018-07-26 11:59:00 |2016-05-25 05:57:08 |2018-07-26 16:03:08 | 4060513|
|rf_14 |Hot Water - Controlled$2719, Incomer 1 - Uncont inc Stove$2718, Incomer 2 - Uncont inc Oven$2717, Kitchen Appliances$2715, Laundry & Microwave$2720, Power Outlets$2716                           |    329|2014-07-13 12:00:00 |2017-12-30 01:59:00 |2016-06-08 03:31:15 |2017-12-31 15:03:08 | 2654180|
|rf_15 |Hob$3954, Hot Water$3952, Incomer 1$3956, Incomer 2$3955, Laundry & Kitchen Appliances$3951, Oven$3953                                                                                            |      2|2015-01-14 11:00:00 |2016-04-18 20:37:00 |2016-09-21 00:47:53 |2016-09-21 00:49:20 |  395011|
|rf_16 |Hallway & Washing Machine$2683, Hot Water - Controlled$2679, Incomer 1 - Uncont inc Oven$2681, Incomer 2 - Uncont inc Stove$2680, Kitchen Appliances & Bedrooms$2684, Microwave & Breadmaker$2682 |      1|2014-07-09 12:00:00 |2015-03-25 20:22:00 |2016-09-20 23:51:39 |2016-09-20 23:51:39 |  373523|
|rf_17 |Heat Pump$2148, Hot Water - Controlled$2150, Incomer 1 - Uncont - inc Hob$2152, Incomer 2 - Uncont - inc Oven$2151, Kitchen Appliances$2147, Laundry$2149                                         |      2|2014-05-29 12:00:00 |2016-03-28 02:54:00 |2016-09-21 00:50:57 |2016-09-21 00:52:45 |  962873|
|rf_17 |Incomer 1 - inc Top Oven$5620, Incomer 2 - inc Bottom Oven$5621, Kitchen Appliances$5625, Laundry & Garage$5624, Lighting 1/2$5623, Lighting 2/2$5622                                             |    232|2016-10-11 11:00:00 |2018-07-26 05:31:00 |2017-01-11 00:08:08 |2018-07-26 16:03:09 |  795319|
|rf_18 |Hot Water - Controlled$2129, Incomer 1 - Uncontrolled$2128, Incomer 2 - Uncontrolled$2130, Kitchen Appliances & Ventilati$2131, Laundry & Hob$2133, Oven$2132                                     |      2|2014-05-29 12:00:00 |2015-06-11 02:36:00 |2016-09-21 00:56:19 |2016-09-21 00:57:41 |  543098|
|rf_19 |Bedroom & Lounge Heat Pumps$2741, Incomer 1 - All$2738, Incomer 2 - All$2737, Kitchen Appliances$2735, Laundry$2734, Oven$2736, PV 1$2739, PV 2$2733, Theatre Heat Pump$2740                      |    565|2014-07-14 12:00:00 |2018-07-26 11:59:00 |2016-05-25 06:07:02 |2018-07-26 16:03:10 | 4337426|
|rf_20 |Heat Pump & Misc$2107, Hob$2109, Hot Water - Controlled$2110, Incomer 1 - Uncontrolled$2112, Incomer 2 - Uncontrolled$2111, Oven & Kitchen Appliances$2108                                        |      2|2014-05-28 12:00:00 |2015-06-11 01:37:00 |2016-09-21 00:39:57 |2016-09-21 00:41:34 |  545138|
|rf_21 |Fridge$2752, Heat Pump & Washing Machine$2750, Incomer - All$2748, Kitchen Appliances & Garage$2753, Lower Bedrooms & Bathrooms$2751, Oven$2749                                                   |      4|2014-07-14 12:00:00 |2016-07-01 04:49:00 |2016-05-25 05:54:50 |2016-10-12 00:34:44 | 1972512|

Things to note:

 * rf_25 has an aditional unexpected "Incomer 1 - Uncontrolled$2757" circuit in some files but it's value is always NA so it has been ignored.
 * rf_46 had multiple circuit labels caused by apparent typos. These have been [re-labelled](https://github.com/dataknut/nzGREENGridDataR/issues/1) but note that this is the only household to have 13 circuits monitored.

Errors are easier to spot in the following plot where a hhID spans 2 or more circuit label sets.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/plotCircuitLabelIssuesAsTile-1.png)<!-- -->

```
## Saving 7 x 8 in image
```

If the above plot and table flag a lot of errors then some re-naming of the circuit labels (column names) may be necessary. 

## Observations

The following plots show the number of observations per day per household. In theory we should not see:

 * dates before 2014 or in to the future. These may indicate:
    - date conversion errors;
 * more than 1440 observations per day. These may indicate:
    - duplicate time stamps - i.e. they have the same time stamps but different power (W) values or different circuit labels. These may be expected around the DST changes in April/September. These can be examined on a per household basis using the rf_xx_observationsRatioPlot.png plots to be found in the repo [checkPlots](https://github.com/dataknut/nzGREENGridDataR/tree/master/checkPlots) folder;
    - observations from files that are in the 'wrong' rf_XX folder and so are included in the 'wrong' household as 'duplicate' time stamps.

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

 * dates before 2014 or in to the future (indicates date conversion errors);
 * less than 1440 observations per day (since we should have at least 1 circuit monitored for 24 * 60 = 1440 minutes);
 * non-integer counts of circuits as it suggests some circuit label errors or changes to the number of circuits monitored over time;
 * NA in any row (indicates date conversion errors).
 
 If we do see any of these then we still have data cleaning work to do!


|hhID  | minObs| maxObs| meanN_Circuits|minDate    |maxDate    |
|:-----|------:|------:|--------------:|:----------|:----------|
|rf_01 |     12|   8871|              6|2014-01-06 |2015-10-20 |
|rf_02 |    732|   8640|              6|2014-03-03 |2015-05-28 |
|rf_06 |   2460|   8825|              6|2014-06-09 |2018-07-26 |
|rf_07 |    882|   8893|              6|2014-07-14 |2018-07-26 |
|rf_08 |   1344|   8847|              6|2014-05-29 |2017-05-15 |
|rf_09 |   2466|   8915|              6|2014-07-14 |2015-07-16 |
|rf_10 |   2040|   8840|              6|2014-07-09 |2018-03-29 |
|rf_11 |   2549|   8826|              6|2014-07-08 |2018-07-26 |
|rf_12 |     60|   8838|              6|2014-07-09 |2015-06-03 |
|rf_13 |   4925|   8934|              6|2014-06-06 |2018-07-26 |
|rf_14 |    732|   8868|              6|2014-07-14 |2017-12-30 |
|rf_15 |     84|   8640|              6|2015-01-15 |2016-04-19 |
|rf_16 |   3060|   8937|              6|2014-07-10 |2015-03-26 |
|rf_17 |      6|   8854|              6|2014-05-30 |2018-07-26 |
|rf_18 |   1116|   8849|              6|2014-05-30 |2015-06-11 |
|rf_19 |     72|  13161|              9|2014-07-15 |2018-07-26 |
|rf_20 |   3024|   8878|              6|2014-05-29 |2015-06-11 |
|rf_21 |   1542|   8854|              6|2014-07-15 |2016-07-01 |


Finally we show the total number of households which we think are still sending data.

![](/Users/ben/github/dataknut/nzGREENGridDataR/reports/gridSpy1mProcessingReport_files/figure-html/liveDataHouseholds-1.png)<!-- -->

```
## Saving 7 x 5 in image
```

# Runtime




Analysis completed in 29.32 seconds ( 0.49 minutes) using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com) with R version 3.5.0 (2018-04-23) running on x86_64-apple-darwin15.6.0.

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
 * nzGREENGridDataR - for local NZ GREEN Grid project utilities

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
##  [1] Hmisc_4.1-1            Formula_1.2-3          survival_2.42-3       
##  [4] lattice_0.20-35        dplyr_0.7.5            nzGREENGrid_0.1.0     
##  [7] hms_0.4.2              lubridate_1.7.4        data.table_1.11.4     
## [10] kableExtra_0.9.0       stringr_1.3.1          knitr_1.20            
## [13] readr_1.1.1            ggplot2_2.2.1          rmarkdown_1.10        
## [16] nzGREENGridDataR_0.1.0
## 
## loaded via a namespace (and not attached):
##  [1] httr_1.3.1          maps_3.3.0          viridisLite_0.3.0  
##  [4] splines_3.5.0       assertthat_0.2.0    sp_1.3-1           
##  [7] highr_0.7           latticeExtra_0.6-28 cellranger_1.1.0   
## [10] yaml_2.1.19         progress_1.2.0      pillar_1.2.3       
## [13] backports_1.1.2     glue_1.2.0          digest_0.6.15      
## [16] RColorBrewer_1.1-2  checkmate_1.8.5     rvest_0.3.2        
## [19] colorspace_1.3-2    htmltools_0.3.6     Matrix_1.2-14      
## [22] plyr_1.8.4          pkgconfig_2.0.1     purrr_0.2.5        
## [25] scales_0.5.0        jpeg_0.1-8          ggmap_2.6.1        
## [28] tibble_1.4.2        htmlTable_1.12      openssl_1.0.1      
## [31] nnet_7.3-12         lazyeval_0.2.1      cli_1.0.0          
## [34] proto_1.0.0         magrittr_1.5        crayon_1.3.4       
## [37] readxl_1.1.0        evaluate_0.10.1     xml2_1.2.0         
## [40] foreign_0.8-70      tools_3.5.0         prettyunits_1.0.2  
## [43] geosphere_1.5-7     RgoogleMaps_1.4.2   munsell_0.5.0      
## [46] cluster_2.0.7-1     bindrcpp_0.2.2      compiler_3.5.0     
## [49] tinytex_0.5         rlang_0.2.1         grid_3.5.0         
## [52] rstudioapi_0.7      rjson_0.2.20        htmlwidgets_1.2    
## [55] labeling_0.3        base64enc_0.1-3     gtable_0.2.0       
## [58] reshape2_1.4.3      R6_2.2.2            gridExtra_2.3      
## [61] utf8_1.1.4          bindr_0.1.1         rprojroot_1.3-2    
## [64] stringi_1.2.3       Rcpp_0.12.17        mapproj_1.2.6      
## [67] rpart_4.1-13        acepack_1.4.1       png_0.1-7          
## [70] tidyselect_0.2.4
```

# References
