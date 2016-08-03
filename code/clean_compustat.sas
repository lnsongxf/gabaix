/*****************************************************************
Author: m1jms13
date: 9/2015
Notes: Creates dataset to be used to calculate granular productivity residuals 
******************************************************************/

libname rawsas "/cm/scratch3/m1jms13/gabaix/";
    
%include '/cm/work1/bin/sgetfame.macro';


/* Rename variables, remove missing observations, remove bad SIC codes
and generate needed variables from compustat database;
 Varaibles: CONSOL INDFMT DATAFMT POPSRC DATAFQTR DATACQTR CURCDQ COSTAT
     CONM TIC CUSIP FIC ACTQ ATQ CEQQ CHEQ CHQ INVFGQ INVOQ INVRMQ INVTQ
     INVWIPQ LCTQ SALEQ WCAPQ
    chq = cash;
    cheq = casheqivs;
    atq = assets;
    lctq = currliabs;
    actq = currassets;
    invtq = totalinventories;
    wcapq = working capital (balance sheet);
*/
data rawsas.cleancompustatdata(keep = conm tic gvkey date sale year qtr industry chq cheq
    atq lctq actq invtq invfgq invwipq invrmq invoq wcapq datadate);
    set rawsas.compustatdata;
    year = input(substr(datacqtr,1,4),comma9.);
    qtr = input(substr(datacqtr,6,1),comma9.);
    date = yyq(year,qtr);
    if not missing(date);
    format date yyqc.;    
    if 1962<year(date)<2015;
    if 5999<sic<7000 or 4900<sic<4941 then delete;
    if sic = 2911 or sic = 5172 or sic = 1311 or sic = 1389 or sic = 9995 or sic=9997 then delete; 
    if saleq = . then delete;
    rename saleq = sale;
    if fic NE "USA" OR loc NE "USA" then delete;
    industry = floor(sic/100);  
run;


proc export data = rawsas.cleancompustatdata
    outfile = "cleancompustat.csv"
    DBMS = CSV
    replace;
run;


/* Stat transfer dataset to stata dataset */
x rm -f /cm/scratch3/m1jms13/gabaix/cleancompustatdata.dta;
x st /cm/scratch3/m1jms13/gabaix/cleancompustatdata.sas7bdat stata /cm/scratch3/m1jms13/gabaix/cleancompustatdata.dta;


/******************************************************************
    ENDSAS
    **************************************************************/
endsas;


proc sort data= cleancompustatdata;
	by gvkey date;
run;

* Clean out bad or duplicate observations;
* Never more than two observations per period;
* Arises because of changes to fiscal calendar;
data cleancompustatdata(drop = sale2) ;
	set cleancompustatdata;
	by gvkey date;
	if sale =. then delete;
	if sale<=0 then sale = 0.00001;
	if First.date then sale2=sale;
	if (1-first.date) then sale = (sale2+sale)/2;
	if first.date AND (1-last.date) then delete;
run;


/*****************************************************************
	Expand dataset to include missing values
******************************************************************/	
proc sort data=cleancompustatdata presorted;
	by gvkey date;
run;

* Create new observations for missing dates;
* Calculates difference in dates between observations, if longer than 1 qtr;
* Then add one missing observation, subtract 90 days from date and check again;
data missingdata(drop = yearlag qtrlag datelag date_diff);
	set cleancompustatdata;
	by gvkey;
	yearlag=lag(year);
	qtrlag=lag(qtr);
	datelag=lag(date);
	date_diff = round(date-datelag,90);
	if first.gvkey then date_diff=.;
	do while(date_diff GT 90 and date_diff NE .);
		if qtr EQ 1 then
			do;
				qtr=4;
				year = year-1;
				date=yyq(year,qtr);
			end;
		else
			do;
				qtr=qtr-1;
				year=year;
				date=yyq(year,qtr);
			end;
		sale = .;
		date_diff = date_diff-90;
		output missingdata;
	end;
run;

*Add on missing observations to orginal dataset;
proc append base=cleancompustatdata data=missingdata;
run;


/************************************************************
	Generate sales variable to calculate rankings;
	salesranking=sale if company is in next period
	salesranking=0 otherwise
**************************************************************/
 /* data sorted newest to oldest for lag function */
 /* first. is really last. in chronological order */

proc sort data= cleancompustatdata;
	by gvkey descending date;
run;

data cleancompustatdata;
	set cleancompustatdata;
	by gvkey;
	saleslag = lag(sale);
	if first.gvkey EQ 1 then innextperiod = 0;
	else if saleslag NE . then innextperiod = 1;
	else innextperiod = 0;
	rankingsales = sale*innextperiod;
run;


* Rank in time t is based on sales in time t-1;
* Create lagged ranking sales variable to compuste ranks;
proc sort data= cleancompustatdata;
	by gvkey date;
run;

data cleancompustatdata;
	set cleancompustatdata;
	by gvkey;
	if first.gvkey then L_rankingsales=0;
	else L_rankingsales = lag(rankingsales);
run;



/*****************************************************************
	Generate sales rankings in each period;
******************************************************************/	
proc sort data = cleancompustatdata;
	by date rankingsales;
run;

* Generate within period ranks;
proc rank data=cleancompustatdata out= rankedcompustat ties=low descending;
	by date;
	var L_rankingsales;
	ranks salesrank;
run;

*Generate dummy variables for topX firms;
data rankedcompustat;
	set rankedcompustat;
	if salesrank EQ . then salesrank=9999;
        top1000 = 0;
        top100 = 0;
        top50=0;
        top5 =0;
        if salesrank LE 1000 then top1000=1;
	if salesrank LE 100 then top100=1;
	if salesrank LE 50 then top50=1;
	if salesrank LE 5 then top5=1;
run;


