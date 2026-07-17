# US EQUITY RISK PREMIUM ----

# equity risk premium derived from S&P 500 Annual Dividend future contracts
# motivation: ČNB paper Deriving Equity Risk Premium Using Dividend Futures
# source: https://www.cnb.cz/en/economic-research/research-publications/cnb-working-paper-series/Deriving-Equity-Risk-Premium-Using-Dividend-Futures-00001/
# replication of the original methodology + augmentation by net share buybacks

# market capitalization, buyback and dividend data from S&P
# source: https://www.spglobal.com/spdji/en/indices/equity/sp-500/#overview

# key variable = net buybacks/earnings
# historical trends, ROE, index units conversion and payout ratios obtained from Damodaran
# source: https://pages.stern.nyu.edu/~adamodar/New_Home_Page/home.htm
# share issuance data = CapitalIQ

# sanity check = sustainable payout ratio
# dividends and net buybacks as a % of S&P 500 earnings converges to 1 - g/ROE in the long term (Damodaran)
# g = US long-run nominal growth rate, ROE = S&P 500 aggregate return on equity (average of last 5/10 years)
# S&P 500 earnings historical data and forecast = Yardeni Research
# source: https://www.yardeni.com/charts/global-financial-markets/overview-outlook/yri-earnings-outlook
# US long-run growth = FOMC SEP
# source: https://www.federalreserve.gov/monetarypolicy/materials/

## USER INPUT ----
# base (year 0) S&P 500 net buybacks/earnings ratio = buybacks
# long-run (year20 onwards) target/sustainable payout ratio = sus_payout
# long-run S&P 500 earnings/cash flow growth rate = g
# current S&P 500 index value = P
# S&P 500 annual dividend futures = futuresXX
# S&P 500 annual forecast earnings = earningsXX
# USD riskless rate (SOFR) = rfXX
# 

library(zoo)
library(splines)
library(readr)
library(openxlsx)
library(readxl)
library(writexl)

## EARNINGS ----
# assumption = cash flows occur at year-end, annual compounding employed
# cubic spline interpolation of S&P 500 earnings forecast from Yardeni
# earnings beyond the explicit forecast period extrapolated using a method employed by Damodaran

# sample import from Excel (s&p_earnings.xlsx), stored in your working directory
earnings = read.xlsx("s&p_earnings.xlsx")
earnings

earnings$day = as.Date(earnings$date)
# print(earnings)

daily = seq(earnings$day[1], tail(earnings$day,1), by="day")
daily

new_data = earnings[c("day","earnings")]
new_data$earnings = as.numeric(new_data$earnings)

cubic_data  = data.frame(day = daily, cubic_data = spline(new_data, method="natural", xout = daily)$y)
mydata = merge(new_data, cubic_data, by="day", all = TRUE)
# View(mydata)

## DIVIDEND FUTURES ----
# cubic spline interpolation of S&P 500 Annual Dividend Index future contracts
# each contract settles on a pre-specified date in December
# schedule: https://www.cmegroup.com/markets/equities/sp/sp-500-annual-dividend-index.calendar.html
# underlying index: https://www.spglobal.com/spdji/en/indices/equity/sp-500-dividend-points-index-annual/#overview
# quotes source: LSEG Workspace

# import sample data from futures.xlsx
futures = read.xlsx("futures.xlsx")
futures

futures$day = as.Date(futures$date)
# print(futures)

daily = seq(futures$day[1], tail(futures$day,1), by="day")
daily

new_futures = futures[c("day","futures")]
new_futures$futures = as.numeric(new_futures$futures)

cubic_futures  = data.frame(day = daily, cubic_futures = spline(new_futures, method="natural", xout = daily)$y)
myfutures = merge(new_futures, cubic_futures, by="day", all = TRUE)
# View(myfutures)

# model trade date = 14 July 2026
# model settlement date (T+2) = 16 July 2026

