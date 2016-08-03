clear all
set more off

/*
* Makes stata data set for regressions. This is the second version
*and should be used over makeregdata.do
*/


local maindir "/cm/scratch3/m1jms13/gabaix/"
local output "/cm/research/m1jms13/nitish/gabaix/output"
use "`maindir'cleancompustatdata.dta"



destring(gvkey), replace
sort gvkey year qtr
rename date old_date
gen date = yq(year,qtr)
format date %tq

merge m:1 date using `maindir'macrovars.dta

tsset gvkey date
compress

replace sale = . if sale < 0
gen lagsale = L.sale

bysort date: egen salerank = rank(lagsale), field


sort gvkey date
tsset gvkey date

gen int size = 1000
replace size = 100 if salerank<=100
replace size = 400 if salerank <= 400 & salerank > 100
replace size = 700 if salerank <= 700 & salerank > 400 


gen logsale = log(sale/pce_index)
gen logcash = log(cheq/sale)
gen loginventory = log(invtq/sale)
gen logworkcap = log(wcapq/sale)
gen logctliab  = log(lctq/sale)

gen salegrwth = D.logsale
gen cashgrwth = D.logcash
gen invgrwth  = D.loginventory
gen wcgrwth   = D.logworkcap
gen ctliabgrwth = D.logctliab


local vars salegrwth cashgrwth invgrwth wcgrwth ctliabgrwth
foreach var in `vars'{
    bysort date: egen p99`var' = pctile(`var'), p(99)
    replace `var' = p99`var' if `var' > p99`var'
    drop p99`var'
}

keep if salerank <= 1000
save "`maindir'cleanercompustatdata.dta", replace

sort date size
by date size: egen gbar = mean(salegrwth)
by date size: egen cbar = mean(cashgrwth)
by date size: egen ibar = mean(invgrwth)
by date size: egen wcbar = mean(wcgrwth)
by date size: egen clbar = mean(ctliabgrwth)




egen unique = tag(date size) 

keep if unique == 1 & !missing(cbar) & !missing(ibar) & !missing(ibar) & !missing(wcbar) & !missing(clbar)

tsset size date

keep date size *bar
reshape wide gbar cbar ibar wcbar clbar, i(date) j(size)

gen gbarall = .1*gbar100+.3*gbar400+.3*gbar700+.3*gbar100
gen gbarmid = .5*gbar400 + .5*gbar700

tsset date
/*
tsfilter bk gbar_cycall=gbarall, minperiod(4) 


gen xgrwth100 = gbar100-gbarall
gen xgrwth400 = gbar400-gbarall
gen xgrwth700 = gbar700-gbarall
gen xgrwth1000 = gbar1000-gbarall

gen xgrwth_cyc100 = gbar100-gbar_cycall
gen xgrwth_cyc400 = gbar400-gbar_cycall
gen xgrwth_cyc700 = gbar700-gbar_cycall
gen xgrwth_cyc1000 = gbar1000-gbar_cycall
*/

    
merge 1:1 date using `maindir'macrovars.dta

tsset date
gen loggdp = log(realgdp)
gen gdpgrwth = D.loggdp

drop if _merge == 2
drop _merge

compress

d
save "`maindir'regressionvars.dta", replace






