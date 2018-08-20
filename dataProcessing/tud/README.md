# NZ GREEN Grid Household Electricity Demand Study: Data R Package
[NZ GREEN Grid](https://www.otago.ac.nz/centre-sustainability/research/energy/otago050285.html) data includes:

 * 1 minute electricity power (W) data for c 40 households in NZ monitored from early 2014 using [gridSpy](https://gridspy.com/) monitors on each power circuit (and the incoming power)
 * Occupant time-use diaries (focused on energy use)
 * Dwelling & appliance surveys

NB: *None* of the data is held in this repo so *none* of the code here will work unless you also have access to the data.

## Time Use Diaries

Two time-use diaries were conducted, one for each of the two samples (Unison & PowerCo). The code:

 * Loads and checks each diary
 * Removes any identifying (potentially disclosive) variables
 * Saves out 1 file per sample to /hum-csafe/ResearchProjects/GREENGrid/Clean_data/safe/TUD/
 
Each file has multiple rows per household representing different people's diaries and mulitple columns of recorded activities and locations. No further derived variables have been created (yet).

See html/pdf for latest run but check creation date to ensure most recent.

> Track outstanding [issues](https://github.com/dataknut/nzGREENGridDataR/labels/TUD).