# S&P 500 earnings (interpolated)
earnings27 = mydata$cubic_data[mydata$day == as.Date("2027-07-16")]
earnings28 = mydata$cubic_data[mydata$day == as.Date("2028-07-16")]
earnings29 = mydata$cubic_data[mydata$day == as.Date("2029-07-16")]
earnings30 = mydata$cubic_data[mydata$day == as.Date("2030-07-16")]
earnings31 = mydata$cubic_data[mydata$day == as.Date("2031-07-16")]
earnings32 = mydata$cubic_data[mydata$day == as.Date("2032-07-16")]
earnings33 = mydata$cubic_data[mydata$day == as.Date("2033-07-16")]
earnings34 = mydata$cubic_data[mydata$day == as.Date("2034-07-16")]
earnings35 = mydata$cubic_data[mydata$day == as.Date("2035-07-16")]
earnings36 = mydata$cubic_data[mydata$day == as.Date("2036-07-16")]
earnings37 = mydata$cubic_data[mydata$day == as.Date("2037-07-16")]
earnings38 = mydata$cubic_data[mydata$day == as.Date("2038-07-16")]
earnings39 = mydata$cubic_data[mydata$day == as.Date("2039-07-16")]
earnings40 = mydata$cubic_data[mydata$day == as.Date("2040-07-16")]
earnings41 = mydata$cubic_data[mydata$day == as.Date("2041-07-16")]
earnings42 = mydata$cubic_data[mydata$day == as.Date("2042-07-16")]
earnings43 = mydata$cubic_data[mydata$day == as.Date("2043-07-16")]
earnings44 = mydata$cubic_data[mydata$day == as.Date("2044-07-16")]
earnings45 = mydata$cubic_data[mydata$day == as.Date("2045-07-16")]
earnings46 = mydata$cubic_data[mydata$day == as.Date("2046-07-16")]

# S&P 500 annual dividend future contract quotes (interpolated)
futures27 = myfutures$cubic_futures[myfutures$day == as.Date("2027-07-16")]
futures28 = myfutures$cubic_futures[myfutures$day == as.Date("2028-07-16")]
futures29 = myfutures$cubic_futures[myfutures$day == as.Date("2029-07-16")]
futures30 = myfutures$cubic_futures[myfutures$day == as.Date("2030-07-16")]
futures31 = myfutures$cubic_futures[myfutures$day == as.Date("2031-07-16")]
futures32 = myfutures$cubic_futures[myfutures$day == as.Date("2032-07-16")]
futures33 = myfutures$cubic_futures[myfutures$day == as.Date("2033-07-16")]
futures34 = myfutures$cubic_futures[myfutures$day == as.Date("2034-07-16")]
futures35 = myfutures$cubic_futures[myfutures$day == as.Date("2035-07-16")]
futures36 = myfutures$cubic_futures[myfutures$day == as.Date("2036-07-16")]

## RISKLESS RATE ----
# riskless rate = zero-coupon USD SOFR OIS rate
# annual compounding
# curve source: LSEG Workspace
# import SOFR swap curve from Excel (sample data from sofr_curve.xlsx)
sofr = read.xlsx("sofr_curve.xlsx")
sofr

rf1 = sofr$rate[1]
rf2 = sofr$rate[2]
rf3 = sofr$rate[3]
rf4 = sofr$rate[4]
rf5 = sofr$rate[5]
rf6 = sofr$rate[6]
rf7 = sofr$rate[7]
rf8 = sofr$rate[8]
rf9 = sofr$rate[9]
rf10 = sofr$rate[10]
rf11 = sofr$rate[11]
rf12 = sofr$rate[12]
rf13 = sofr$rate[13]
rf14 = sofr$rate[14]
rf15 = sofr$rate[15]
rf16 = sofr$rate[16]
rf17 = sofr$rate[17]
rf18 = sofr$rate[18]
rf19 = sofr$rate[19]
rf20 = sofr$rate[20]

## TERMINAL GROWTH RATE ----
# long-run nominal GDP growth rate from FOMC SEP
g = 0.038

## S&P 500 PRICE ----
# S&P 500 index value today (14.07.2026)
P = 7408.5

## BUYBACK PAYOUT ----
# import historical net buybacks/earnings ratios, net payout (dividend + buybacks) ratios
# sample data = s&p_payout.xlsx
ratio = read.xlsx("s&p_payout.xlsx")
ratio

