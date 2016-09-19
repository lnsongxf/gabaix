/**************************************************************************************************
Author: Joseph Saia
Date: Sep 19 2016
Notes: Creates a dataset with the needed variables from the Compustat Fundementals-Quarterly dataset
Path of WRDS Server: /wrds/comp/sasdata/d_na/fundq.sas7bdat
***************************************************************************************************/

*libname compu "/wrds/comp/sasdata/naa/";
libname home "/home/columbia/js4956/";

data annual_var;
  set compm.company(keep = gvkey sic);
run;

data variables;
  set comp.fundq(keep = gvkey datadate fyear datacqtr salesq);
run;

proc sql;
  alter table variables as A
    add B.sic from annual_var as B
    where A.gvkey=B.gvkey;
quit;
