# NZ GREEN Grid Data processing code
[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys

_None_ of the code here will work unless you also have access to the data. While we have plans to deposit anonymised versions of the data with a suitable data archive (any offers?!), the data is currently held on the University of Otago High Performance Storage filestore and access is controlled by the [NZ GREEN Grid project administrator](mailto:jane.wilcox@otago.ac.nz?subject=Access to GREEN Grid data (via github readme)).

## Time Use Diaries

Two time-use diaries were conducted, one for each of the two samples (Unison & PowerCo). The code in the [tud](tud) folder:

 * Loads and checks each diary
 * Removes any identifying (potentially disclosive) variables
 * Saves out 1 file per sample to /hum-csafe/ResearchProjects/GREENGrid/Clean_data/safe/TUD/
 
Each file has multiple rows per household representing different people's diaries and mulitple columns of recorded activities and locations. No further derived variables have been created (yet).

See html/pdf for latest run but check creation date to ensure most recent.

The .R code to do most of this can be found in the .Rmd file in [tud](tud) which runs the processing and produces a report on the data processing.

>Track outstanding [issues](https://git.soton.ac.uk/ba1e12/nzGREENGrid/issues?label_name%5B%5D=TUD).