/*****************************************************************
    Merge On PCE Defalator and deflate sales data
******************************************************************/
%sgetfame(q, *, *, us, pceds, ph.ce.q, gdp_xcw_09.q, 1);


data pceds;
    set pceds;
    date = yyq(year(date),qtr(date));
run;

proc sql;
    create table regdata as
        select A.*, B.ph_ce_q as pce, B.gdp_xcw_09_q as gdp
        from rankedcompustat as A
        left join pceds as B
        on A.date = B.date
        order by gvkey, date;
quit;


data rawsas.regdata;
    set regdata;
    by gvkey date;
    sale = sale/pce;
    logsale = log(sale);
run;


/* Only a handfull of small firm  duplicates */
proc sort data = rawsas.regdata
    nodupkey
    dupout = dupes;
    by gvkey date;
run;


/* Calculate growth rates, and set observations that overlap gvkeys to missing */
data regdata;
    set rawsas.regdata;
    by gvkey date;
    d_logsale = logsale - lag(logsale); 
    d4_logsale = logsale - lag4(logsale); 
    if first.gvkey then d_logsale = .; 
    if lag4(gvkey) NE gvkey then d4_logsale = .;
run;

/* Calculate average growth rates across date and industry and size groups*/
proc sql;
    create table averagegrowth_1000 as
        select distinct date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q, 1000 as size
        from regdata where top1000 EQ 1
        group by date
        order by date;

     create table averagegrowth_100 as
        select date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q, 100 as size
        from regdata
        where top100 EQ 1
        group by date
        order by date;
     
     create table averagegrowth_50 as
        select distinct date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q, 50 as size
        from regdata
        where top50 EQ 1
        group by date
        order by date;

     create table averagegrowth_mid as
        select date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q, 1000.100 as size
        from regdata
        where top1000 EQ 1 AND top100 EQ 0
        group by date
        order by date; 

     create table averagegrowth as
         select * from averagegrowth_1000
         union select * from averagegrowth_100
         union select * from averagegrowth_50
         union select * from averagegrowth_mid
         order by date, size;

     create table averagegrowth_1000_ind as
        select distinct date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q,
        1000 as size, industry
        from regdata where top1000 EQ 1
        group by date, industry
        order by date, industry;

     create table averagegrowth_100_ind as
        select distinct date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q,
         industry, 100 as size
        from regdata
        where top100 EQ 1
        group by date, industry
        order by date, industry;
     
     create table averagegrowth_50_ind as
        select distinct date, mean(d_logsale) as gbar, mean(d4_logsale) as gbar4q,
         industry, 50 as size
        from regdata
        where top50 EQ 1
        group by date, industry
        order by date, industry;

     create table averagegrowth_ind as
         select *
         from averagegrowth_1000_ind
         union select * from averagegrowth_100_ind
         union select * from averagegrowth_50_ind
         order by date, size, industry;
quit;

/* Save average growth rates */
data rawsas.averagegrowth;
    set averagegrowth;
run;



/* Merge on average growth rates to regdata */
proc sql;
    create table grwth_and_averages as
        select A.*, B.gbar as gbar_q1000, C.gbar as gbar_q100, D.gbar as gbar_mid
        from regdata as A
        left join(select * from averagegrowth where size = 1000) as B
        on A.date = B.date
        left join(select * from averagegrowth where size = 100) as C
        on A.date = C.date
        left join(select * from averagegrowth where size = 1000.100) as D
        on A.date = D.date
        order by gvkey, date;
quit;

/* Create firm residuals
    windsorize if firm growth is too large*/
data gammas;
    set grwth_and_averages;
    gamma_q1000 = sale/gdp * (d_logsale - gbar_q1000);
    if abs(d_logsale - gbar_q1000) GT .20 then
        gamma_q1000 = sale/gdp * .20 * sign(d_logsale - gbar_q1000);
    
    gamma_q100 = sale/gdp * (d_logsale - gbar_q100);
    if abs(d_logsale - gbar_q100) GT .20 then
        gamma_q100 = sale/gdp * .20 * sign(d_logsale - gbar_q100);

run;

/* Calculate Granular Residual */
proc sql;
    create table granresid1 as
        select distinct sum(gamma_q1000) as gamma_q1000_k100,
        sum(gamma_q100) as gamma_q100_k100, date
        from (select * from gammas where top100 = 1)
        group by date
        order by date;

    create table granresid2 as
        select distinct sum(gamma_q1000) as gamma_q1000_kmid,
        sum(gamma_q100) as gamma_q100_kmid, date
        from (select * from gammas where top100 = 0 AND top1000 = 1)
        group by date
        order by date;

    create table granresid as
        select A.*, B.gamma_q1000_kmid, B.gamma_q100_kmid
        from granresid1 as A
        left join
        granresid2 as B
        on A.date= B.date;
quit;
        
data rawsas.granresid;
    set granresid;
run;

/* Create database with all regression variables */
proc sql;
    create table regressionvars as
        select distinct A.*, B.gbar as gbar_q100, C.gbar as gbar_q1000,
        E.gbar as gbar_qmid, D.gdp_xcw_09_q as gdp from
        granresid as A
        left join averagegrowth_100 as B
        on A.date = B.date
        left join averagegrowth_1000 as C
        on A.date = C.date
        left join pceds as D
        on A.date = D.date
        left join averagegrowth_mid as E
        on A.date = E.date
        order by date;
run;
        
data rawsas.regressionvars;
    set regressionvars;
run;

/* Stat transfer dataset to stata dataset */
x rm -f /cm/scratch3/m1jms13/gabaix/regressionvars.dta;
x st /cm/scratch3/m1jms13/gabaix/regressionvars.sas7bdat stata /cm/scratch3/m1jms13/gabaix/regressionvars.dta;
