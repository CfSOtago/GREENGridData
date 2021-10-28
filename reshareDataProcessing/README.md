# NZ GREEN Grid Household Electricity Demand Study: Data R Package

## imputeTotalPower.R
This script imputes the total power demand per household for each 1 minute period and creates a new data file for each household with just the total imputed power for each minute. It also creates a single (_very large_) file of all imputed power per minute for all households. This data is _not_ in the [reshare archive held on the UK Data Service](http://reshare.ukdataservice.ac.uk/853334/) as you can create it easily from the archived data using this code.

The code uses a circuits-to-sum definition file from the [/publicData](https://github.com/dataknut/GREENGridData/tree/master/publicData) folder to do so. Reports on the results of doing so can be found at https://cfsotago.github.io/GREENGridData/. 

## Issues

We keep a log of [issues](https://github.com/CfSOtago/GREENGridData/issues) - if you detect a new problem with the data (or code) please open a new [issue](https://github.com/CfSOtago/GREENGridData/issues).
