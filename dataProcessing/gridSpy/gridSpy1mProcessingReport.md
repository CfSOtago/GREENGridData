---
params:
  localData: ""
title: 'Processing report: NZ GREEN Grid project 1 minute electricity
  power data'
author: 'Ben Anderson (b.anderson@soton.ac.uk, `@dataknut`)'
date: 'Last run at: 2018-07-26 16:36:17'
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

 * /Volumes/hum-csafe/Research Projects/GREEN Grid/_RAW DATA/GridSpyData/

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
## row # A tibble: 5 x 5 col     row col         expected     actual   file                             expected   <int> <chr>       <chr>        <chr>    <chr>                            actual 1  1235 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… file 2  1799 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… row 3  2363 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… col 4  3493 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG… expected 5  4059 dateExample "date like " 14/07/14 '/Users/ben/github/dataknut/nzG…
## ... ................. ... .......................................................................... ........ .......................................................................... ...... .......................................................................... .... .......................................................................... ... .......................................................................... ... .......................................................................... ........ ..........................................................................
## See problems(...) for more details.
```

Overall we have 24,840 files from 44 households. However a large number of files contain no data as the monitoring devices have either been removed (households have moved or withdrawn from the study) or data transfer has failed. We therefore flag these files as 'to be ignored' as they have 1 of two file sizes (43 or 2751 bytes).

Of the 24,840,  14,723 (59.27%) were labelled as 'ignore' as their file sizes indicated that they contained no data.

## Data file quality checks

The following chart shows the distribution of all files over time using their sizes. Note that white indicates the presence of small files which may not contain observations.

![](/Users/ben/github/dataknut/nzGREENGridDataR/dataProcessing/gridSpy/gridSpy1mProcessingReport_files/figure-html/allFileSizesPlot-1.png)<!-- -->

```
## Saving 7 x 5 in image
```


The following chart shows the same chart but only for files which we think contain data.

![](/Users/ben/github/dataknut/nzGREENGridDataR/dataProcessing/gridSpy/gridSpy1mProcessingReport_files/figure-html/loadedFileSizesPlot-1.png)<!-- -->

```
## Saving 7 x 5 in image
```


## Date format checks

The original data was downloaded in two ways:

 * Manual download of large samples of data. In this case the dateTime of the observation appears to have been stored in NZ time and appears to also have varying dateTime formats (d/m/y, y/m/d etc);
 * Automatic download of daily data. In this case the dateTime of the observation is stored as UTC

These variations and uncertainties have required substantial effort to fix.

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

Check final date formats:


|dateColName                                                 |dateFormat                                | nFiles|minDate    |maxDate    |
|:-----------------------------------------------------------|:-----------------------------------------|------:|:----------|:----------|
|Unknown - ignore as fsize ( 2751 ) < dataThreshold ( 3000 ) |NA                                        |   1812|NA         |NA         |
|Unknown - ignore as fsize ( 43 ) < dataThreshold ( 3000 )   |NA                                        |  12911|NA         |NA         |
|date NZ                                                     |dmy - definite                            |      1|NA         |NA         |
|date NZ                                                     |mdy - definite                            |      2|NA         |NA         |
|date NZ                                                     |ymd - default (but day/month value <= 12) |     12|2014-01-06 |2016-06-07 |
|date NZ                                                     |ymd - definite                            |     67|2014-05-24 |2016-07-13 |
|date UTC                                                    |dmy - inferred                            |     28|NA         |NA         |
|date UTC                                                    |ymd - default (but day/month value <= 12) |   3957|2014-11-03 |2018-07-12 |
|date UTC                                                    |ymd - definite                            |   6050|2015-03-26 |2018-07-23 |

Results to note:

 * The non-loaded files only have 2 distinct file sizes, confirming that they are unlikely to contain useful data. 
 * There are a range of dateTme formats - these are fixed in the data cleaning process
 * Following detailed checks there are now 0 files with ambiguous dates;
 
# Loaded data files

In this section we analyse the data files that have a file size > 3000 bytes and which have been used to create the safe data. Things to note:

 * We assume that any files smaller than this value have no observations. This is based on:
     * Manual inspection of several small files
     * The identical (small) file sizes involved
     * _But_ we should probably test the first few lines to double check...
 * We have had to deal with quite a lot of duplication some of which has caused the different date formats, especially where they run through Daylight Savings Time (DST) changes.
 
The following table shows the number of files per household that are actually processed to make the safe version.


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
|rf_06 |    262|   606370.6|2016-05-25  |2018-07-25  |
|rf_07 |    262|   647565.6|2016-05-25  |2018-07-25  |
|rf_08 |      5| 23989121.0|2016-05-25  |2017-11-21  |
|rf_09 |      2| 14344605.0|2016-09-21  |2016-09-21  |
|rf_10 |    358|   525455.0|2016-05-25  |2018-03-30  |
|rf_11 |    564|   388002.5|2016-05-25  |2018-07-25  |
|rf_12 |      2| 10713096.0|2016-09-21  |2016-09-21  |
|rf_13 |    496|   440809.8|2016-05-25  |2018-07-25  |
|rf_14 |    329|   424262.0|2016-06-08  |2017-12-31  |
|rf_15 |      2| 10553143.0|2016-09-21  |2016-09-21  |
|rf_16 |      1| 20037376.0|2016-09-20  |2016-09-20  |
|rf_17 |    233|   365218.8|2016-09-21  |2018-07-23  |
|rf_18 |      2| 14374309.5|2016-09-21  |2016-09-21  |
|rf_19 |    564|   514541.0|2016-05-25  |2018-07-25  |
|rf_20 |      2| 14665810.0|2016-09-21  |2016-09-21  |
|rf_21 |      4| 23058797.8|2016-05-25  |2016-10-12  |
|rf_22 |    371|   533704.5|2016-05-25  |2018-01-16  |
|rf_23 |    564|   401119.4|2016-05-25  |2018-07-25  |
|rf_24 |    532|   405145.3|2016-05-25  |2018-07-25  |
|rf_25 |      3| 12341581.3|2016-06-08  |2017-11-21  |
|rf_26 |    470|   366294.7|2016-05-25  |2018-07-25  |
|rf_27 |      3| 22607698.7|2016-05-25  |2016-09-21  |
|rf_28 |      2|  2297483.0|2016-06-08  |2016-09-19  |
|rf_29 |    554|   317540.7|2016-05-25  |2018-07-25  |
|rf_30 |      5| 13695336.0|2016-05-25  |2016-10-13  |
|rf_31 |    564|   315180.9|2016-05-25  |2018-07-25  |
|rf_32 |      2| 13934454.0|2016-06-08  |2016-09-20  |
|rf_33 |    530|   275592.6|2016-06-08  |2018-06-22  |
|rf_34 |      7| 14106275.3|2016-05-25  |2016-10-13  |
|rf_35 |    134|   573648.6|2016-05-25  |2017-11-21  |
|rf_36 |    490|   282969.5|2016-06-08  |2018-07-05  |
|rf_37 |    563|   280891.5|2016-06-08  |2018-07-25  |
|rf_38 |    201|   385707.5|2016-06-08  |2017-11-21  |
|rf_39 |    440|   339717.0|2016-05-25  |2018-07-25  |
|rf_40 |      2|  9299902.0|2016-06-08  |2016-09-20  |
|rf_41 |    555|   249920.7|2016-06-08  |2018-07-25  |
|rf_42 |     45|  1315953.6|2016-06-08  |2017-11-21  |
|rf_43 |      4|  9442492.0|2016-05-25  |2016-09-28  |
|rf_44 |    564|   316027.8|2016-05-25  |2018-07-25  |
|rf_45 |      4| 10513812.0|2016-06-08  |2017-11-21  |
|rf_46 |    411|   605048.1|2016-06-08  |2018-02-21  |
|rf_47 |      3| 17544847.0|2016-05-25  |2016-09-20  |


## Circuit label checks

The following table shows the number of households with different circuit labels by household. In theory each household should only have one set of unique circuit labels.


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



|hhID  |circuitLabels                                                                                                                                                                                     | nFiles|
|:-----|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------:|
|rf_01 |Heating$1633, Hot water$1636, Kitchen power$1632, Lights$1635, Mains$1634, Range$1637                                                                                                             |      3|
|rf_02 |Cooking Bath tile heat$1573, Fridge$1572, Heating$1576, Hot Water$1574, Lights$1577, Mains$1575                                                                                                   |      3|
|rf_06 |Hot Water - Controlled$2248, Incomer - Uncontrolled$2249, Kitchen$2246, Laundry, Downstairs & Lounge$2245, Lighting$2244, Oven & Hob$2247                                                         |    262|
|rf_07 |Incomer 1 - Uncontrolled$2726, Incomer 2 - Uncontrolled$2725, Kitchen Appliances & Laundry$2722, Microwave$2721, Oven$2724, Workshop$2723                                                         |    262|
|rf_08 |Heat Pump$2092, Hot Water - Controlled$2094, Incomer - Uncontrolled$2093, Kitchen$2089, Laundry & 2nd Fridge Freezer$2090, Oven & Hob$2091                                                        |      5|
|rf_09 |Heat Pump & Bedroom 2$2731, Incomer 1 - Uncont - Inc Hob$2729, Incomer 2 - Uncont - Inc Oven$2730, Kitchen Appliances$2727, Laundry$2732, Lounge, Dining & Bedrooms$2728                          |      2|
|rf_10 |Bedrooms & Lounge$2602, Heat Pump$2598, Incomer - All$2599, Kitchen Appliances$2601, Laundry & Garage$2597, Oven$2600                                                                             |    358|
|rf_11 |Heat Pump & Lounge$2590, Hob$2589, Hot Water Cpbd Heater- Cont$2586, Incomer - Uncontrolled$2585, Kitchen Appliances & Laundry$2588, Spa - Uncontrolled$2587                                      |    564|
|rf_12 |Incomer 1 - Hot Water - Cont$2626, Incomer 2 - Uncontrolled$2625, Incomer 3 - Uncontrolled$2627, Kitchen Appliances & Lounge$2630, Laundry, Fridge & Microwave$2628, Oven$2629                    |      2|
|rf_13 |Downstairs (inc 1 Heat Pump)$2212, Hot Water - Controlled$2208, Incomer - Uncontrolled$2209, Kitchen & Laundry$2213, Oven & Hob$2210, Upstairs Heat Pumps$2211                                    |    496|
|rf_14 |Hot Water - Controlled$2719, Incomer 1 - Uncont inc Stove$2718, Incomer 2 - Uncont inc Oven$2717, Kitchen Appliances$2715, Laundry & Microwave$2720, Power Outlets$2716                           |    329|
|rf_15 |Hob$3954, Hot Water$3952, Incomer 1$3956, Incomer 2$3955, Laundry & Kitchen Appliances$3951, Oven$3953                                                                                            |      2|
|rf_16 |Hallway & Washing Machine$2683, Hot Water - Controlled$2679, Incomer 1 - Uncont inc Oven$2681, Incomer 2 - Uncont inc Stove$2680, Kitchen Appliances & Bedrooms$2684, Microwave & Breadmaker$2682 |      1|
|rf_17 |Heat Pump$2148, Hot Water - Controlled$2150, Incomer 1 - Uncont - inc Hob$2152, Incomer 2 - Uncont - inc Oven$2151, Kitchen Appliances$2147, Laundry$2149                                         |      2|
|rf_17 |Incomer 1 - inc Top Oven$5620, Incomer 2 - inc Bottom Oven$5621, Kitchen Appliances$5625, Laundry & Garage$5624, Lighting 1/2$5623, Lighting 2/2$5622                                             |    231|
|rf_18 |Hot Water - Controlled$2129, Incomer 1 - Uncontrolled$2128, Incomer 2 - Uncontrolled$2130, Kitchen Appliances & Ventilati$2131, Laundry & Hob$2133, Oven$2132                                     |      2|
|rf_19 |Bedroom & Lounge Heat Pumps$2741, Incomer 1 - All$2738, Incomer 2 - All$2737, Kitchen Appliances$2735, Laundry$2734, Oven$2736, PV 1$2739, PV 2$2733, Theatre Heat Pump$2740                      |    564|
|rf_20 |Heat Pump & Misc$2107, Hob$2109, Hot Water - Controlled$2110, Incomer 1 - Uncontrolled$2112, Incomer 2 - Uncontrolled$2111, Oven & Kitchen Appliances$2108                                        |      2|
|rf_21 |Fridge$2752, Heat Pump & Washing Machine$2750, Incomer - All$2748, Kitchen Appliances & Garage$2753, Lower Bedrooms & Bathrooms$2751, Oven$2749                                                   |      4|
|rf_22 |Hot Water - Controlled$2236, Incomer - Uncontrolled$2237, Kitchen & Laundry$2234, Lighting$2232, Oven$2235, Ventilation & Lounge Power$2233                                                       |    371|
|rf_23 |Hot Water - Controlled (HEMS)$2081, Incomer - Uncontrolled$2082, Kitchen, Laundry & Ventilation$2084, Oven$2085, PV & Storage$2083, Spa (HEMS)$2080                                               |    564|
|rf_24 |Hot Water - Controlled$2102, Incomer - Uncontrolled$2101, Kitchen$2104, Laundry, Fridge & Freezer$2105, Oven & Hob$2103, PV$2106                                                                  |    532|
|rf_25 |Heat Pump$2758, Hob & Kitchen Appliances$2759, Hot Water - Controlled$2761, Incomer 1 - Uncontrolled $2763, Incomer 1 - Uncontrolled$2757, Incomer 2 - Uncontrolled $2762, Oven$2760              |      1|
|rf_25 |Heat Pump$2758, Hob & Kitchen Appliances$2759, Hot Water - Controlled$2761, Incomer 1 - Uncontrolled $2763, Incomer 2 - Uncontrolled $2762, Oven$2760                                             |      2|
|rf_26 |Incomer 1 - All$2703, Incomer 2 - All$2704, Kitchen Appliances$2706, Laundry, Sauna & 2nd Fridge$2707, Oven$2705, Spa$2708                                                                        |    470|
|rf_27 |Bed 2, 2nd Fridge$2828, Heat Pump$2826, Hot Water - Controlled$2825, Incomer - Uncontrolled$2824, Kitchen, Laundry & Beds 1&3$2829, Oven & Oven Wall Appliances$2827                              |      3|
|rf_28 |Heat Pump$4219, Incomer - All$4221, Kitchen Appliances$4216, Laundry$4217, Lighting$4218, PV & Garage$4220                                                                                        |      2|
|rf_29 |Heat Pump & Kitchen Appliances$4186, Hot Water - Controlled$4184, Incomer - Uncontrolled$4181, Laundry$4185, Lighting$4183, Oven$4182                                                             |    554|
|rf_30 |Hot Water - Controlled$4238, Incomer - All$4239, Kitchen Appliances$4234, Laundry & Kitchen$4235, Lighting$4236, Oven & Hobb$4237                                                                 |      5|
|rf_31 |Heat Pump$4204, Hot Water - Controlled$4200, Incomer - All$4199, Kitchen Appliances$4201, Laundry$4202, Lighting$4203                                                                             |    564|
|rf_32 |Heat Pump$4196, Hot Water - Controlled$4198, Incomer - All$4193, Kitchen Appliances$4195, Laundry$4194, Lighting$4197                                                                             |      2|
|rf_33 |Hot Water - Controlled$4144, Incomer - Uncontrolled$4143, Kitchen Appliances & Heat Pump$4140, Laundry & Teenagers Bedroom$4139, Lighting$4142, Oven, Hob & Microwave$4141                        |    530|
|rf_34 |Heat Pump$4223, Hot Water - Uncontrolled$4224, Incomer - All$4225, Kitchen Appliances$4226, Laundry & Garage Freezer$4227, Lighting$4222                                                          |      7|
|rf_35 |Heat Pump$4124, Hot Water - Uncontrolled$4125, Incomer - Uncontrolled$4126, Kitchen Appliances$4121, Laundry, Garage Fridge Freezer$4122, Lighting$4123                                           |    134|
|rf_36 |Heat Pump$4150, Hot Water - Uncontrolled$4147, Incomer - All$4148, Kitchen Appliances$4145, Lighting$4149, Washing Machine$4146                                                                   |    490|
|rf_37 |Heat Pump$4134, Hot Water - Controlled$4135, Incomer -Uncontrolled$4136, Kitchen Appliances$4137, Laundry & Fridge Freezer$4138, Lighting$4133                                                    |    563|
|rf_38 |Heat Pump$4175, Hot Water - Controlled$4178, Incomer - Uncontrolled$4177, Kitchen, Dining & Office$4179, Laundry, Lounge, Garage, Bed$4180, Lighting$4176                                         |    201|
|rf_39 |Hot Water  (2 elements)$4247, Incomer - Uncontrolled$4248, Kitchen Appliances$4244, Lighting & 2 Towel Rail$4245, Oven$4246                                                                       |    440|
|rf_40 |Heat Pump (x2) & Lounge Power$4166, Hot Water - Controlled$4167, Incomer - Uncontrolled$4168, Kitchen Appliances$4163, Laundry$4164, Lighting$4165                                                |      2|
|rf_41 |Heat Pump$4190, Incomer - All$4192, Kitchen Appliances$4187, Laundry$4188, Lighting$4189, Oven$4191                                                                                               |    406|

If this is not the case then this implies that:

 * some of the circuit labels for these households may have been changed during the data collection process;
 * some of the circuit labels may have character conversion errors which have changed the labels during the data collection process;
 * at least one file from one household has been saved to a folder containing data from a different household (unfortunately the raw data files do _not_ contain household IDs in the data or the file names which would enable checking/preventative filtering). This will be visible in the table if two households appear to share _exactly_ the same list of circuit labels.

Some or all of these may be true at any given time!

Errors are easy to spot in the following plot where a hhID spans 2 or more circuit labels.

![](/Users/ben/github/dataknut/nzGREENGridDataR/dataProcessing/gridSpy/gridSpy1mProcessingReport_files/figure-html/plotCircuitLabelIssuesAsTile-1.png)<!-- -->

```
## Saving 7 x 8 in image
```

The following table provides more detail to aid error checking. Check for:

 * 2+ adjacent rows which have exactly the same circuit labels but different hh_ids. This implies some data from one household has been saved in the wrong folder;
 * 2+ adjacent rows which have different circuit labels but identical hh_ids. This could imply the same thing but is more likely to be errors/changes to the circuit labelling. 
 
If the above plot and this table flag a lot of errors then some re-naming of the circuit labels (column names) may be necessary. 

> NB: As before, the table is only legible in the html version of this report because latex does a very bad job of wrapping table cell text. A version is saved in /Volumes/hum-csafe/Research Projects/GREEN Grid/Clean_data/safe/gridSpy/1min/circuitLabelMetaDataCheckTable.csv for viewing in e.g. xl.


|circuitLabels                                                                                                                                                                                     |hhID  | nFiles|minObsDate          |maxObsDate          |minFileDate         |maxFileDate         |    nObs|
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----|------:|:-------------------|:-------------------|:-------------------|:-------------------|-------:|
|Bed 2, 2nd Fridge$2828, Heat Pump$2826, Hot Water - Controlled$2825, Incomer - Uncontrolled$2824, Kitchen, Laundry & Beds 1&3$2829, Oven & Oven Wall Appliances$2827                              |rf_27 |      3|2014-07-27 12:00:00 |2016-05-13 22:43:00 |2016-05-25 06:04:51 |2016-09-21 00:34:28 | 1419097|
|Bedroom & Lounge Heat Pumps$2741, Incomer 1 - All$2738, Incomer 2 - All$2737, Kitchen Appliances$2735, Laundry$2734, Oven$2736, PV 1$2739, PV 2$2733, Theatre Heat Pump$2740                      |rf_19 |    564|2014-07-14 12:00:00 |2018-07-25 11:59:00 |2016-05-25 06:07:02 |2018-07-25 16:03:10 | 4334546|
|Bedrooms & Lounge$2602, Heat Pump$2598, Incomer - All$2599, Kitchen Appliances$2601, Laundry & Garage$2597, Oven$2600                                                                             |rf_10 |    358|2014-07-08 12:00:00 |2018-03-29 06:28:00 |2016-05-25 10:16:08 |2018-03-30 15:03:07 | 3734792|
|Cooking Bath tile heat$1573, Fridge$1572, Heating$1576, Hot Water$1574, Lights$1577, Mains$1575                                                                                                   |rf_02 |      3|2014-03-02 11:00:00 |2015-05-28 04:23:00 |2016-09-20 02:53:43 |2016-09-30 00:14:19 |  592592|
|Downstairs (inc 1 Heat Pump)$2212, Hot Water - Controlled$2208, Incomer - Uncontrolled$2209, Kitchen & Laundry$2213, Oven & Hob$2210, Upstairs Heat Pumps$2211                                    |rf_13 |    496|2014-06-05 12:00:00 |2018-07-25 11:59:00 |2016-05-25 05:57:08 |2018-07-25 16:03:07 | 4057633|
|Fridge$2752, Heat Pump & Washing Machine$2750, Incomer - All$2748, Kitchen Appliances & Garage$2753, Lower Bedrooms & Bathrooms$2751, Oven$2749                                                   |rf_21 |      4|2014-07-14 12:00:00 |2016-07-01 04:49:00 |2016-05-25 05:54:50 |2016-10-12 00:34:44 | 1972512|
|Hallway & Washing Machine$2683, Hot Water - Controlled$2679, Incomer 1 - Uncont inc Oven$2681, Incomer 2 - Uncont inc Stove$2680, Kitchen Appliances & Bedrooms$2684, Microwave & Breadmaker$2682 |rf_16 |      1|2014-07-09 12:00:00 |2015-03-25 20:22:00 |2016-09-20 23:51:39 |2016-09-20 23:51:39 |  373523|
|Heat Pump & Bedroom 2$2731, Incomer 1 - Uncont - Inc Hob$2729, Incomer 2 - Uncont - Inc Oven$2730, Kitchen Appliances$2727, Laundry$2732, Lounge, Dining & Bedrooms$2728                          |rf_09 |      2|2014-07-13 12:00:00 |2015-07-16 02:42:00 |2016-09-21 01:26:07 |2016-09-21 01:26:55 |  529363|
|Heat Pump & Kitchen Appliances$4186, Hot Water - Controlled$4184, Incomer - Uncontrolled$4181, Laundry$4185, Lighting$4183, Oven$4182                                                             |rf_29 |    554|2015-03-25 11:00:00 |2018-07-25 11:59:00 |2016-05-25 04:49:46 |2018-07-25 16:03:15 | 3426923|
|Heat Pump & Lounge$2590, Hob$2589, Hot Water Cpbd Heater- Cont$2586, Incomer - Uncontrolled$2585, Kitchen Appliances & Laundry$2588, Spa - Uncontrolled$2587                                      |rf_11 |    564|2014-07-07 12:00:00 |2018-07-25 11:59:00 |2016-05-25 06:15:06 |2018-07-25 16:03:06 | 4351056|
|Heat Pump & Misc$2107, Hob$2109, Hot Water - Controlled$2110, Incomer 1 - Uncontrolled$2112, Incomer 2 - Uncontrolled$2111, Oven & Kitchen Appliances$2108                                        |rf_20 |      2|2014-05-28 12:00:00 |2015-06-11 01:37:00 |2016-09-21 00:39:57 |2016-09-21 00:41:34 |  545138|
|Heat Pump (x2) & Lounge Power$4166, Hot Water - Controlled$4167, Incomer - Uncontrolled$4168, Kitchen Appliances$4163, Laundry$4164, Lighting$4165                                                |rf_40 |      2|2015-03-24 11:00:00 |2015-11-22 04:27:00 |2016-06-08 03:03:01 |2016-09-20 02:24:48 |  349528|
|Heat Pump$2092, Hot Water - Controlled$2094, Incomer - Uncontrolled$2093, Kitchen$2089, Laundry & 2nd Fridge Freezer$2090, Oven & Hob$2091                                                        |rf_08 |      5|2014-05-28 12:00:00 |2017-05-15 02:02:00 |2016-05-25 05:48:18 |2017-11-21 01:09:19 | 2536195|
|Heat Pump$2148, Hot Water - Controlled$2150, Incomer 1 - Uncont - inc Hob$2152, Incomer 2 - Uncont - inc Oven$2151, Kitchen Appliances$2147, Laundry$2149                                         |rf_17 |      2|2014-05-29 12:00:00 |2016-03-28 02:54:00 |2016-09-21 00:50:57 |2016-09-21 00:52:45 |  962873|
|Heat Pump$2758, Hob & Kitchen Appliances$2759, Hot Water - Controlled$2761, Incomer 1 - Uncontrolled $2763, Incomer 1 - Uncontrolled$2757, Incomer 2 - Uncontrolled $2762, Oven$2760              |rf_25 |      1|2015-05-24 12:00:00 |2016-05-25 11:59:00 |2016-06-08 03:34:06 |2016-06-08 03:34:06 |  507847|
|Heat Pump$2758, Hob & Kitchen Appliances$2759, Hot Water - Controlled$2761, Incomer 1 - Uncontrolled $2763, Incomer 2 - Uncontrolled $2762, Oven$2760                                             |rf_25 |      2|2016-05-25 12:00:00 |2016-10-22 00:44:00 |2016-10-25 21:11:12 |2017-11-21 04:41:45 |  213418|
|Heat Pump$4124, Hot Water - Uncontrolled$4125, Incomer - Uncontrolled$4126, Kitchen Appliances$4121, Laundry, Garage Fridge Freezer$4122, Lighting$4123                                           |rf_35 |    134|2015-03-22 11:00:00 |2017-05-17 00:49:00 |2016-05-25 04:47:09 |2017-11-21 01:17:08 | 1494089|
|Heat Pump$4134, Hot Water - Controlled$4135, Incomer -Uncontrolled$4136, Kitchen Appliances$4137, Laundry & Fridge Freezer$4138, Lighting$4133                                                    |rf_37 |    563|2015-03-23 11:00:00 |2018-07-25 11:59:00 |2016-06-08 02:57:45 |2018-07-25 16:03:19 | 3010954|
|Heat Pump$4150, Hot Water - Uncontrolled$4147, Incomer - All$4148, Kitchen Appliances$4145, Lighting$4149, Washing Machine$4146                                                                   |rf_36 |    490|2015-03-23 11:00:00 |2018-07-04 02:56:00 |2016-06-08 03:00:39 |2018-07-05 16:03:18 | 2761686|
|Heat Pump$4175, Hot Water - Controlled$4178, Incomer - Uncontrolled$4177, Kitchen, Dining & Office$4179, Laundry, Lounge, Garage, Bed$4180, Lighting$4176                                         |rf_38 |    201|2015-03-24 11:00:00 |2017-08-22 06:37:00 |2016-06-08 02:57:03 |2017-11-21 01:18:28 | 1456669|
|Heat Pump$4190, Incomer - All$4192, Kitchen Appliances$4187, Laundry$4188, Lighting$4189, Oven$4191                                                                                               |rf_41 |    406|2015-03-25 11:00:00 |2018-07-25 11:59:00 |2016-06-08 02:58:54 |2018-07-25 16:03:21 | 2173775|
|Heat Pump$4196, Hot Water - Controlled$4198, Incomer - All$4193, Kitchen Appliances$4195, Laundry$4194, Lighting$4197                                                                             |rf_32 |      2|2015-03-25 11:00:00 |2016-04-05 05:24:00 |2016-06-08 03:03:33 |2016-09-20 02:25:50 |  542484|
|Heat Pump$4204, Hot Water - Controlled$4200, Incomer - All$4199, Kitchen Appliances$4201, Laundry$4202, Lighting$4203                                                                             |rf_31 |    564|2015-03-25 11:00:00 |2018-07-25 11:59:00 |2016-05-25 04:51:22 |2018-07-25 16:03:16 | 3621001|
|Heat Pump$4219, Incomer - All$4221, Kitchen Appliances$4216, Laundry$4217, Lighting$4218, PV & Garage$4220                                                                                        |rf_28 |      2|2015-03-26 11:00:00 |2015-05-26 04:56:00 |2016-06-08 02:55:53 |2016-09-19 23:53:50 |   87417|
|Heat Pump$4223, Hot Water - Uncontrolled$4224, Incomer - All$4225, Kitchen Appliances$4226, Laundry & Garage Freezer$4227, Lighting$4222                                                          |rf_34 |      7|2014-11-03 11:00:00 |2016-08-24 05:16:00 |2016-05-25 01:46:59 |2016-10-13 02:40:26 | 2066074|
|Heating$1633, Hot water$1636, Kitchen power$1632, Lights$1635, Mains$1634, Range$1637                                                                                                             |rf_01 |      3|2014-01-05 11:00:00 |2015-10-20 02:50:00 |2016-09-20 02:58:11 |2016-09-30 00:16:15 |  855836|
|Hob$3954, Hot Water$3952, Incomer 1$3956, Incomer 2$3955, Laundry & Kitchen Appliances$3951, Oven$3953                                                                                            |rf_15 |      2|2015-01-14 11:00:00 |2016-04-18 20:37:00 |2016-09-21 00:47:53 |2016-09-21 00:49:20 |  395011|
|Hot Water  (2 elements)$4247, Incomer - Uncontrolled$4248, Kitchen Appliances$4244, Lighting & 2 Towel Rail$4245, Oven$4246                                                                       |rf_39 |    440|2015-03-27 11:00:00 |2018-07-25 11:59:00 |2016-05-25 04:44:05 |2018-07-25 16:03:20 | 3176050|
|Hot Water - Controlled (HEMS)$2081, Incomer - Uncontrolled$2082, Kitchen, Laundry & Ventilation$2084, Oven$2085, PV & Storage$2083, Spa (HEMS)$2080                                               |rf_23 |    564|2014-05-25 12:00:00 |2018-07-25 11:59:00 |2016-05-25 10:39:44 |2018-07-25 16:03:12 | 4414352|
|Hot Water - Controlled$2102, Incomer - Uncontrolled$2101, Kitchen$2104, Laundry, Fridge & Freezer$2105, Oven & Hob$2103, PV$2106                                                                  |rf_24 |    532|2014-05-28 12:00:00 |2018-07-25 11:59:00 |2016-05-25 05:58:57 |2018-07-25 16:03:13 | 4269359|
|Hot Water - Controlled$2129, Incomer 1 - Uncontrolled$2128, Incomer 2 - Uncontrolled$2130, Kitchen Appliances & Ventilati$2131, Laundry & Hob$2133, Oven$2132                                     |rf_18 |      2|2014-05-29 12:00:00 |2015-06-11 02:36:00 |2016-09-21 00:56:19 |2016-09-21 00:57:41 |  543098|
|Hot Water - Controlled$2236, Incomer - Uncontrolled$2237, Kitchen & Laundry$2234, Lighting$2232, Oven$2235, Ventilation & Lounge Power$2233                                                       |rf_22 |    371|2014-06-05 12:00:00 |2018-01-14 18:19:00 |2016-05-25 10:20:47 |2018-01-16 15:03:12 | 3837181|
|Hot Water - Controlled$2248, Incomer - Uncontrolled$2249, Kitchen$2246, Laundry, Downstairs & Lounge$2245, Lighting$2244, Oven & Hob$2247                                                         |rf_06 |    262|2014-06-08 12:00:00 |2018-07-25 11:59:00 |2016-05-25 10:26:07 |2018-07-25 16:03:04 | 3125996|
|Hot Water - Controlled$2719, Incomer 1 - Uncont inc Stove$2718, Incomer 2 - Uncont inc Oven$2717, Kitchen Appliances$2715, Laundry & Microwave$2720, Power Outlets$2716                           |rf_14 |    329|2014-07-13 12:00:00 |2017-12-30 01:59:00 |2016-06-08 03:31:15 |2017-12-31 15:03:08 | 2654180|
|Hot Water - Controlled$4144, Incomer - Uncontrolled$4143, Kitchen Appliances & Heat Pump$4140, Laundry & Teenagers Bedroom$4139, Lighting$4142, Oven, Hob & Microwave$4141                        |rf_33 |    530|2015-03-23 11:00:00 |2018-06-21 10:37:00 |2016-06-08 03:05:01 |2018-06-22 16:03:16 | 2812639|
|Hot Water - Controlled$4238, Incomer - All$4239, Kitchen Appliances$4234, Laundry & Kitchen$4235, Lighting$4236, Oven & Hobb$4237                                                                 |rf_30 |      5|2015-03-27 11:00:00 |2016-09-29 03:24:00 |2016-05-25 01:54:23 |2016-10-13 02:41:24 | 1454037|
|Incomer 1 - All$2703, Incomer 2 - All$2704, Kitchen Appliances$2706, Laundry, Sauna & 2nd Fridge$2707, Oven$2705, Spa$2708                                                                        |rf_26 |    470|2014-07-10 12:00:00 |2018-07-25 11:59:00 |2016-05-25 05:50:03 |2018-07-25 16:03:14 | 3400416|
|Incomer 1 - Hot Water - Cont$2626, Incomer 2 - Uncontrolled$2625, Incomer 3 - Uncontrolled$2627, Kitchen Appliances & Lounge$2630, Laundry, Fridge & Microwave$2628, Oven$2629                    |rf_12 |      2|2014-07-08 12:00:00 |2015-06-02 20:07:00 |2016-09-21 00:44:42 |2016-09-21 00:46:01 |  410063|
|Incomer 1 - Uncontrolled$2726, Incomer 2 - Uncontrolled$2725, Kitchen Appliances & Laundry$2722, Microwave$2721, Oven$2724, Workshop$2723                                                         |rf_07 |    262|2014-07-13 12:00:00 |2018-07-25 11:59:00 |2016-05-25 10:44:03 |2018-07-25 16:03:04 | 3377729|
|Incomer 1 - inc Top Oven$5620, Incomer 2 - inc Bottom Oven$5621, Kitchen Appliances$5625, Laundry & Garage$5624, Lighting 1/2$5623, Lighting 2/2$5622                                             |rf_17 |    231|2016-10-11 11:00:00 |2018-07-22 08:18:00 |2017-01-11 00:08:08 |2018-07-23 16:03:11 |  794267|

Things to note:

 * rf_25 has an aditional unexpected "Incomer 1 - Uncontrolled$2757" circuit in some files but it's value is always NA
 
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

![](/Users/ben/github/dataknut/nzGREENGridDataR/dataProcessing/gridSpy/gridSpy1mProcessingReport_files/figure-html/loadedFilesObsPlots-1.png)<!-- -->

```
## Saving 7 x 5 in image
```

![](/Users/ben/github/dataknut/nzGREENGridDataR/dataProcessing/gridSpy/gridSpy1mProcessingReport_files/figure-html/loadedFilesObsPlots-2.png)<!-- -->

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
|rf_01 |     12|   8871|              6|2014-01-06 |2015-10-20 |
|rf_02 |    732|   8640|              6|2014-03-03 |2015-05-28 |
|rf_06 |   2460|   8825|              6|2014-06-09 |2018-07-25 |
|rf_07 |    882|   8893|              6|2014-07-14 |2018-07-25 |
|rf_08 |   1344|   8847|              6|2014-05-29 |2017-05-15 |
|rf_09 |   2466|   8915|              6|2014-07-14 |2015-07-16 |
|rf_10 |   2040|   8840|              6|2014-07-09 |2018-03-29 |
|rf_11 |   2549|   8826|              6|2014-07-08 |2018-07-25 |
|rf_12 |     60|   8838|              6|2014-07-09 |2015-06-03 |
|rf_13 |   4925|   8934|              6|2014-06-06 |2018-07-25 |
|rf_14 |    732|   8868|              6|2014-07-14 |2017-12-30 |
|rf_15 |     84|   8640|              6|2015-01-15 |2016-04-19 |
|rf_16 |   3060|   8937|              6|2014-07-10 |2015-03-26 |
|rf_17 |      6|   8854|              6|2014-05-30 |2018-07-22 |
|rf_18 |   1116|   8849|              6|2014-05-30 |2015-06-11 |
|rf_19 |     72|  13161|              9|2014-07-15 |2018-07-25 |
|rf_20 |   3024|   8878|              6|2014-05-29 |2015-06-11 |
|rf_21 |   1542|   8854|              6|2014-07-15 |2016-07-01 |
|rf_22 |   1002|   8873|              6|2014-06-06 |2018-01-15 |
|rf_23 |   2370|   8816|              6|2014-05-26 |2018-07-25 |
|rf_24 |    702|   8760|              6|2014-05-29 |2018-07-25 |
|rf_25 |     72|   8818|              6|2015-05-25 |2016-10-22 |
|rf_26 |    420|   8857|              6|2014-07-11 |2018-07-25 |
|rf_27 |   2610|   8873|              6|2014-07-28 |2016-05-14 |
|rf_28 |   4476|   8640|              6|2015-03-27 |2015-05-26 |
|rf_29 |   5088|   8797|              6|2015-03-26 |2018-07-25 |
|rf_30 |   5016|   8865|              6|2015-03-28 |2016-09-29 |
|rf_31 |   2166|   8848|              6|2015-03-26 |2018-07-25 |
|rf_32 |   2640|   8775|              6|2015-03-26 |2016-04-05 |
|rf_33 |     90|   8888|              6|2015-03-24 |2018-06-21 |
|rf_34 |    204|   8825|              6|2014-11-04 |2016-08-24 |
|rf_35 |   2394|   8839|              6|2015-03-23 |2017-05-17 |
|rf_36 |     72|   8787|              6|2015-03-24 |2018-07-04 |
|rf_37 |   4584|   8824|              6|2015-03-24 |2018-07-25 |
|rf_38 |   1062|   8861|              6|2015-03-25 |2017-08-22 |
|rf_39 |   1490|   7381|              5|2015-03-28 |2018-07-25 |
|rf_40 |   3798|   8849|              6|2015-03-25 |2015-11-22 |


Finally we show the total number of households which we think are still sending data.

![](/Users/ben/github/dataknut/nzGREENGridDataR/dataProcessing/gridSpy/gridSpy1mProcessingReport_files/figure-html/liveDataHouseholds-1.png)<!-- -->

```
## Saving 7 x 5 in image
```

# Runtime




Analysis completed in 39.62 seconds ( 0.66 minutes) using [knitr](https://cran.r-project.org/package=knitr) in [RStudio](http://www.rstudio.com) with R version 3.5.0 (2018-04-23) running on x86_64-apple-darwin15.6.0.

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
## [10] utf8_1.1.4        rlang_0.2.1       pillar_1.2.3     
## [13] glue_1.2.0        sp_1.3-1          bindrcpp_0.2.2   
## [16] jpeg_0.1-8        bindr_0.1.1       plyr_1.8.4       
## [19] stringr_1.3.1     munsell_0.5.0     gtable_0.2.0     
## [22] rvest_0.3.2       RgoogleMaps_1.4.2 mapproj_1.2.6    
## [25] evaluate_0.10.1   labeling_0.3      highr_0.7        
## [28] proto_1.0.0       Rcpp_0.12.17      geosphere_1.5-7  
## [31] openssl_1.0.1     backports_1.1.2   scales_0.5.0     
## [34] rjson_0.2.20      png_0.1-7         digest_0.6.15    
## [37] stringi_1.2.3     grid_3.5.0        rprojroot_1.3-2  
## [40] cli_1.0.0         tools_3.5.0       magrittr_1.5     
## [43] maps_3.3.0        lazyeval_0.2.1    tibble_1.4.2     
## [46] crayon_1.3.4      pkgconfig_2.0.1   xml2_1.2.0       
## [49] prettyunits_1.0.2 assertthat_0.2.0  httr_1.3.1       
## [52] rstudioapi_0.7    R6_2.2.2          ggmap_2.6.1      
## [55] compiler_3.5.0
```

# References