# historical net buyback payout 
buy_payout = ratio$buy_payout[1:12]

# arithmetical average of net buybacks/earnings since 2014
# USE IF: the most recent payout ratio appears implausible/as an outlier
mean_buy_payout = mean(ratio$buy_payout, na.rm = TRUE)
mean_buy_payout

# 75th percentile since 2014
# USE IF: strong forecast earnings growth outpaces dividend growth
# and stable total net payout ratio is desirable
buy_payout_75 = quantile(
  buy_payout,
  probs = 1,
  na.rm = TRUE
)
buy_payout_75

# 25th percentile since 2014
# USE IF: buybacks outlook is weak, impending recession/economic slowdown
buy_payout_25 = quantile(
  buy_payout,
  probs = 0.25,
  na.rm = TRUE
)
buy_payout_25

# the most recent historical net buyback payout ratio
recent_buy = buy_payout[12]
recent_buy

# buyback ratio used as a base (year 0) in the model
buybacks = mean_buy_payout
buybacks

## SUSTAINABLE PAYOUT ----
# most recent net total payout ratio = (net buybacks + dividends)/earnings
payout = ratio$payout[12]
payout

# sustainable payout ratio
# 5-year average ROE = 19.75%
# 10-year average ROE = 18.01%
# g = 0.038
sus_payout = 1 - g/0.1801
sus_payout

## SYSTEM OF NON-LINEAR EQUATIONs ----

# non-linear system of equation solved using the Broyden numerical optimization method
# package nleqslv employed
# R documentation = https://www.rdocumentation.org/packages/nleqslv/versions/3.3.5/topics/nleqslv

# unknown variables: expected dividends, equity risk premium, terminal net buyback payout
library(nleqslv)

