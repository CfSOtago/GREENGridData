#--- Loads household data and codes variables ---#

# Load nzGREENGrid package ----
library(GREENGridData) # local utilities

# Packages needed in this .Rmd file ----
rmdLibs <- c("data.table",
             "dplyr" # for recode
)
# load them
loadLibraries(rmdLibs)

# Local parameters ----

# change this to suit your data location - this is where extractCleanGridSpy1minCircuit.R saved your extract
dPath <- path.expand("~/Dropbox/data/NZ_GREENGrid/ukds/data/")
                     
hhFile <- paste0(dPath, "ggHouseholdAttributesSafe.csv")

if(file.exists(hhFile)){
  message("Success! Found expected household survey file: ", hhFile)
  message("Loading it...")
  hhDT <- data.table::fread(hhFile)
} else {
  message("Oops. Didn't find expected household survey file: ", hhFile)
  stop("Please check you have set the paths and filename correctly...")
}

# Household attributes included in safe data ----
# see https://cfsotago.github.io/GREENGridData/householdAttributeProcessingReport_v1.0.html#9_energy_cultures_2_long_survey_questions

#Q1	The Centre for Sustainability (CSAFE) at the University of Otago, /  is researching New Zealanders'... ----

#Q2	By clicking on this link, I confirm that I agree to participate in / this research. ----

#Q3	Before proceeding to the survey I need to check that you would be / representative of the population. That is there aren't too many / people from one area, age or gender. Are you: ----
#hhDT[Q3 := ]
# Where is Q3 - Gender ??

#Q4	Your age is:	Yes (coded) ----
# 18-29 (1)
# 30-44 (15)
# 45-59 (16)
# 60-74 (17)
# 75 and over (18)
hhDT[, Q4lab := dplyr::recode(Q4, `1` = "18-29", 
              `15` = "30-44", 
              `16` = "45-59",
              `17` = "45-59",
              `18` = "75+",
              )]
table(hhDT$Q4, hhDT$Q4lab, useNA = "always")

#Q5 The region that you live in is: ----

#Q6	What type of dwelling do you live in?Â  (please select the /  option which applies to you)
#Separate house (1)
#Flat/apartment adjoining other flats (or buildings) (2)
#Other (3)
# hhDT[, Q6lab := dplyr::recode(Q6, `1` = "House", 
#                               `2` = "Flat/apt", 
#                               `3` = "Other"
# )]
# table(hhDT$Q6, hhDT$Q6lab, useNA = "always")
# where is Q6?

#Q7 When was your house built? ----
#Before 1978 (1)
#Between 1978 – 1999 (2)
#Between 2000 - 2007 (3)
#After 2007 (4)
#Don't know (5)
hhDT[, Q7lab := dplyr::recode(Q7, `1` = "1977 or earlier", 
                              `2` = "1978-1999", 
                              `3` = "2000-2007",
                              `4` = "2008 or later"
)]
table(hhDT$Q7, hhDT$Q7lab, useNA = "always")

#Q8	How are your external walls constructed? ----
# Not included?

#Q9	What are the external walls of your house constructed from? ----
# Not included?

# Q10#1_1_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Bedrooms-Rooms ----
# Q10#1_1_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Bedrooms-Rooms heated regularly ----
# Q10#1_2_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Lounges or living rooms-Rooms ----
# Q10#1_2_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Lounges or living rooms-Rooms heated regularly ----
# Q10#1_3_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Dining rooms or kitchen/dining rooms-Rooms ----
# Q10#1_3_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Dining rooms or kitchen/dining rooms-Rooms heated regularly ----
# Q10#1_4_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Separate Kitchens-Rooms ----
# Q10#1_4_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Separate Kitchens-Rooms heated regularly ----
# Q10#1_5_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Studies or offices-Rooms ----
# Q10#1_5_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Studies or offices-Rooms heated regularly ----
# Q10#1_6_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Bathrooms-Rooms ----
# Q10#1_6_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Bathrooms-Rooms heated regularly ----
# Q10#1_7_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Separate toilets-Rooms ----
# Q10#1_7_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Separate toilets-Rooms heated regularly ----
# Q10#1_8_1_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Laundries-Rooms ----
# Q10#1_8_2_TEXT	How many rooms does your dwelling have and which do you heat / regularly? â€“ (please write the number of rooms in the boxes / provided) : Number of-Laundries-Rooms heated regularly ----

