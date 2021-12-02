# Test household attributes ----
library(here)
# Load data & code ----
source(here::here("reshareDataProcessing", "code", "codeHouseholdAttributes.R"))

# Estimated energy costs in winter by age of dwelling ----

#> Elec ----
hhDT[, .(winterElecCost = mean(winterElecCost, na.rm = TRUE),
         winterGasCost = mean(winterGasCost, na.rm = TRUE),
         winterCoalCost = mean(winterCoalCost, na.rm = TRUE),
         winterWoodCost = mean(winterCoalCost, na.rm = TRUE)), keyby = .(Q7lab)]

hhDT[!is.na(winterElecCost), .(winterElecCostMean = mean(winterElecCost, na.rm = TRUE),
                               winterElecCostSD = sd(winterElecCost, na.rm = TRUE),
                               n = uniqueN(linkID)), keyby = .(Q7lab)]

library(ggplot2)
ggplot2::ggplot(hhDT, aes(fill = Q7lab, 
                          x = winterElecCost,
                          alpha = 0.4)) +
  geom_density() +
  labs(x = "Monthly estimated winter electricity cost ($)") +
  theme(legend.position="bottom") + 
  scale_fill_discrete(name="Age of dwelling") +
  guides(alpha=FALSE)
  
ggplot2::ggsave(filename = "winterElecByDwellingAge.jpg",
                path = here::here("reshareDataProcessing", "outputs"),
                width = 4
                )

#> Gas ----
hhDT[!is.na(winterGasCost), .(winterGasCost = mean(winterGasCost),
                              n = uniqueN(linkID)), keyby = .(Q7lab)]
ggplot2::ggplot(hhDT, aes(fill = Q7lab, 
                          x = winterGasCost,
                          alpha = 0.4)) +
  geom_density() +
  labs(x = "Monthly estimated winter gas cost ($)") +
  theme(legend.position="bottom") + 
  scale_fill_discrete(name="Age of dwelling") +
  guides(alpha=FALSE)

ggplot2::ggsave(filename = "winterGasByDwellingAge.jpg",
                path = here::here("reshareDataProcessing", "outputs"),
                width = 4
)
