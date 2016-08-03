clear all
set more off


local maindir "/cm/scratch3/m1jms13/gabaix/"
local output "/cm/research/m1jms13/nitish/gabaix/output"
use "`maindir'regressionvars.dta"


/* Clean the data and set time variable */
gen year= year(date)
gen qtr = quarter(date)
rename date old_date
gen date = yq(year,qtr)
format date %tq
tset date

gen loggdp = log(gdp)
gen gdpgrowth = D.loggdp


keep if year > 1974

/* Create Standardized Varaibles */
egen n_gdpgrowth = std(gdpgrowth)
egen n_gamma_q100_k100 = std(gamma_q100_k100)
egen n_gamma_q1000_k100 = std(gamma_q1000_k100)
egen n_gamma_q100_kmid = std(gamma_q100_kmid)
egen n_gamma_q1000_kmid = std(gamma_q1000_kmid)
egen n_gbar_q100 = std(gbar_q100)
egen n_gbar_qmid = std(gbar_qmid)


gen L_gbar_qmid = L.gbar_qmid
gen L_gbar_q100 = L.gbar_q100
gen L_gamma_q1000_kmid = L.gamma_q1000_kmid
gen L_gamma_q1000_k100 = L.gamma_q1000_k100

local qtrdums i.qtr
local gbar_qmid gbar_qmid
*L.gbar_qmid
local gbar_q100 gbar_q100
*L.gbar_q100
local gamma_kmid gamma_q1000_kmid
*L.gamma_q1000_kmid
local gamma_k100 gamma_q1000_k100
*L.gamma_q1000_k100


quietly: eststo mod1: newey gdpgrowth `gbar_q100' `qtrdums',  lag(4)
quietly: eststo mod2: newey gdpgrowth `gbar_qmid' `qtrdums',  lag(4)
quietly: eststo mod3: newey gdpgrowth `gamma_k100' `qtrdums',  lag(4)
quietly: eststo mod4: newey gdpgrowth `gamma_kmid' `qtrdums',  lag(4)
quietly: eststo mod5: newey gdpgrowth `gbar_q100' `gbar_qmid' `qtrdums',  lag(4)
quietly: eststo mod6: newey gdpgrowth `gamma_k100' `gamma_kmid' `qtrdums',  lag(4)
quietly: eststo mod7: newey gdpgrowth `gbar_qmid' `gamma_kmid' `qtrdums',  lag(4)
quietly: eststo mod8: newey gdpgrowth `gbar_q100' `gbar_qmid' `gamma_k100' `gamma_kmid' `qtrdums',  lag(4)


quietly: eststo mod41: newey `gbar_q100' `qtrdums' gdpgrowth,  lag(4)
quietly: eststo mod42: newey `gbar_qmid' `qtrdums' gdpgrowth ,  lag(4)
quietly: eststo mod43: newey `gamma_k100' `qtrdums' gdpgrowth,  lag(4)
quietly: eststo mod44: newey `gamma_kmid' `qtrdums' gdpgrowth,  lag(4)
quietly: eststo mod45: newey `gbar_q100' `gbar_qmid' `qtrdums' gdpgrowth,  lag(4)
quietly: eststo mod46: newey `gamma_k100' `gamma_kmid' `qtrdums' gdpgrowth,  lag(4)
quietly: eststo mod47: newey  `gbar_qmid' `gbar_q100' `qtrdums' gdpgrowth,  lag(4)
quietly: eststo mod48: newey  `gamma_kmid' `gamma_k100' `qtrdums' gdpgrowth,  lag(4)

quietly: eststo mod11: newey gdpgrowth L.n_gdpgrowth `gbar_q100' `qtrdums',  lag(4)
quietly: eststo mod12: newey gdpgrowth L.n_gdpgrowth `gbar_qmid' `qtrdums',  lag(4)
quietly: eststo mod13: newey gdpgrowth L.n_gdpgrowth `gamma_k100' `qtrdums',  lag(4)
quietly: eststo mod14: newey gdpgrowth L.n_gdpgrowth `gamma_kmid' `qtrdums',  lag(4)
quietly: eststo mod15: newey gdpgrowth L.n_gdpgrowth `gbar_q100' `gbar_qmid' `qtrdums',  lag(4)
quietly: eststo mod16: newey gdpgrowth L.n_gdpgrowth `gamma_k100' `gamma_kmid' `qtrdums',  lag(4)
quietly: eststo mod17: newey gdpgrowth L.n_gdpgrowth `gbar_qmid' `gamma_kmid' `qtrdums',  lag(4)
quietly: eststo mod18: newey gdpgrowth L.n_gdpgrowth `gbar_q100' `gbar_qmid' `gamma_k100' `gamma_kmid' `qtrdums',  lag(4)

quietly: eststo mod31: qreg gdpgrowth `gbar_q100' `qtrdums' ,vce(robust)
quietly: eststo mod32: qreg gdpgrowth `gbar_qmid' `qtrdums' ,vce(robust)
quietly: eststo mod33: qreg gdpgrowth `gamma_k100' `qtrdums' ,vce(robust)
quietly: eststo mod34: qreg gdpgrowth `gamma_kmid' `qtrdums' ,vce(robust)
quietly: eststo mod35: qreg gdpgrowth `gbar_q100' `gbar_qmid' `qtrdums' ,vce(robust)
quietly: eststo mod36: qreg gdpgrowth `gamma_k100' `gamma_kmid' `qtrdums' ,vce(robust)
quietly: eststo mod37: qreg gdpgrowth `gbar_qmid' `gamma_kmid' `qtrdums' ,vce(robust)
quietly: eststo mod38: qreg gdpgrowth `gbar_q100' `gbar_qmid' `gamma_k100' `gamma_kmid' `qtrdums' ,vce(robust)




esttab mod1 mod2 mod3 mod4 mod5 mod6 mod7 mod8, se 
esttab mod11 mod12 mod13 mod14 mod15 mod16 mod17 mod18, se
esttab mod31 mod32 mod33 mod34 mod35 mod36 mod37 mod38, se 
esttab mod41 mod42 mod43 mod44 mod45 mod46 mod47 mod48, se

/* Some Plots
twoway scatter n_gdpgrowth n_gbar_qmid
twoway scatter n_gdpgrowth  n_gbar_q100
*/
