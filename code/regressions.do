clear all
set more off



local maindir "/cm/scratch3/m1jms13/gabaix/"
local output "/cm/research/m1jms13/nitish/gabaix/output"

use "`maindir'regressionvars.dta"


quietly: eststo modall: newey gdpgrwth gbarall, lag(4)
quietly: eststo modmid: newey gdpgrwth gbarmid, lag(4)
quietly: eststo modallmid: newey gdpgrwth gbarmid gbarall, lag(4)


quietly: eststo mod100: newey gdpgrwth gbar100, lag(4)
quietly: eststo mod101: newey gdpgrwth gbar100 gbarall, lag(4)
quietly: eststo mod102: newey gdpgrwth gbar100 gbar400, lag(4)
quietly: eststo mod103: newey gdpgrwth gbar100 gbar400 gbarall, lag(4)
quietly: eststo mod104: newey gdpgrwth gbar100 gbar700, lag(4)
quietly: eststo mod105: newey gdpgrwth gbar100 gbarmid, lag(4)

quietly: eststo mod400: newey gdpgrwth gbar400, lag(4)
quietly: eststo mod401: newey gdpgrwth gbar400 gbarall, lag(4)
quietly: eststo mod402: newey gdpgrwth gbar400 gbar400, lag(4)
quietly: eststo mod403: newey gdpgrwth gbar400 gbar400 gbarall, lag(4)
quietly: eststo mod404: newey gdpgrwth gbar400 gbar700, lag(4)
quietly: eststo mod405: newey gdpgrwth gbar400 gbarmid, lag(4)
quietly: eststo mod406: newey gdpgrwth gbar400 gbar100, lag(4)

quietly: eststo mod700: newey gdpgrwth gbar700, lag(4)
quietly: eststo mod701: newey gdpgrwth gbar700 gbarall, lag(4)
quietly: eststo mod702: newey gdpgrwth gbar700 gbar400, lag(4)
quietly: eststo mod703: newey gdpgrwth gbar700 gbar400 gbarall, lag(4)
quietly: eststo mod704: newey gdpgrwth gbar700 gbar700, lag(4)
quietly: eststo mod705: newey gdpgrwth gbar700 gbarmid, lag(4)
quietly: eststo mod706: newey gdpgrwth gbar700 gbar100, lag(4)

quietly: eststo mod1000: newey gdpgrwth gbar1000, lag(4) 
quietly: eststo mod1001: newey gdpgrwth gbar1000 gbarall, lag(4)
quietly: eststo mod1002: newey gdpgrwth gbar1000 gbar400, lag(4)
quietly: eststo mod1003: newey gdpgrwth gbar1000 gbar400 gbarall, lag(4)
quietly: eststo mod1004: newey gdpgrwth gbar1000 gbar700, lag(4)
quietly: eststo mod1005: newey gdpgrwth gbar1000 gbarmid, lag(4)
quietly: eststo mod1006: newey gdpgrwth gbar1000 gbar100, lag(4)

