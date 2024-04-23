# Load libraries
library(data.table) 

# Read male data
df_m = as.data.table(read_dta('march_cps_males.dta'))

# Read female data
df_f = as.data.table(read_dta('march_cps_females.dta'))

# Add 'male' column: 1 if male, 0 if female
df_m[, male := 1]
df_f[, male := 0]

# Combine male and female data frames
df <- rbindlist(list(df_m, df_f))

# Create log hourly wages and log weekly earnings columns
df[, loghourly_wage := log(hourly_wage)]
df[, logweekly_earn := log(weekly_earn)]

# Add variable that takes on integers from 0 to 34 for years since 1976
df[, yrs_since_76 := year - 1976]

# Add interaction variable college_grad*years_since_1976
df[, college_grad_yrs_since_76 := college_grad * yrs_since_76]

# Add married and white dummy variables using vectorized operations
df[, married := as.integer(marital_status == 1)]
df[, white := as.integer(race4 == 1)]
df[, black := as.integer(race4 == 2)]

# Inspect size
nrow(df)
names(df)

# Write to csv
write.csv(as.data.frame(df), "collegepremium.csv")