f = function(x) {
  # expected dividends derived from the market-quoted futures contracts (years 1-10)
  div27 = x[1]
  div28 = x[2]
  div29 = x[3]
  div30 = x[4]
  div31 = x[5]
  div32 = x[6]
  div33 = x[7]
  div34 = x[8]
  div35 = x[9]
  div36 = x[10]
  
  # equity risk premium constant for the entire maturity spectrum
  rp = x[11]
  
  # terminal net buyback payout
  buybacks_ter = x[12]
  
  # transition from the dividend futures quote to the expected dividend (10 equations = 10 years)
  eq1 = (div27 / (1 + rp + rf1)) * (1 + rf1) - futures27
  eq2 = (div28 / ((1 + rp + rf2)^2)) * ((1 + rf2)^2) - futures28
  eq3 = (div29 / ((1 + rp + rf3)^3)) * ((1 + rf3)^3) - futures29
  eq4 = (div30 / ((1 + rp + rf4)^4)) * ((1 + rf4)^4) - futures30
  eq5 = (div31 / ((1 + rp + rf5)^5)) * ((1 + rf5)^5) - futures31
  eq6 = (div32 / ((1 + rp + rf6)^6)) * ((1 + rf6)^6) - futures32
  eq7 = (div33 / ((1 + rp + rf7)^7)) * ((1 + rf7)^7) - futures33
  eq8 = (div34 / ((1 + rp + rf8)^8)) * ((1 + rf8)^8) - futures34
  eq9 = (div35 / ((1 + rp + rf9)^9)) * ((1 + rf9)^9) - futures35
  eq10 = (div36 / ((1 + rp + rf10)^10)) * ((1 + rf10)^10) - futures36
  
  # linear convergence from current net buyback payout to the terminal buyback payout
  # vector of years 1 to 20
  z = 1:20
  
  # convergence between the two nodal ratios over the next 20 years
  b = buybacks + (buybacks_ter - buybacks)*(z/20)
  
  # resulting growth rates
  buyback_df = data.frame(
    z = z,
    b = b
  )
  
  # net buyback payout ratios from year 1 to year 20
  b27 = b[1]
  b28 = b[2]
  b29 = b[3]
  b30 = b[4]
  b31 = b[5]
  b32 = b[6]
  b33 = b[7]
  b34 = b[8]
  b35 = b[9]
  b36 = b[10]
  b37 = b[11]
  b38 = b[12]
  b39 = b[13]
  b40 = b[14]
  b41 = b[15]
  b42 = b[16]
  b43 = b[17]
  b44 = b[18]
  b45 = b[19]
  b46 = b[20]
  
  # helper equation => three stages of the S&P 500 cash flow growth
  # first stage => explicit growth
  s1 = (div27 + b27*earnings27)/(1 + rp + rf1) + (div28 + b28*earnings28)/((1 + rp + rf2)^2) +(div29 + b29*earnings29)/((1 + rp + rf3)^3) + (div30 + b30*earnings30)/((1 + rp + rf4)^4) + (div31 + b31*earnings31)/((1 + rp + rf5)^5) + (div32 + b32*earnings32)/((1 + rp + rf6)^6) + (div33 + b33*earnings33)/((1 + rp + rf7)^7) + (div34 + b34*earnings34)/((1 + rp + rf8)^8) + (div35 + b35*earnings35)/((1 + rp + rf9)^9) + (div36 + b36*earnings36)/((1 + rp + rf10)^10)
  
  # second stage = growth rate linearly transitions from the last dividend-implied growth rate to the terminal growth rate g over 10 years
  # dividend-implied growth rate (year 10)
  div_g = div36/div35-1
  
  # first stage duration = 10 years
  N_1 = 10
  
  # first stage + second stage duration = 20 years
  L_1 = 20
  
  # vector n of years 11 to 20
  n = 11:20
  
  # linear interpolation between the two nodal growth rates
  lin_g = div_g + (g - div_g)*((n - N_1)/(L_1 - N_1))
  
  # resulting interpolated growth rates
  growth_df = data.frame(
    n = n,
    lin_g = lin_g
  )
  
  # S&P 500 cash flows from year 11 to 20
  div37 = div36*(1+lin_g[1])
  div38 = div37*(1+lin_g[2])
  div39 = div38*(1+lin_g[3])
  div40 = div39*(1+lin_g[4])
  div41 = div40*(1+lin_g[5])
  div42 = div41*(1+lin_g[6])
  div43 = div42*(1+lin_g[7])
  div44 = div43*(1+lin_g[8])
  div45 = div44*(1+lin_g[9])
  div46 = div45*(1+lin_g[10])
  
  # second stage => equation 
  s2 = ((div37+earnings37*b37) / ((1 + rp + rf11)^11)) + ((div38+earnings38*b38)/ ((1 + rp + rf12)^12)) + ((div39+earnings39*b39) / ((1 + rp + rf13)^13)) + ((div40+earnings40*b40) / ((1 + rp + rf14)^14)) + ((div41+earnings41*b41) / ((1 + rp + rf15)^15)) + ((div42 + earnings42*b42) / ((1 + rp + rf16)^16)) + ((div43+earnings43*b43) / ((1 + rp + rf17)^17)) + ((div44+earnings44*b44) / ((1 + rp + rf18)^18)) + ((div45+earnings45*b45) / ((1 + rp + rf19)^19)) + ((div46+earnings46*b46) / ((1 + rp + rf20)^20))
  
  # third stage => terminal value formula: terminal growth rate = g (year 21)
  s3 = ((div46+earnings46*buybacks_ter)*(1+g))/(((1 + rp + rf20)^20)*(rf20 + rp - g))
  
  # S&P 500 index price formula = sum of the three stages
  eq11 = (s1 + s2 + s3) - P
  
  # terminal net buyback payout consistent with the sustainable payout ratio
  # buybacks_ter = b46
  eq12 = (buybacks_ter + div46/earnings46) - sus_payout
  
  # vector comprising the equation system
  c(eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10, eq11, eq12)
  
}

# initial value guesses vector
x0 = c(
  div27 = 83.9,
  div28 = 83.9,
  div29 = 83.65,
  div30 = 83.65,
  div31 = 83.65,
  div32 = 85.1,
  div33 = 85.75,
  div34 = 86.7,
  div35 = 87,
  div36 = 88,
  rp = 0.04,
  buybacks_ter = 0.42)