/*
quietly: eststo modgrwth100: newey gbar100 gdpgrwth, lag(4)
quietly: eststo modgrwth400: newey gbar400 gdpgrwth, lag(4)
quietly: eststo modgrwth700: newey gbar700 gdpgrwth, lag(4)
quietly: eststo modgrwth1000: newey gbar1000 gdpgrwth, lag(4)
quietly: eststo modgrwthall: newey gbarall gdpgrwth, lag(4)
quietly: eststo modgrwthmid: newey gbarmid gdpgrwth, lag(4)


quietly: eststo modgrwth100: newey xgrwth100 gdpgrwth, lag(4)
quietly: eststo modgrwth400: newey xgrwth400 gdpgrwth, lag(4)
quietly: eststo modgrwth700: newey xgrwth700 gdpgrwth, lag(4)
quietly: eststo modgrwth1000: newey xgrwth1000 gdpgrwth, lag(4)
quietly: eststo modgrwthall: newey gbarall gdpgrwth, lag(4)
quietly: eststo modgrwthmid: newey gbarmid gdpgrwth, lag(4)    
*/

    
quietly: eststo modab100onall: newey gbar100 gbarall, lag(4)
quietly: eststo modab100onmid: newey gbar100 gbarmid, lag(4)
quietly: eststo modab400on100: newey gbar400 gbar100, lag(4)
quietly: eststo modab400onall: newey gbar400 gbarall, lag(4)
quietly: eststo modab400on700: newey gbar400 gbar700, lag(4)
quietly: eststo modab700on100: newey gbar700 gbar100, lag(4)
quietly: eststo modab700onall: newey gbar700 gbarall, lag(4)
quietly: eststo modab700on400: newey gbar700 gbar400, lag(4)
quietly: eststo modab1000on100: newey gbar1000 gbar100, lag(4)
quietly: eststo modab1000onall: newey gbar1000 gbarall, lag(4)
quietly: eststo modab1000onmid: newey gbar1000 gbarmid, lag(4)

gen gbar100less700 = gbar100-gbar700

/*
quietly: eststo modx100over700: newey gdpgrwth gbar100less700, lag(4)
quietly: eststo modx100: newey gdpgrwth xgrwth100, lag(4)
quietly: eststo modx400: newey gdpgrwth xgrwth400, lag(4)
quietly: eststo modx700: newey gdpgrwth xgrwth700, lag(4)
quietly: eststo modx1000: newey gdpgrwth xgrwth1000, lag(4)

quietly: eststo mody100over700: newey gdpgrwth gbarall gbar100less700, lag(4)
quietly: eststo mody100: newey gdpgrwth gbarall xgrwth100, lag(4)
quietly: eststo mody400: newey gdpgrwth gbarall xgrwth400, lag(4)
quietly: eststo mody700: newey gdpgrwth gbarall xgrwth700, lag(4)
quietly: eststo mody1000: newey gdpgrwth gbarall xgrwth1000, lag(4)
*/


/* cash regressions */
quietly: eststo modcash100: newey gdpgrwth cbar100, lag(4)
quietly: eststo modcash400: newey gdpgrwth cbar400, lag(4)
quietly: eststo modcash700: newey gdpgrwth cbar700, lag(4)
quietly: eststo modcash1000: newey gdpgrwth cbar1000, lag(4)

quietly: eststo modcashx100: newey gdpgrwth cbar100 cbar400, lag(4)
quietly: eststo modcashx400: newey gdpgrwth cbar400 cbar400, lag(4)
quietly: eststo modcashx700: newey gdpgrwth cbar700 cbar400, lag(4)
quietly: eststo modcashx1000: newey gdpgrwth cbar1000 cbar400, lag(4)

/* Working Capital regressions */
quietly: eststo modwc100: newey gdpgrwth wcbar100, lag(4)
quietly: eststo modwc400: newey gdpgrwth wcbar400, lag(4)
quietly: eststo modwc700: newey gdpgrwth wcbar700, lag(4)
quietly: eststo modwc1000: newey gdpgrwth wcbar1000, lag(4)

quietly: eststo modwcx100: newey gdpgrwth wcbar100 wcbar400, lag(4)
quietly: eststo modwcx400: newey gdpgrwth wcbar400 wcbar400, lag(4)
quietly: eststo modwcx700: newey gdpgrwth wcbar700 wcbar400, lag(4)
quietly: eststo modwcx1000: newey gdpgrwth wcbar1000 wcbar400, lag(4)

/* Current Liabilities regressions */
quietly: eststo modcl100: newey gdpgrwth clbar100, lag(4)
quietly: eststo modcl400: newey gdpgrwth clbar400, lag(4)
quietly: eststo modcl700: newey gdpgrwth clbar700, lag(4)
quietly: eststo modcl1000: newey gdpgrwth clbar1000, lag(4)

