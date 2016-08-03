#!/bin/csh

cd /cm/research/m1jms13/nitish/gabaix/code/
sas clean_compustat.sas
stata-mp makedataset.do
stata-mp regressions.do


