# US Equity Risk Premium 

An R implementation of the methodology laid out in [Deriving Equity Risk Premium Using
Dividend Futures](https://www.cnb.cz/export/sites/cnb/en/economic-research/.galleries/research_publications/cnb_wp/cnbwp_2021_01.pdf) (Časta, 2021), extended to accommodate buybacks. The US equity risk premium is backed out from future contracts tracking the [S&P 500 Annual Dividend Index](https://www.cmegroup.com/markets/equities/sp/sp-500-annual-dividend-index.contractSpecs.html) and net S&P 500 buybacks (gross annual buybacks less share issuance), forecast as a proportion of the [consensus S&P 500 earnings](https://www.yardeni.com/charts/global-financial-markets/overview-outlook/yri-earnings-outlook). Both the future contract quotes and the earnings are interpolated via the natural cubic spline method in order to facilitate annual discounting.
## Net Buybacks

Net buybacks as a percentage of S&P 500 earnings, initially set to a user-input base (year 0), linearly converge to a terminal ratio
over the course of the explicit 20 year forecast period. In perpetuity, the ratio is consistent with the concept of the total sustainable payout [sustainable payout](https://pages.stern.nyu.edu/~adamodar/pc/implprem/ERPJuly26.xlsx) (net buybacks + dividends as a share of earnings), given as 

    sustainable payout = 1 - g/ROE

with g and ROE denoting the long-run nominal earnings growth rate and the terminal aggregate return on equity of the S&P 500 index, respectively.
## User Input
* `buybacks` = base (year 0) S&P 500 net buybacks/earnings ratio
* `sus_payout` = long-run (year20 onwards) total target/sustainable payout ratio
* `g` = long-run S&P 500 earnings/cash flow growth rate
* `P` = current S&P 500 index value 
* `futuresXX` = S&P 500 annual dividend futures
* `earningsXX` = S&P 500 annual forecast earnings
* `rfXX`= USD riskless rate (SOFR)




## Data Source

The dividend futures (settlement schedule available through the [CME Group](https://www.cmegroup.com/markets/equities/sp/sp-500-annual-dividend-index.calendar.html)) and the zero SOFR curve are obtained from LSEG Workspace. The explicit consensus S&P 500 earnings forecast is provided by [Yardeni Research](https://www.yardeni.com/charts/global-financial-markets/overview-outlook/yri-earnings-outlook) and extrapolated forward via a method from [Aswath Damodaran](https://pages.stern.nyu.edu/~adamodar/pc/implprem/ERPJuly26.xlsx), who also computes the index ROE, the index unit conversion factor and historical payout ratios. The data for historical S&P 500 earnigns, gross buybacks and dividends originates from [S&P Global](https://www.spglobal.com/spdji/en/documents/additional-material/sp-500-buyback.xlsx) while historical share issuance is sourced from CapitalIQ. The long-run growth rate comes from the Federal Open Market Committee [Summary of Economic Projections](https://www.federalreserve.gov/monetarypolicy/materials/). Sample data is available in the enclosed Excel files (futures.xlsx, sofr_curve.xlsx, s&p_earnings.xlsx, s&p_payout.xlsx).
## References
The original ČNB working paper:

    Časta, M. (2021). Deriving Equity Risk Premium Using Dividend Futures. ČNB Working Paper Series 1/2021. 
    https://www.cnb.cz/export/sites/cnb/en/economic-research/.galleries/research_publications/cnb_wp/cnbwp_2021_01.pdf