# Q11_1	How many hours of direct sunshine would your house get on a clear / winterâ€™s day in June-July?-Hours ----

# Q14_1	How long have you lived in your current house? (in years) -Years ----

# Q15_1	How much longer do you plan to live in your house?-Years ----

# Q17_1	What temperature do you set your main living area at in degrees / Celsius?-Degrees Celsius ----

# Q18_1	What temperature would you like your main living area to be, in / degrees Celsius?-Degrees Celsius ----


# Q19_1	Which of the following methods do you have available for heating / your house? -Heat pump ----
# Q19_2	Which of the following methods do you have available for heating / your house? -Electric night-store ----
# Q19_3	Which of the following methods do you have available for heating / your house? -Portable electric heaters ----
# Q19_4	Which of the following methods do you have available for heating / your house? -Electric heaters fixed in place ----
# Q19_5	Which of the following methods do you have available for heating / your house? -Enclosed coal burner ----
# Q19_6	Which of the following methods do you have available for heating / your house? -Enclosed wood burner ----
# Q19_7	Which of the following methods do you have available for heating / your house? -Portable gas heater ----
# Q19_8	Which of the following methods do you have available for heating / your house? -Gas heaters fixed in place ----
# Q19_9	Which of the following methods do you have available for heating / your house? -Central heating â€“ gas (flued) ----
# Q19_10	Which of the following methods do you have available for heating / your house? -Central heating â€“ electric ----
# Q19_11	Which of the following methods do you have available for heating / your house? -DVS or other heat transfer system ----
# Q19_12	Which of the following methods do you have available for heating / your house? -HRV or other ventilation system ----
# Q19_13	Which of the following methods do you have available for heating / your house? -Underfloor electric heating ----
# Q19_14	Which of the following methods do you have available for heating / your house? -Underfloor gas heating ----
# Q19_15	Which of the following methods do you have available for heating / your house? -Open fire ----
# Q19_16	Which of the following methods do you have available for heating / your house? -Other ----
# Q19_17	Which of the following methods do you have available for heating / your house? -Central he ----ating pellet burner ----



# Q30_1	What temperature do you set your heat pump to for cooling, in / degrees Celcius?-Degrees Celsius ----

# Q33_1	If known, what temperature do you set your hot water to?  / (degrees Celsius)-Degrees Celsius ----

# Q53_1	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Electricity   ----                                                                                               
# Q53_2	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Gas   ----                                                                                            
# Q53_3	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Coal     ----                                                                                                      
# Q53_4	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Wood       ----                                                                                                  
# Q53_5	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Petrol ----
# Q53_6	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Diesel ----
# Q53_7	What are your households approximate monthly energy bills in the / SUMMER? (dollars)-Other ----
hhDT[, summerElecCost := Q53_1]
hhDT[, summerGasCost := Q53_2]
hhDT[, summerCoalCost := Q53_3]
hhDT[, summerWoodCost := Q53_4]
# Q54_1	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Electricity    ----                                                                                              
# Q54_2	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Gas    ----                                                                                                        
# Q54_3	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Coal      ----                                                                                                     
# Q54_4	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Wood       ----                                                                                                  
# Q54_5	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Petrol   ----
# Q54_6	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Diesel ----
# Q54_7	What are your household approximate monthly energy bills in the / WINTER? (dollars) -Other ----
hhDT[, winterElecCost := Q54_1]
hhDT[, winterGasCost := Q54_2]
hhDT[, winterCoalCost := Q54_3]
hhDT[, winterWoodCost := Q54_4]

# Q55	What is your approximate combined household income before / tax? 	Yes (coded) ----

# Q57	How many people live in your household?  ----
