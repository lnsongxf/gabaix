clear all
set more off



local maindir "/cm/scratch3/m1jms13/gabaix/"
local output "/cm/research/m1jms13/nitish/gabaix/output"

use "`maindir'regressionvars.dta"

keep if year > 1974


quietly: eststo modall: qreg gdpgrwth gbarall, vce(robust)
quietly: eststo modmid: qreg gdpgrwth gbarmid, vce(robust) 
quietly: eststo modallmid: qreg gdpgrwth gbarmid gbarall, vce(robust)


quietly: eststo mod100: qreg gdpgrwth gbar100, vce(robust)
quietly: eststo mod101: qreg gdpgrwth gbar100 gbarall, vce(robust)
quietly: eststo mod102: qreg gdpgrwth gbar100 gbar400, vce(robust)
quietly: eststo mod103: qreg gdpgrwth gbar100 gbar400 gbarall, vce(robust)
quietly: eststo mod104: qreg gdpgrwth gbar100 gbar700, vce(robust)
quietly: eststo mod105: qreg gdpgrwth gbar100 gbarmid, vce(robust)

quietly: eststo mod400: qreg gdpgrwth gbar400, vce(robust)
quietly: eststo mod401: qreg gdpgrwth gbar400 gbarall, vce(robust)
quietly: eststo mod402: qreg gdpgrwth gbar400 gbar400, vce(robust)
quietly: eststo mod403: qreg gdpgrwth gbar400 gbar400 gbarall, vce(robust)
quietly: eststo mod404: qreg gdpgrwth gbar400 gbar700, vce(robust)
quietly: eststo mod405: qreg gdpgrwth gbar400 gbarmid, vce(robust)


quietly: eststo mod700: qreg gdpgrwth gbar700, vce(robust)
quietly: eststo mod701: qreg gdpgrwth gbar700 gbarall, vce(robust)
quietly: eststo mod702: qreg gdpgrwth gbar700 gbar400, vce(robust)
quietly: eststo mod703: qreg gdpgrwth gbar700 gbar400 gbarall, vce(robust)
quietly: eststo mod704: qreg gdpgrwth gbar700 gbar700, vce(robust)
quietly: eststo mod705: qreg gdpgrwth gbar700 gbarmid, vce(robust)


quietly: eststo mod1000: qreg gdpgrwth gbar1000,  vce(robust)
quietly: eststo mod1001: qreg gdpgrwth gbar1000 gbarall, vce(robust)
quietly: eststo mod1002: qreg gdpgrwth gbar1000 gbar400, vce(robust)
quietly: eststo mod1003: qreg gdpgrwth gbar1000 gbar400 gbarall, vce(robust)
quietly: eststo mod1004: qreg gdpgrwth gbar1000 gbar700, vce(robust)
quietly: eststo mod1005: qreg gdpgrwth gbar1000 gbarmid, vce(robust)

quietly: eststo modgrwth100: qreg gbar100 gdpgrwth, vce(robust)
quietly: eststo modgrwth400: qreg gbar400 gdpgrwth, vce(robust)
quietly: eststo modgrwth700: qreg gbar700 gdpgrwth, vce(robust)
quietly: eststo modgrwth1000: qreg gbar1000 gdpgrwth, vce(robust)
quietly: eststo modgrwthall: qreg gbarall gdpgrwth, vce(robust)
quietly: eststo modgrwthmid: qreg gbarmid gdpgrwth, vce(robust)

quietly: eststo modab100onall: qreg gbar100 gbarall, vce(robust)
quietly: eststo modab100onmid: qreg gbar100 gbarmid, vce(robust)
quietly: eststo modab400on100: qreg gbar400 gbar100, vce(robust)
quietly: eststo modab400onall: qreg gbar400 gbarall, vce(robust)
quietly: eststo modab400on700: qreg gbar400 gbar700, vce(robust)
quietly: eststo modab700on100: qreg gbar700 gbar100, vce(robust)
quietly: eststo modab700onall: qreg gbar700 gbarall, vce(robust)
quietly: eststo modab700on400: qreg gbar700 gbar400, vce(robust)
quietly: eststo modab1000on100: qreg gbar1000 gbar100, vce(robust)
quietly: eststo modab1000onall: qreg gbar1000 gbarall, vce(robust)
quietly: eststo modab1000onmid: qreg gbar1000 gbarmid, vce(robust)




esttab modall modmid modallmid,se compress
esttab mod100 mod101 mod102 mod104 mod105 mod103, se compress
esttab mod400 mod401 mod402 mod404 mod405 mod403, se compress
esttab mod700 mod701 mod702 mod704 mod705 mod703, se compress
esttab mod1000 mod1001 mod1002 mod1004 mod1005 mod1003, se compress
esttab modgrwth*, se compress
esttab modab*,se compress 

corr gbar100 gbar400 gbar700 gbar1000 gbarall gbarmid
clear
exit
