# checkPlots

A place to store auto-generated plots. In general:

 * power plots are mean power per half hour per circuit for each month and year - as a visual check of the temporal patterns of electricity demand;
 * observation ratio plots are plots of the total number of observations received per hour of each day divided by the expected number of observations (allowing for the number of circuits):
   - a value of 0 = no observations either due to missing or DST change when an hour is 'lost' (see partial [explanation](https://github.com/dataknut/nzGREENGridDataR/blob/a70d9d4fc7a4ee8406cda2c8bb458bd324ff6f43/R/gridSpyData.R#L228));
   - a value of 1 = as expected;
   - a value of 2 = double expected observations either due to duplicates (unlikely) or DST change when an hour is 'gained'.
 
See relevant code for details.