quietly: eststo modclx100: newey gdpgrwth clbar100 clbar400, lag(4)
quietly: eststo modclx400: newey gdpgrwth clbar400 clbar400, lag(4)
quietly: eststo modclx700: newey gdpgrwth clbar700 clbar400, lag(4)
quietly: eststo modclx1000: newey gdpgrwth clbar1000 clbar400, lag(4)


/* Inventory regressions */
quietly: eststo modinv100: newey gdpgrwth ibar100, lag(4)
quietly: eststo modinv400: newey gdpgrwth ibar400, lag(4)
quietly: eststo modinv700: newey gdpgrwth ibar700, lag(4)
quietly: eststo modinv1000: newey gdpgrwth ibar1000, lag(4)

quietly: eststo modinvx100: newey gdpgrwth ibar100 ibar400, lag(4)
quietly: eststo modinvx400: newey gdpgrwth ibar400 ibar400, lag(4)
quietly: eststo modinvx700: newey gdpgrwth ibar700 ibar400, lag(4)
quietly: eststo modinvx1000: newey gdpgrwth ibar1000 ibar400, lag(4)


/*** Flip The Regressions ***/
/* cash regressions */
quietly: eststo modzcash100: newey cbar100 gdpgrwth, lag(4)
quietly: eststo modzcash400: newey cbar400 gdpgrwth, lag(4)
quietly: eststo modzcash700: newey cbar700 gdpgrwth, lag(4)
quietly: eststo modzcash1000: newey cbar1000 gdpgrwth, lag(4)

/* Working Capital regressions */
quietly: eststo modzwc100: newey wcbar100 gdpgrwth, lag(4)
quietly: eststo modzwc400: newey wcbar400 gdpgrwth, lag(4)
quietly: eststo modzwc700: newey wcbar700 gdpgrwth, lag(4)
quietly: eststo modzwc1000: newey  wcbar1000 gdpgrwth , lag(4)


/* Current Liabilities regressions */
quietly: eststo modzcl100: newey clbar100 gdpgrwth, lag(4)
quietly: eststo modzcl400: newey clbar400 gdpgrwth, lag(4)
quietly: eststo modzcl700: newey clbar700 gdpgrwth, lag(4)
quietly: eststo modzcl1000: newey clbar1000 gdpgrwth, lag(4)



/* Inventory regressions */
quietly: eststo modzinv100: newey ibar100 gdpgrwth, lag(4)
quietly: eststo modzinv400: newey ibar400 gdpgrwth, lag(4)
quietly: eststo modzinv700: newey ibar700 gdpgrwth, lag(4)
quietly: eststo modzinv1000: newey ibar1000 gdpgrwth, lag(4)





esttab modall modmid modallmid,se compress
esttab mod100 mod101 mod102  mod104 mod105 mod103, se compress
esttab mod400 mod401 mod402 mod406 mod404 mod405 mod403, se compress
esttab mod700 mod701 mod702 mod706 mod704 mod705 mod703, se compress
esttab mod1000 mod1001 mod1002 mod1006 mod1004 mod1005 mod1003, se compress
/*esttab modgrwth*, se compress
esttab modab*,se compress
esttab modx*, se compress
esttab mody*, se compress
*/

esttab modcash??? modcash1000 ,se compress
esttab modcashx*,se compress

esttab modwc??? modwc1000 ,se compress
esttab modwcx*,se compress

esttab modcl??? modcl1000,se compress
esttab modclx*,se compress

esttab modinv??? modinv1000,se compress
esttab modinvx*,se compress



esttab modzcash* using `output'/cash.csv ,se compress replace
esttab modzwc* using `output'/workingcap.csv,se compress replace
esttab modzcl* using `output'/currentliab.csv,se compress replace
esttab modzinv* using `output'/inventory.csv,se compress replace


sum gbar*

clear
exit
