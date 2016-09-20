/**************************************************************************************************
Author: Joseph Saia
Date: Sep 19 2016
Notes: Creates a dataset with the needed variables from the Compustat Fundementals-Quarterly dataset
This script should be run on the WRDS server and will save an output dataset with a panel data 
structure with gvkey and date as the keys. Date is the corresponding calendar date of the sales data
***************************************************************************************************/
options linesize=100 pagesize = 50 ;
libname home "/home/columbia/js4956/";


/* Pull in needed variables from various tables */
proc sql;
  create table variables as 
    select A.gvkey, A.datadate, A.datacqtr, B.sic as sic_char, A.saleq as sale
    from comp.fundq as A
    left join comp.company as B
    on A.gvkey=B.gvkey
    where A.fic EQ "USA" AND not missing(saleq)
    order by A.gvkey, A.datadate;
quit;

/* Clean the data and filter out industries we do not want */
data variables(drop = datacqtr sic_char);
  set variables;
  format datadate date9.;
  format date yyQ6.;
  sic = input(sic_char,best4.);
  date = input(datacqtr,yyq6.);
  if 5999<sic<7000 OR 4900<sic<4941 OR sic=2911 OR sic=5172 OR sic=1311 OR sic=1389 OR sic >=9000 then delete;
  industry = floor(sic/100);
run;

/* Delete data for any firm that has any duplicate observations in a quarter 
   This is sometimes due to fiscal year changes but sometimes there are up to 4 observations in a quarter 
   There's about 500 observations like this */
proc sort data=variables;
  by gvkey date;
run;

data variables;
  set variables;
  by gvkey date;
  dupe=0;
  if not first.date or not last.date then dupe=1;
run;

data variables(drop=dupe);
  set variables;
  where dupe=0;
run;

/* Expand each panel to have missing values if no sales data */
data dates;
  format date yyQ6.;
  do year = 1950 to 2016;
    do qtr = 1 to 4;
      date = yyq(year,qtr);
      output;
    end;
  end;
run;

proc sql;
  create view gvkeys as
    select distinct gvkey, min(date) as start, max(date) as end
    from variables
    group by gvkey;

  create view panels as 
    select A.gvkey, B.date
    from gvkeys as A, dates as B
    where A.start <= B.date AND A.end >= B.date;

  create table panel as
    select A.gvkey, A.date, B.sale, B.sic, B.industry
    from panels as A
    left join variables as B
    on A.gvkey=B.gvkey AND A.date = B.date
    order by gvkey, date;
quit;

data home.variables;
  set panel;
run;