# solution (Broyden)
sol = nleqslv(x = x0, fn = f, method="Broyden")

# solved variables
# expected dividend payments
div27 = sol$x[1]
div28 = sol$x[2]
div29 = sol$x[3]
div30 = sol$x[4]
div31 = sol$x[5]
div32 = sol$x[6]
div33 = sol$x[7]
div34 = sol$x[8]
div35 = sol$x[9]
div36 = sol$x[10]

# equity risk premium
rp = sol$x[11]

# terminal net buyback payout
buybacks_ter = sol$x[12]

## OUTPUT ----
# results displayed
div27
div28
div29
div30
div31
div32
div33
div34
div35
div36
rp
buybacks_ter

results_df = data.frame(
  name = c(
    "DIVIDEND2027",
    "DIVIDEND2028",
    "DIVIDEND2029",
    "DIVIDEND2030",
    "DIVIDEND2031",
    "DIVIDEND2032",
    "DIVIDEND2033",
    "DIVIDEND2034",
    "DIVIDEND2035",
    "DIVIDEND2036",
    "EQUITY RISK PREMIUM",
    "BUYBACK PAYOUT"
  ),
  results = c(
    div27,
    div28,
    div29,
    div30,
    div31,
    div32,
    div33,
    div34,
    div35,
    div36,
    rp,
    buybacks_ter
  ),
  stringsAsFactors = FALSE
)

results_df

# export results to your working directory in an excel format
results_excel = write.xlsx(
  results_df,
  file = "erp.xlsx",
  sheetName = "Results",
  overwrite = TRUE,
  rowNames = FALSE,
)
# results_excel 

## RESULT VERIFICATION ----
# model-implied future contract = actual market quote
dd = (div30 / (1 + rp + rf4)^4) * ((1 + rf4)^4)
dd
futures30

# terminal payout = sustainable payout ratio
div_g = div36/div35-1
N_1 = 10
L_1 = 20
n = 11:20

lin_g = div_g + (g - div_g) * ((n - N_1)/(L_1 - N_1))

div37 = div36 * (1 + lin_g[1])
div38 = div37 * (1 + lin_g[2])
div39 = div38 * (1 + lin_g[3])
div40 = div39 * (1 + lin_g[4])
div41 = div40 * (1 + lin_g[5])
div42 = div41 * (1 + lin_g[6])
div43 = div42 * (1 + lin_g[7])
div44 = div43 * (1 + lin_g[8])
div45 = div44 * (1 + lin_g[9])
div46 = div45 * (1 + lin_g[10])

# output equal to the selected sustainable payout ratio
# year 20
(div46 + earnings46*buybacks_ter)/(earnings46)
# year 21 = terminal value
((div46 + earnings46*buybacks_ter)*(1+g))/(earnings46*(1+g))

# selected net payout ratios (net buybacks + dividends)
z = 1:20

b = buybacks + (buybacks_ter - buybacks)*(z/20)

buyback_df = data.frame(
  z = z,
  b = b
)

b27 = b[1]
b28 = b[2]
b29 = b[3]
b30 = b[4]
b31 = b[5]
b32 = b[6]
b33 = b[7]
b34 = b[8]
b35 = b[9]
b36 = b[10]
b37 = b[11]
b38 = b[12]
b39 = b[13]
b40 = b[14]
b41 = b[15]
b42 = b[16]
b43 = b[17]
b44 = b[18]
b45 = b[19]
b46 = b[20]

# year 2046 = sustainable payout ratio
(div46 + b46*earnings46)/earnings46
# year 2040
(div40 + b40*earnings40)/earnings40
# year 2036
(div36+b36*earnings36)/earnings36
# year 2031
(div31 + b31*earnings31)/earnings31
# year2028
(div28+b28*earnings28)/earnings28
# year 2027
(div27+b27*earnings27)/earnings27

# dollar value of net payout (net buybacks + dividends)
# year 2027
div27+b27*earnings27

# year 2031
div31  + b31*earnings31

# dollar value of earnings
# year 2027
earnings27

# year 2031
earnings31