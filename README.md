# Renewable Energy and the Smart Grid (GREEN Grid) project: Data R Package

The [Renewable Energy and the Smart Grid (GREEN Grid)](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) project Household Electricity Demand Study data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Occupant time-use diaries (focused on energy use)
 * Surveys of the dwelling, the occupants and their appliances. This used a version of the Energy Cultures survey which is available in the /docs folder.

This data has been cleaned and anonymised to produce the 'safe' dataset available from the [UK Data Service](http://reshare.ukdataservice.ac.uk/853334/). *None* of the data is held in this repo so *none* of the code here will work unless you also have access to the data. 

> See our [github pages site](https://cfsotago.github.io/GREENGridData/) for full data documentation.

----

## About

The code in this repo does three things:

 * _Auto-generates the [data documentation](https://cfsotago.github.io/GREENGridData/)
    - processes the original data to a 'safe' form for archiving and third party re-use (code will only work if you have the original data). As it does so it creates two check plots for each household: monthly mean power profiles & the number of observations over time. The are found in the archived dataset for error checking purposes;
    - produces original data [processing reports and documentation](https://cfsotago.github.io/GREENGridData/) (code will only work if you have the original data);
    - produces cleaned 'safe' [data reports and documentation](https://cfsotago.github.io/GREENGridData/) (code will only work if you have the original data).
 * _Released 'safe' data: Analytic code examples_ to:
    - load and analyse 'safe' electricity demand (power) data for one household
    - extract power data for circuits matching a given string (e.g. `Heat Pump`) from the 'safe' data between two dates;
    - link the household survey and extracted 'Heat Pump' data for analysis;
    - impute total household power demand from the relevant circuits for each household.

Guide to folders:

 * publicData - misc external data used in data cleaning and processing (*not* the research data);
 * dataProcessing - R scripts to process data and generate data quality reports. These will not run without access to the original study data but you can review them to understand why the anonymised data looks the way it does;
 * docs - the data archive documentation published via [githhub pages](https://cfsotago.github.io/GREENGridData/);
 * examples - R script examples to show how the clean anonymised data can be analysed;
 * includes - .Rmd files used in report generation;
 * makeDocs - makefile and .Rmd files used to produce the most recent versions of the data documentation. These require data quality summaries produced by the dataProcessing code;
 * man - R package documentation (auto-created using [roxygen](https://cran.r-project.org/web/packages/roxygen2/) - do not touch!);
 * plots - a selection of exmaple plots
 * R - R code implementing the package functions.
 
## Data Access

The 'safe' anonymised dataset is available from the [UK Data Service](http://reshare.ukdataservice.ac.uk/853334/).

The original project data is held on the University of Otago's restricted-access High-Capacity Storage [(HCS) filestore](https://www.otago.ac.nz/its/services/hosting/otago068353.html).

## Using the code
This repo is intentionally structured as an R package so you can install it and re-use the code. You can do this in three ways:

### Download it
This will just give you the code to explore & play with.

### Clone/fork the repo from github
This will give you a replication of the package as a local repo which you can edit & re-build/re-install as often as you like. You should set this up as an [RStudio project](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects). You can then (if you wish) submit pull requests for any improvements you make.

### Install the package
This will install it wherever your version of R(Studio) stores packages. It will also install any dependencies. However you will not (easily) be able to edit or amend the code. To do install it:

 * install the R [devtools](http://r-pkgs.had.co.nz/git.html) package: `> install.packages("devtools")`;
 * run: `> devtools::install_github("CfSOtago/GREENGridData")`
 * this should install the package and any [dependencies](http://r-pkgs.had.co.nz/description.html#dependencies) you may not have and will enable you to use the functions;
 * however we suggest you then clone/download the package if you want to play with the examples as they are _not_ installed by the `> devtools::install_github("CfSOtago/GREENGridData")` process.

### Recommended approach

 * Install it from github (so you know it works), then...
 * Fork it from github, then...
 * Edit it as you wish, then...
 * Re-build & install it locally, then...
 * Test it, then...
 * Send a pull request so we can build your awesome improvements into the code base :-)
 
### Disclaimer

Inevitably [#YMMV](http://en.wiktionary.org/wiki/YMMV).

## Re-Use and Contribution

### Terms of Re-Use

In general you can re-use the code and results provided you give appropriate attribution (citation) and retain the same usage terms in your own work.

### Re-Using the results
If you want to re-use any of the results in the md/html/pdf reports please cite them using the format described in the reports and observe the license terms applied (usually [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)).

### Re-Using the code

If you want to re-use the code in your own work, please read the repo [License](LICENSE) file for specific guidance. 

Inevitably [#YMMV](http://en.wiktionary.org/wiki/YMMV)

### Comments & suggestions:
Please use git [issues](https://github.com/CfSOtago/GREENGridData/issues) to make a comment or point out an error. We also use issues to manage our 'to do' list so please check your comment is not already open :-)
 
### Contributing code
Feel free to [fork](https://help.github.com/articles/fork-a-repo/) the repository (or a [branch](https://help.github.com/articles/about-branches/) if you are a collaborator with write access to this repo) and contribute your own additions through the normal git [pull request](https://github.com/CfSOtago/GREENGridData/pulls) process (ideally R or [RMarkdown](http://rmarkdown.rstudio.com/) please!). If you haven't used github before, now is a good time to [learn](https://guides.github.com/) - it works for any codebase, not just R. For R, we recommend using [RStudio](http://www.rstudio.com)'s integrated github features.

If you make a substantive addition to any of the exisiting RMarkdown reports please add yourself as an author. Your contributions will, in any case, be [tracked by github](https://help.github.com/articles/tracing-changes-in-a-file/) and so fully visible to the world in perpetuity :-)

