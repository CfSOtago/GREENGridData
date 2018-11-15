df <- readr::read_csv("~/Data/NZGreenGrid/safe/gridSpy/1min/dataExtracts/Heat Pump_2015-04-01_2016-03-31_observations.csv.gz",
                      col_types = cols(
                        hhID = col_character(),
                        r_dateTime = col_datetime(format = ""),
                        circuitLabel = col_character(),
                        circuitID = col_integer(),
                        powerW = col_double() # <- crucial !!!
                      )
)

summary(df)

# compare:
df <- readr::read_csv("~/Data/NZGreenGrid/safe/gridSpy/1min/dataExtracts/Heat Pump_2015-04-01_2016-03-31_observations.csv.gz")

summary(df)
