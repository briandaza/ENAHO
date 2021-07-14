********************************************************************************
*
*   Old Graphics:
*
********************************************************************************

global enahopost "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO\Bases de datos"

use "$enahopost\base_cs_enaho.dta", clear

* Counting households and observations:

gen iscosklv=.
replace iscosklv=4 if grangrup==2
replace iscosklv=3 if grangrup==3
replace iscosklv=2 if inlist(grangrup,4,5,6,7,8)
replace iscosklv=1 if grangrup==9

lab def iscosklv 1 "1st Level" 2 "2nd Level" 3 "3rd level" 4 "4th level" 
lab val iscosklv iscosklv

label define grangrupd 0 "Armed Forces" 1 "Legislators" 2 "Professionals" 3 "Technicians" 4 "Clerks" ///
5 "Service Workers" 6 "Skilled Agricultural-Fishing" 7 "Craft workers" 8 "Machine operators" 9 "Elementary occupations"
label values grangrup grangrupd

 tab anio

cd "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO\2004-2017"

* Descriptive statistics:
* -----------------------
svyset conglome [pweight = facpob07], strata(estrato) /* || vivienda */ 
* Just observations:
*-------------------

* Years of education:
tab sch anio

foreach year in 2004 2017 {
svy: mean sch  if anio==`year'
 matrix list e(_N)
 matrix sch`year'_N= e(_N)
estat sd
matrix list r(sd)
matrix sch`year'_sd=  r(sd)
matrix list r(mean)
matrix sch`year'_mean=  r(mean)
estat cv
matrix list r(cv)
matrix sch`year'_cv=  r(cv)
matrix list r(se)
matrix sch`year'_se=  r(se)
_pctile inc_pri if  anio==`year' [pweight=facpob07], p(25)
 di `r(r1)'
 matrix sch`year'_p25 = (`r(r1)')
_pctile inc_pri if anio==`year' [pweight=facpob07], p(50)
 di `r(r1)'
  matrix sch`year'_p50 = (`r(r1)')
_pctile inc_pri if anio==`year' [pweight=facpob07], p(75)
 di `r(r1)'
  matrix sch`year'_p75 = (`r(r1)')
matrix sch`year'_estat= sch`year'_mean, sch`year'_se, sch`year'_sd, sch`year'_cv,  sch`year'_p25,  sch`year'_p50, sch`year'_p75, sch`year'_N
matrix list sch`year'_estat
}

foreach year in 2004 2017 {
matrix sch`year'_estat= sch`year'_mean, sch`year'_se, sch`year'_sd, sch`year'_cv,  sch`year'_N
matrix list sch`year'_estat
}

matrix list sch2004_estat
matrix list sch2017_estat

label define sexo 1 "Hombre" 2 "Mujer"
label values p207 sexo
graph hbox sch if anio==2004 | anio==2007 [pweight = facpob07], over(anio) over(p207)  ///
 graphregion(color(white))  subtitle("Years 2004 and 2007", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) title("Distribution of Years of Schooling") ytitle("Years")   name(Sch417, replace)

graph export "Sch417.png", as(png) replace  
graph save Sch417 Sch417, replace

graph close

* Educational Level:
tab educ anio, column 
* Urban-Rural:
tab urban anio,  column 
* Geographic zone:
tab zone anio, column  
* Sector:
tab sector anio, column 
* Grangroup:
tab grangrup anio, column  
* ISCO Skill-level:
tab iscosklv anio, column 

* Population estimation:
* ----------------------

svyset conglome [pweight = facpob07], strata(estrato) /* || vivienda */ 

* Years of education:
svy: tab sch anio, count format(%15.0fc)
* Educational Level:
svy: tab educ anio, count format(%15.0fc) column percent 
* Urban-Rural:
svy: tab urban anio, count format(%15.0fc) column percent
* Geographic zone:
svy: tab zone anio, count format(%15.0fc) column percent  
* Sector:
svy: tab sector anio, count format(%15.0fc) column percent  
* Grangroup:
svy: tab grangrup anio, count format(%15.0fc) column percent  
* ISCO Skill-level:
svy: tab iscosklv anio, count format(%15.0fc) column percent  

* For "incr_pri" according to categories of each variable:
* ==============================================================================
svyset conglome [pweight = facpob07], strata(estrato) /* || vivienda */ 
* Sector:
* =======
tab sector anio, column 

* For 2007:
* ---------
foreach sector in 1 2 3 4 5 6 7 8 9 {
* 2007
svy: mean inc_pri  if sector==`sector' & anio==2007
 matrix list e(_N)
 matrix inc_priS`sector'2007_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priS`sector'2007_sd=  r(sd)
matrix list r(mean)
matrix inc_priS`sector'2007_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priS`sector'2007_cv=  r(cv)
matrix list r(se)
matrix inc_priS`sector'2007_se=  r(se)
_pctile inc_pri if sector==`sector' & anio==2007 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priS`sector'2007_p25 = (`r(r1)')
_pctile inc_pri if sector==`sector' & anio==2007 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priS`sector'2007_p50 = (`r(r1)')
_pctile inc_pri if sector==`sector' & anio==2007 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priS`sector'2007_p75 = (`r(r1)')
matrix inc_priS`sector'2007_estat=`sector', inc_priS`sector'2007_mean, inc_priS`sector'2007_se, inc_priS`sector'2007_sd, inc_priS`sector'2007_cv,  inc_priS`sector'2007_p25,  inc_priS`sector'2007_p50, inc_priS`sector'2007_p75, inc_priS`sector'2007_N
matrix list inc_priS`sector'2007_estat
}

matrix  Inc_S_2007=inc_priS12007_estat\inc_priS22007_estat\inc_priS32007_estat\inc_priS42007_estat\inc_priS52007_estat\inc_priS62007_estat\inc_priS72007_estat\inc_priS82007_estat\inc_priS92007_estat
matrix list Inc_S_2007

* For 2017:
* ---------
foreach sector in 1 2 3 4 5 6 7 8 9 {
* 2017
svy: mean inc_pri  if sector==`sector' & anio==2017
 matrix list e(_N)
 matrix inc_priS`sector'2017_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priS`sector'2017_sd=  r(sd)
matrix list r(mean)
matrix inc_priS`sector'2017_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priS`sector'2017_cv=  r(cv)
matrix list r(se)
matrix inc_priS`sector'2017_se=  r(se)
_pctile inc_pri if sector==`sector' & anio==2017 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priS`sector'2017_p25 = (`r(r1)')
_pctile inc_pri if sector==`sector' & anio==2017 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priS`sector'2017_p50 = (`r(r1)')
_pctile inc_pri if sector==`sector' & anio==2017 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priS`sector'2017_p75 = (`r(r1)')
matrix inc_priS`sector'2017_estat=`sector', inc_priS`sector'2017_mean, inc_priS`sector'2017_se, inc_priS`sector'2017_sd, inc_priS`sector'2017_cv,  inc_priS`sector'2017_p25,  inc_priS`sector'2017_p50, inc_priS`sector'2017_p75, inc_priS`sector'2017_N
matrix list inc_priS`sector'2017_estat
}

matrix  Inc_S_2017=inc_priS12017_estat\inc_priS22017_estat\inc_priS32017_estat\inc_priS42017_estat\inc_priS52017_estat\inc_priS62017_estat\inc_priS72017_estat\inc_priS82017_estat\inc_priS92017_estat
matrix list Inc_S_2017

* For the pooled data:
* -----------------------
 
foreach sector in 1 2 3 4 5 6 7 8 9 {
* Pooled
svy: mean inc_pri  if sector==`sector' 
 matrix list e(_N)
 matrix inc_priS`sector'Pooled_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priS`sector'Pooled_sd=  r(sd)
matrix list r(mean)
matrix inc_priS`sector'Pooled_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priS`sector'Pooled_cv=  r(cv)
matrix list r(se)
matrix inc_priS`sector'Pooled_se=  r(se)
_pctile inc_pri if sector==`sector'  [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priS`sector'Pooled_p25 = (`r(r1)')
_pctile inc_pri if sector==`sector'  [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priS`sector'Pooled_p50 = (`r(r1)')
_pctile inc_pri if sector==`sector'  [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priS`sector'Pooled_p75 = (`r(r1)')
matrix inc_priS`sector'Pooled_estat=`sector', inc_priS`sector'Pooled_mean, inc_priS`sector'Pooled_se, inc_priS`sector'Pooled_sd, inc_priS`sector'Pooled_cv,  inc_priS`sector'Pooled_p25,  inc_priS`sector'Pooled_p50, inc_priS`sector'Pooled_p75, inc_priS`sector'Pooled_N
matrix list inc_priS`sector'Pooled_estat
}

matrix  Inc_S_Pooled=inc_priS1Pooled_estat\inc_priS2Pooled_estat\inc_priS3Pooled_estat\inc_priS4Pooled_estat\inc_priS5Pooled_estat\inc_priS6Pooled_estat\inc_priS7Pooled_estat\inc_priS8Pooled_estat\inc_priS9Pooled_estat
matrix list Inc_S_Pooled

* Grangroup:
* ===========
tab grangrup anio, column  

* For 2004:
* ---------
foreach grangrup in 0 1 2 3 4 5 6 7 8 9 {
* 2004
svy: mean inc_pri  if grangrup==`grangrup' & anio==2004
 matrix list e(_N)
 matrix inc_priI`grangrup'2004_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priI`grangrup'2004_sd=  r(sd)
matrix list r(mean)
matrix inc_priI`grangrup'2004_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priI`grangrup'2004_cv=  r(cv)
matrix list r(se)
matrix inc_priI`grangrup'2004_se=  r(se)
_pctile inc_pri if grangrup==`grangrup' & anio==2004 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priI`grangrup'2004_p25 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & anio==2004 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priI`grangrup'2004_p50 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & anio==2004 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priI`grangrup'2004_p75 = (`r(r1)')
matrix inc_priI`grangrup'2004_estat=`grangrup', inc_priI`grangrup'2004_mean, inc_priI`grangrup'2004_se, inc_priI`grangrup'2004_sd, inc_priI`grangrup'2004_cv,  inc_priI`grangrup'2004_p25,  inc_priI`grangrup'2004_p50, inc_priI`grangrup'2004_p75, inc_priI`grangrup'2004_N
matrix list inc_priI`grangrup'2004_estat
}

matrix  Inc_I_2004=inc_priI02004_estat\inc_priI12004_estat\inc_priI22004_estat\inc_priI32004_estat\inc_priI42004_estat\inc_priI52004_estat\inc_priI62004_estat\inc_priI72004_estat\inc_priI82004_estat\inc_priI92004_estat
matrix list Inc_I_2004

* For 2017:
* ---------
foreach grangrup in 0 1 2 3 4 5 6 7 8 9 {
* 2017
svy: mean inc_pri  if grangrup==`grangrup' & anio==2017
 matrix list e(_N)
 matrix inc_priI`grangrup'2017_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priI`grangrup'2017_sd=  r(sd)
matrix list r(mean)
matrix inc_priI`grangrup'2017_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priI`grangrup'2017_cv=  r(cv)
matrix list r(se)
matrix inc_priI`grangrup'2017_se=  r(se)
_pctile inc_pri if grangrup==`grangrup' & anio==2017 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priI`grangrup'2017_p25 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & anio==2017 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priI`grangrup'2017_p50 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & anio==2017 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priI`grangrup'2017_p75 = (`r(r1)')
matrix inc_priI`grangrup'2017_estat=`grangrup', inc_priI`grangrup'2017_mean, inc_priI`grangrup'2017_se, inc_priI`grangrup'2017_sd, inc_priI`grangrup'2017_cv,  inc_priI`grangrup'2017_p25,  inc_priI`grangrup'2017_p50, inc_priI`grangrup'2017_p75, inc_priI`grangrup'2017_N
matrix list inc_priI`grangrup'2017_estat
}

matrix  Inc_I_2017=inc_priI02017_estat\inc_priI12017_estat\inc_priI22017_estat\inc_priI32017_estat\inc_priI42017_estat\inc_priI52017_estat\inc_priI62017_estat\inc_priI72017_estat\inc_priI82017_estat\inc_priI92017_estat
matrix list Inc_I_2017

* For the pooled data:
* -----------------------
 
foreach grangrup in 0 1 2 3 4 5 6 7 8 9 {
* Pooled
svy: mean inc_pri  if grangrup==`grangrup' 
 matrix list e(_N)
 matrix inc_priI`grangrup'Pooled_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priI`grangrup'Pooled_sd=  r(sd)
matrix list r(mean)
matrix inc_priI`grangrup'Pooled_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priI`grangrup'Pooled_cv=  r(cv)
matrix list r(se)
matrix inc_priI`grangrup'Pooled_se=  r(se)
_pctile inc_pri if grangrup==`grangrup'  [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priI`grangrup'Pooled_p25 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup'  [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priI`grangrup'Pooled_p50 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup'  [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priI`grangrup'Pooled_p75 = (`r(r1)')
matrix inc_priI`grangrup'Pooled_estat=`grangrup', inc_priI`grangrup'Pooled_mean, inc_priI`grangrup'Pooled_se, inc_priI`grangrup'Pooled_sd, inc_priI`grangrup'Pooled_cv,  inc_priI`grangrup'Pooled_p25,  inc_priI`grangrup'Pooled_p50, inc_priI`grangrup'Pooled_p75, inc_priI`grangrup'Pooled_N
matrix list inc_priI`grangrup'Pooled_estat
}

matrix  Inc_I_Pooled=inc_priI0Pooled_estat\inc_priI1Pooled_estat\inc_priI2Pooled_estat\inc_priI3Pooled_estat\inc_priI4Pooled_estat\inc_priI5Pooled_estat\inc_priI6Pooled_estat\inc_priI7Pooled_estat\inc_priI8Pooled_estat\inc_priI9Pooled_estat
matrix list Inc_I_Pooled


* ISCO Skill-level:
* ==================
tab iscosklv anio, column
tab iscosklv, nolabel

* For 2004:
* ---------
foreach iscosklv in 1 2 3 4 {
* 2004
svy: mean inc_pri  if iscosklv==`iscosklv' & anio==2004
 matrix list e(_N)
 matrix inc_priSL`iscosklv'2004_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priSL`iscosklv'2004_sd=  r(sd)
matrix list r(mean)
matrix inc_priSL`iscosklv'2004_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priSL`iscosklv'2004_cv=  r(cv)
matrix list r(se)
matrix inc_priSL`iscosklv'2004_se=  r(se)
_pctile inc_pri if iscosklv==`iscosklv' & anio==2004 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priSL`iscosklv'2004_p25 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & anio==2004 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2004_p50 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & anio==2004 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2004_p75 = (`r(r1)')
matrix inc_priSL`iscosklv'2004_estat=`iscosklv', inc_priSL`iscosklv'2004_mean, inc_priSL`iscosklv'2004_se, inc_priSL`iscosklv'2004_sd, inc_priSL`iscosklv'2004_cv,  inc_priSL`iscosklv'2004_p25,  inc_priSL`iscosklv'2004_p50, inc_priSL`iscosklv'2004_p75, inc_priSL`iscosklv'2004_N
matrix list inc_priSL`iscosklv'2004_estat
}

matrix  Inc_SL_2004=inc_priSL12004_estat\inc_priSL22004_estat\inc_priSL32004_estat\inc_priSL42004_estat
matrix list Inc_SL_2004

* For 2017:
* ---------
foreach iscosklv in 1 2 3 4 {
* 2017
svy: mean inc_pri  if iscosklv==`iscosklv' & anio==2017
 matrix list e(_N)
 matrix inc_priSL`iscosklv'2017_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priSL`iscosklv'2017_sd=  r(sd)
matrix list r(mean)
matrix inc_priSL`iscosklv'2017_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priSL`iscosklv'2017_cv=  r(cv)
matrix list r(se)
matrix inc_priSL`iscosklv'2017_se=  r(se)
_pctile inc_pri if iscosklv==`iscosklv' & anio==2017 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priSL`iscosklv'2017_p25 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & anio==2017 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2017_p50 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & anio==2017 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2017_p75 = (`r(r1)')
matrix inc_priSL`iscosklv'2017_estat=`iscosklv', inc_priSL`iscosklv'2017_mean, inc_priSL`iscosklv'2017_se, inc_priSL`iscosklv'2017_sd, inc_priSL`iscosklv'2017_cv,  inc_priSL`iscosklv'2017_p25,  inc_priSL`iscosklv'2017_p50, inc_priSL`iscosklv'2017_p75, inc_priSL`iscosklv'2017_N
matrix list inc_priSL`iscosklv'2017_estat
}

matrix  Inc_SL_2017=inc_priSL12017_estat\inc_priSL22017_estat\inc_priSL32017_estat\inc_priSL42017_estat
matrix list Inc_SL_2017

* For the pooled data:
* -----------------------
 
foreach iscosklv in 1 2 3 4 {
* Pooled
svy: mean inc_pri  if iscosklv==`iscosklv' 
 matrix list e(_N)
 matrix inc_priSL`iscosklv'Pooled_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priSL`iscosklv'Pooled_sd=  r(sd)
matrix list r(mean)
matrix inc_priSL`iscosklv'Pooled_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priSL`iscosklv'Pooled_cv=  r(cv)
matrix list r(se)
matrix inc_priSL`iscosklv'Pooled_se=  r(se)
_pctile inc_pri if iscosklv==`iscosklv'  [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priSL`iscosklv'Pooled_p25 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv'  [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priSL`iscosklv'Pooled_p50 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv'  [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priSL`iscosklv'Pooled_p75 = (`r(r1)')
matrix inc_priSL`iscosklv'Pooled_estat=`iscosklv', inc_priSL`iscosklv'Pooled_mean, inc_priSL`iscosklv'Pooled_se, inc_priSL`iscosklv'Pooled_sd, inc_priSL`iscosklv'Pooled_cv,  inc_priSL`iscosklv'Pooled_p25,  inc_priSL`iscosklv'Pooled_p50, inc_priSL`iscosklv'Pooled_p75, inc_priSL`iscosklv'Pooled_N
matrix list inc_priSL`iscosklv'Pooled_estat
}

matrix  Inc_SL_Pooled=inc_priSL1Pooled_estat\inc_priSL2Pooled_estat\inc_priSL3Pooled_estat\inc_priSL4Pooled_estat
matrix list Inc_SL_Pooled

* Educational Level:
* ==================
tab educ anio, column 
tab educ, nolabel

* For 2004:
* ---------
foreach educ in 0 1 2 3 4 5  {
* 2004
svy: mean inc_pri  if educ==`educ' & anio==2004
 matrix list e(_N)
 matrix inc_priE`educ'2004_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priE`educ'2004_sd=  r(sd)
matrix list r(mean)
matrix inc_priE`educ'2004_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priE`educ'2004_cv=  r(cv)
matrix list r(se)
matrix inc_priE`educ'2004_se=  r(se)
_pctile inc_pri if educ==`educ' & anio==2004 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priE`educ'2004_p25 = (`r(r1)')
_pctile inc_pri if educ==`educ' & anio==2004 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priE`educ'2004_p50 = (`r(r1)')
_pctile inc_pri if educ==`educ' & anio==2004 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priE`educ'2004_p75 = (`r(r1)')
matrix inc_priE`educ'2004_estat=`educ', inc_priE`educ'2004_mean, inc_priE`educ'2004_se, inc_priE`educ'2004_sd, inc_priE`educ'2004_cv,  inc_priE`educ'2004_p25,  inc_priE`educ'2004_p50, inc_priE`educ'2004_p75, inc_priE`educ'2004_N
matrix list inc_priE`educ'2004_estat
}

matrix  Inc_E_2004=inc_priE02004_estat\inc_priE12004_estat\inc_priE22004_estat\inc_priE32004_estat\inc_priE42004_estat\inc_priE52004_estat
matrix list Inc_E_2004

* For 2017:
* ---------
foreach educ in 0 1 2 3 4 5 {
* 2017
svy: mean inc_pri  if educ==`educ' & anio==2017
 matrix list e(_N)
 matrix inc_priE`educ'2017_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priE`educ'2017_sd=  r(sd)
matrix list r(mean)
matrix inc_priE`educ'2017_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priE`educ'2017_cv=  r(cv)
matrix list r(se)
matrix inc_priE`educ'2017_se=  r(se)
_pctile inc_pri if educ==`educ' & anio==2017 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priE`educ'2017_p25 = (`r(r1)')
_pctile inc_pri if educ==`educ' & anio==2017 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priE`educ'2017_p50 = (`r(r1)')
_pctile inc_pri if educ==`educ' & anio==2017 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priE`educ'2017_p75 = (`r(r1)')
matrix inc_priE`educ'2017_estat=`educ', inc_priE`educ'2017_mean, inc_priE`educ'2017_se, inc_priE`educ'2017_sd, inc_priE`educ'2017_cv,  inc_priE`educ'2017_p25,  inc_priE`educ'2017_p50, inc_priE`educ'2017_p75, inc_priE`educ'2017_N
matrix list inc_priE`educ'2017_estat
}

matrix  Inc_E_2017=inc_priE02017_estat\inc_priE12017_estat\inc_priE22017_estat\inc_priE32017_estat\inc_priE42017_estat\inc_priE52017_estat
matrix list Inc_E_2017

* For the pooled data:
* -----------------------
 
foreach educ in 0 1 2 3 4 5  {
* Pooled
svy: mean inc_pri  if educ==`educ' 
 matrix list e(_N)
 matrix inc_priE`educ'Pooled_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priE`educ'Pooled_sd=  r(sd)
matrix list r(mean)
matrix inc_priE`educ'Pooled_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priE`educ'Pooled_cv=  r(cv)
matrix list r(se)
matrix inc_priE`educ'Pooled_se=  r(se)
_pctile inc_pri if educ==`educ'  [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priE`educ'Pooled_p25 = (`r(r1)')
_pctile inc_pri if educ==`educ'  [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priE`educ'Pooled_p50 = (`r(r1)')
_pctile inc_pri if educ==`educ'  [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priE`educ'Pooled_p75 = (`r(r1)')
matrix inc_priE`educ'Pooled_estat=`educ', inc_priE`educ'Pooled_mean, inc_priE`educ'Pooled_se, inc_priE`educ'Pooled_sd, inc_priE`educ'Pooled_cv,  inc_priE`educ'Pooled_p25,  inc_priE`educ'Pooled_p50, inc_priE`educ'Pooled_p75, inc_priE`educ'Pooled_N
matrix list inc_priE`educ'Pooled_estat
}

matrix  Inc_E_Pooled=inc_priE0Pooled_estat\inc_priE1Pooled_estat\inc_priE2Pooled_estat\inc_priE3Pooled_estat\inc_priE4Pooled_estat\inc_priE5Pooled_estat
matrix list Inc_E_Pooled

* Urban-Rural:
tab urban anio,  column 
tab urban, nolabel

* For 2004:
* ---------
foreach urban in 0 1 {
* 2004
svy: mean inc_pri  if urban==`urban' & anio==2004
 matrix list e(_N)
 matrix inc_priU`urban'2004_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priU`urban'2004_sd=  r(sd)
matrix list r(mean)
matrix inc_priU`urban'2004_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priU`urban'2004_cv=  r(cv)
matrix list r(se)
matrix inc_priU`urban'2004_se=  r(se)
_pctile inc_pri if urban==`urban' & anio==2004 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priU`urban'2004_p25 = (`r(r1)')
_pctile inc_pri if urban==`urban' & anio==2004 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priU`urban'2004_p50 = (`r(r1)')
_pctile inc_pri if urban==`urban' & anio==2004 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priU`urban'2004_p75 = (`r(r1)')
matrix inc_priU`urban'2004_estat=`urban', inc_priU`urban'2004_mean, inc_priU`urban'2004_se, inc_priU`urban'2004_sd, inc_priU`urban'2004_cv,  inc_priU`urban'2004_p25,  inc_priU`urban'2004_p50, inc_priU`urban'2004_p75, inc_priU`urban'2004_N
matrix list inc_priU`urban'2004_estat
}

matrix  Inc_U_2004=inc_priU02004_estat\inc_priU12004_estat
matrix list Inc_U_2004

* For 2017:
* ---------
foreach urban in 0 1 {
* 2017
svy: mean inc_pri  if urban==`urban' & anio==2017
 matrix list e(_N)
 matrix inc_priU`urban'2017_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priU`urban'2017_sd=  r(sd)
matrix list r(mean)
matrix inc_priU`urban'2017_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priU`urban'2017_cv=  r(cv)
matrix list r(se)
matrix inc_priU`urban'2017_se=  r(se)
_pctile inc_pri if urban==`urban' & anio==2017 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priU`urban'2017_p25 = (`r(r1)')
_pctile inc_pri if urban==`urban' & anio==2017 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priU`urban'2017_p50 = (`r(r1)')
_pctile inc_pri if urban==`urban' & anio==2017 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priU`urban'2017_p75 = (`r(r1)')
matrix inc_priU`urban'2017_estat=`urban', inc_priU`urban'2017_mean, inc_priU`urban'2017_se, inc_priU`urban'2017_sd, inc_priU`urban'2017_cv,  inc_priU`urban'2017_p25,  inc_priU`urban'2017_p50, inc_priU`urban'2017_p75, inc_priU`urban'2017_N
matrix list inc_priU`urban'2017_estat
}

matrix  Inc_U_2017=inc_priU02017_estat\inc_priU12017_estat
matrix list Inc_U_2017

* For the pooled data:
* -----------------------
 
foreach urban in 0 1  {
* Pooled
svy: mean inc_pri  if urban==`urban' 
 matrix list e(_N)
 matrix inc_priU`urban'Pooled_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priU`urban'Pooled_sd=  r(sd)
matrix list r(mean)
matrix inc_priU`urban'Pooled_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priU`urban'Pooled_cv=  r(cv)
matrix list r(se)
matrix inc_priU`urban'Pooled_se=  r(se)
_pctile inc_pri if urban==`urban'  [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priU`urban'Pooled_p25 = (`r(r1)')
_pctile inc_pri if urban==`urban'  [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priU`urban'Pooled_p50 = (`r(r1)')
_pctile inc_pri if urban==`urban'  [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priU`urban'Pooled_p75 = (`r(r1)')
matrix inc_priU`urban'Pooled_estat=`urban', inc_priU`urban'Pooled_mean, inc_priU`urban'Pooled_se, inc_priU`urban'Pooled_sd, inc_priU`urban'Pooled_cv,  inc_priU`urban'Pooled_p25,  inc_priU`urban'Pooled_p50, inc_priU`urban'Pooled_p75, inc_priU`urban'Pooled_N
matrix list inc_priU`urban'Pooled_estat
}

matrix  Inc_U_Pooled=inc_priU0Pooled_estat\inc_priU1Pooled_estat
matrix list Inc_U_Pooled

* Geographic zone:
* ================
tab zone anio, column  

tab zone, nolabel

* For 2004:
* ---------
foreach zone in 1 2 3 4  {
* 2004
svy: mean inc_pri  if zone==`zone' & anio==2004
 matrix list e(_N)
 matrix inc_priZ`zone'2004_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priZ`zone'2004_sd=  r(sd)
matrix list r(mean)
matrix inc_priZ`zone'2004_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priZ`zone'2004_cv=  r(cv)
matrix list r(se)
matrix inc_priZ`zone'2004_se=  r(se)
_pctile inc_pri if zone==`zone' & anio==2004 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priZ`zone'2004_p25 = (`r(r1)')
_pctile inc_pri if zone==`zone' & anio==2004 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priZ`zone'2004_p50 = (`r(r1)')
_pctile inc_pri if zone==`zone' & anio==2004 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priZ`zone'2004_p75 = (`r(r1)')
matrix inc_priZ`zone'2004_estat=`zone', inc_priZ`zone'2004_mean, inc_priZ`zone'2004_se, inc_priZ`zone'2004_sd, inc_priZ`zone'2004_cv,  inc_priZ`zone'2004_p25,  inc_priZ`zone'2004_p50, inc_priZ`zone'2004_p75, inc_priZ`zone'2004_N
matrix list inc_priZ`zone'2004_estat
}

matrix  Inc_Z_2004=inc_priZ12004_estat\inc_priZ22004_estat\inc_priZ32004_estat\inc_priZ42004_estat
matrix list Inc_Z_2004

* For 2017:
* ---------
foreach zone in 1 2 3 4 {
* 2017
svy: mean inc_pri  if zone==`zone' & anio==2017
 matrix list e(_N)
 matrix inc_priZ`zone'2017_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priZ`zone'2017_sd=  r(sd)
matrix list r(mean)
matrix inc_priZ`zone'2017_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priZ`zone'2017_cv=  r(cv)
matrix list r(se)
matrix inc_priZ`zone'2017_se=  r(se)
_pctile inc_pri if zone==`zone' & anio==2017 [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priZ`zone'2017_p25 = (`r(r1)')
_pctile inc_pri if zone==`zone' & anio==2017 [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priZ`zone'2017_p50 = (`r(r1)')
_pctile inc_pri if zone==`zone' & anio==2017 [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priZ`zone'2017_p75 = (`r(r1)')
matrix inc_priZ`zone'2017_estat=`zone', inc_priZ`zone'2017_mean, inc_priZ`zone'2017_se, inc_priZ`zone'2017_sd, inc_priZ`zone'2017_cv,  inc_priZ`zone'2017_p25,  inc_priZ`zone'2017_p50, inc_priZ`zone'2017_p75, inc_priZ`zone'2017_N
matrix list inc_priZ`zone'2017_estat
}

matrix  Inc_Z_2017=inc_priZ12017_estat\inc_priZ22017_estat\inc_priZ32017_estat\inc_priZ42017_estat
matrix list Inc_Z_2017

* For the pooled data:
* -----------------------
 
foreach zone in 1 2 3 4 {
* Pooled
svy: mean inc_pri  if zone==`zone' 
 matrix list e(_N)
 matrix inc_priZ`zone'Pooled_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priZ`zone'Pooled_sd=  r(sd)
matrix list r(mean)
matrix inc_priZ`zone'Pooled_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priZ`zone'Pooled_cv=  r(cv)
matrix list r(se)
matrix inc_priZ`zone'Pooled_se=  r(se)
_pctile inc_pri if zone==`zone'  [pweight=facpob07], p(25)
 di `r(r1)'
 matrix inc_priZ`zone'Pooled_p25 = (`r(r1)')
_pctile inc_pri if zone==`zone'  [pweight=facpob07], p(50)
 di `r(r1)'
  matrix inc_priZ`zone'Pooled_p50 = (`r(r1)')
_pctile inc_pri if zone==`zone'  [pweight=facpob07], p(75)
 di `r(r1)'
  matrix inc_priZ`zone'Pooled_p75 = (`r(r1)')
matrix inc_priZ`zone'Pooled_estat=`zone', inc_priZ`zone'Pooled_mean, inc_priZ`zone'Pooled_se, inc_priZ`zone'Pooled_sd, inc_priZ`zone'Pooled_cv,  inc_priZ`zone'Pooled_p25,  inc_priZ`zone'Pooled_p50, inc_priZ`zone'Pooled_p75, inc_priZ`zone'Pooled_N
matrix list inc_priZ`zone'Pooled_estat
}

matrix  Inc_Z_Pooled=inc_priZ1Pooled_estat\inc_priZ2Pooled_estat\inc_priZ3Pooled_estat\inc_priZ4Pooled_estat
matrix list Inc_Z_Pooled


* ===============================================
* REPORTING ALL MATRIX:
* ===============================================
* Sector:
matrix list Inc_S_2007
matrix list Inc_S_2017
matrix list Inc_S_Pooled
* Grangroup:
matrix list Inc_I_2004
matrix list Inc_I_2017
matrix list Inc_I_Pooled
* ISCO Skill-level:
matrix list Inc_SL_2004
matrix list Inc_SL_2017
matrix list Inc_SL_Pooled
* Educational Level:
matrix list Inc_E_2004
matrix list Inc_E_2017
matrix list Inc_E_Pooled
* Urban-Rural:
matrix list Inc_U_2004
matrix list Inc_U_2017
matrix list Inc_U_Pooled
* Geographic zone:
matrix list Inc_Z_2004
matrix list Inc_Z_2017
matrix list Inc_Z_Pooled


* Graphs:
* =============================================================================
cd "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO\2004-2017"

* Main Occupation Income by Sector: 
* ------------------------------------------------------------------------------
graph hbox lw if anio==2007 [pweight = facpob07], over(sector)  ///
 graphregion(color(white))  title("Year 2007", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Sx7, replace)

graph hbox lw  if anio==2017 [pweight = facpob07], over(sector)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Sx17, replace)

graph hbox lw  [pweight = facpob07], over(sector)  ///
 graphregion(color(white)) title("Period 2007-2017 (Pooled Cross-Section)", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SxT, replace)

graph combine Sx7 Sx17 SxT, rows(3) title("Yearly Income of the Main Ocupation by Sector", size(small)) ///
subtitle("ENAHO Cross-Sections 2007-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(SxC, replace)
graph export "cS.png", as(png) replace  
graph save Sx7 WagebySector_7c, replace
graph save Sx17 WagebySector_17c, replace
graph save SxT WagebySector_Pooled, replace
graph save SxC WagebySector_Combinedc, replace
graph close

* Main Occupation Income - By Occupation Group:
* ------------------------------------------------------------------------------

graph hbox lw if anio==2004 [pweight = facpob07], over(grangrup)  ///
 graphregion(color(white))  title("Year 2004", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ix4, replace)

graph hbox lw  if anio==2017 [pweight = facpob07], over(grangrup)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ix17, replace)

graph hbox lw  [pweight = facpob07], over(grangrup)  ///
 graphregion(color(white)) title("Period 2004-2017 (Pooled Cross-Section)", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(IxT, replace)

graph combine Ix4 Ix17 IxT, rows(3) title("Yearly Income of the Main Ocupation by ISCO Major Group", size(small)) ///
subtitle("ENAHO Cross-Sections 2004-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(IxC, replace)
graph export "cI.png", as(png) replace  
graph save Ix4 WagebyISCO_14c, replace
graph save Ix17 WagebyISCO_17c, replace
graph save IxT WagebyISCO_Pooled, replace
graph save IxC WagebyISCO_Combinedc, replace
graph close


* Main Occupation Income - By ISCO Skill Level:
* ------------------------------------------------------------------------------

graph hbox lw if anio==2004 [pweight = facpob07], over(iscosklv)  ///
 graphregion(color(white))  title("Year 2004", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SLx4, replace)

graph hbox lw  if anio==2017 [pweight = facpob07], over(iscosklv)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SLx17, replace)

graph hbox lw  [pweight = facpob07], over(iscosklv)  ///
 graphregion(color(white)) title("Period 2004-2017 (Pooled Cross-Section)", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SLxT, replace)

graph combine SLx4 SLx17 SLxT, rows(3) title("Yearly Income of the Main Ocupation by ISCO Skill Level", size(small)) ///
subtitle("ENAHO Cross-Sections 2004-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(SLxC, replace)
graph export "cSL.png", as(png) replace  
graph save SLx4 WagebyISCOlv_4c, replace
graph save SLx17 WagebyISCOlv_17c, replace
graph save SLxT WagebyISCOlv_Pooled, replace
graph save SLxC WagebyISCOlv_Combinedc, replace
graph close


* Main Occupation Income by Educational Level Achieved:
* ------------------------------------------------------------------------------
graph hbox lw if anio==2004 [pweight = facpob07], over(educ)  ///
 graphregion(color(white))  title("Year 2004", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ex4, replace)

graph hbox lw  if anio==2017 [pweight = facpob07], over(educ)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ex17, replace)

graph hbox lw  [pweight = facpob07], over(educ)  ///
 graphregion(color(white)) title("Period 2004-2017 (Pooled Cross-Section)", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(ExT, replace)

graph combine Ex4 Ex17 ExT, rows(3) title("Yearly Income of the Main Ocupation by Educational Level Achieved", size(small)) ///
subtitle("ENAHO Cross-Sections 2004-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(ExC, replace)
graph export "cE.png", as(png) replace  
graph save Ex4 WagebyEdLevel_4c, replace
graph save Ex17 WagebyEdLevel_17c, replace
graph save ExT WagebyEdLevel_Pooled, replace
graph save ExC WagebyEdLevel_Combinedc, replace
graph close

* Main Occupation Income - Urban vs. Rural:
* ------------------------------------------------------------------------------
graph hbox lw if anio==2004 [pweight = facpob07], over(urban)  ///
 graphregion(color(white))  title("Year 2004", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ux4, replace)

graph hbox lw  if anio==2017 [pweight = facpob07], over(urban)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ux17, replace)

graph hbox lw  [pweight = facpob07], over(urban)  ///
 graphregion(color(white)) title("Period 2004-2017 (Pooled Cross-Section)", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(UxT, replace)

graph combine Ux4 Ux17 UxT, rows(3) title("Yearly Income of the Main Ocupation -  Urban vs. Rural", size(small)) ///
subtitle("ENAHO Cross-Sections 2004-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(UxC, replace)
graph export "cU.png", as(png) replace  
graph save Ux4 WagebyUrban_4c, replace
graph save Ux17 WagebyUrban_17c, replace
graph save UxT WagebyUrban_Pooled, replace
graph save UxC WagebyUrban_Combinedc, replace
graph close


* Main Occupation Income - By Geographic Zone:
* ------------------------------------------------------------------------------
graph hbox lw if anio==2004 [pweight = facpob07], over(zone)  ///
 graphregion(color(white))  title("Year 2004", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Zx4, replace)

graph hbox lw  if anio==2017 [pweight = facpob07], over(zone)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Zx17, replace)

graph hbox lw  [pweight = facpob07], over(zone)  ///
 graphregion(color(white)) title("Period 2004-2017 (Pooled Cross-Section)", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(ZxT, replace)

graph combine Zx4 Zx17 ZxT, rows(3) title("Yearly Income of the Main Ocupation by Geographic Zone", size(small)) ///
subtitle("ENAHO Cross-Sections 2004-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(ZxC, replace)
graph export "cZ.png", as(png) replace  
graph save Zx4 WagebyZone_4c, replace
graph save Zx17 WagebyZone_17c, replace
graph save ZxT WagebyZone_Pooled, replace
graph save ZxC WagebyZone_Combinedc, replace
graph close

*******************************************************************************
*
*               New graphics
*
*******************************************************************************


* 1. Cumulative change in real weekly earnings of working age adults ages 16-64

* By educational level:

* Male:
use "$enahopost\base_cs_enaho.dta", clear

collapse (mean) inc_pri if p207==1 [pweight=facpob07], by(anio educ)

drop if educ==.

gen inc_pri_04=0
replace inc_pri_04=374.602 if educ==0
replace inc_pri_04=1782.233 if educ==1
replace inc_pri_04=4271.399 if educ==2
replace inc_pri_04=7776.766 if educ==3
replace inc_pri_04=12337.9 if educ==4
replace inc_pri_04=31527.37 if educ==5


gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_maled.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Male by Educ") sheetreplace
drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(educ)

label variable anio "Year"

label variable inc_040 "No level"
label variable inc_041 "Primary"
label variable inc_042 "Secondary"
label variable inc_043 "Superior non-university"
label variable inc_044 "Superior university" 
label variable inc_045 "Postgraduated" 

line inc_040 inc_041 inc_042 inc_043 inc_044 inc_045 anio, ///
 title("Male") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(maleseduc, replace)
graph export "WageMalesEduc.png", as(png) replace 
graph save maleseduc WageMalesEduc, replace

* Female:
use "$enahopost\base_cs_enaho.dta", clear

tab p207
tab p207, nolabel

collapse (mean) inc_pri if p207==2 [pweight=facpob07], by(anio educ)

drop if educ==.

gen inc_pri_04=0
replace inc_pri_04=371.603 if educ==0
replace inc_pri_04=759.568 if educ==1
replace inc_pri_04=1865.471 if educ==2
replace inc_pri_04=4218.413 if educ==3
replace inc_pri_04=5856.395 if educ==4
replace inc_pri_04=17137.95 if educ==5

gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_femaled.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Female by Educ") sheetreplace

drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(educ)

label variable anio "Year"

label variable inc_040 "No level"
label variable inc_041 "Primary"
label variable inc_042 "Secondary"
label variable inc_043 "Superior non-university"
label variable inc_044 "Superior university" 
label variable inc_045 "Postgraduated" 

line inc_040 inc_041 inc_042 inc_043 inc_044 inc_045 anio, ///
 title("Female") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(femaleseduc, replace)
 graph export "WageFemalesEduc.png", as(png)  replace
 graph save femaleseduc WageFemalesEduc, replace
 
grc1leg maleseduc femaleseduc, cols(2) legendfrom(maleseduc) graphregion(color(white)) ///
title("Change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(wageeduc, replace) 

 graph export "WageEduc.png", as(png)  replace
 
graph save wageeduc WageEduc, replace

* Combination of both sex groups:

use "$enahopost\base_cs_enaho_femaled.dta", clear
rename inc_pri fem_inc_pri
rename inc_pri_04 fem_inc_pri_04 
rename inc_04 fem_inc_04
merge 1:1 anio educ using "$enahopost\base_cs_enaho_maled.dta"
rename inc_pri mal_inc_pri
rename inc_pri_04 mal_inc_pri_04 
rename inc_04 mal_inc_04

drop _merge

save "$enahopost\cs_enaho_edwagechang.dta", replace


 export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Long") sheetreplace
 
 
 reshape wide fem_inc_pri fem_inc_pri_04 fem_inc_04 mal_inc_pri mal_inc_pri_04 mal_inc_04, i(anio) j(educ)
drop *inc_pri_04*
 

label variable anio "Year"

label variable  fem_inc_pri0  "No level"
label variable  fem_inc_040 "No level"
label variable mal_inc_pri0 "No level"
label variable mal_inc_040 "No level"
label variable fem_inc_pri1 "Primary"
label variable fem_inc_041 "Primary"
label variable mal_inc_pri1 "Primary"
label variable mal_inc_041 "Primary"
label variable fem_inc_pri2 "Secondary"
label variable fem_inc_042 "Secondary"
label variable mal_inc_pri2 "Secondary"
label variable mal_inc_042  "Secondary"
label variable fem_inc_pri3  "Superior non-university"
label variable fem_inc_043   "Superior non-university"
label variable mal_inc_pri3   "Superior non-university"
label variable mal_inc_043    "Superior non-university"
label variable fem_inc_pri4 "Superior university" 
label variable fem_inc_044  "Superior university" 
label variable mal_inc_pri4 "Superior university" 
label variable mal_inc_044 "Superior university" 
label variable fem_inc_pri5  "Postgraduated"
label variable fem_inc_045  "Postgraduated"
label variable mal_inc_pri5  "Postgraduated"
label variable mal_inc_045 "Postgraduated"
 
 save "$enahopost\cs_enaho_edwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide") sheetreplace
  
line fem_inc_040 fem_inc_041 fem_inc_042 fem_inc_043 fem_inc_044 fem_inc_045 anio, ///
 title("Female") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(femaleseduc04, replace)
 graph export "WageFemalesEduc04.png", as(png)  replace
 graph save femaleseduc04 WageFemalesEduc04, replace

 line mal_inc_040 mal_inc_041 mal_inc_042 mal_inc_043 mal_inc_044 mal_inc_045 anio, ///
 title("Male") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)  name(maleseduc04, replace)
 graph export "WageMalesEduc04.png", as(png)  replace
 graph save maleseduc04 WageMalesEduc04, replace
 
 grc1leg maleseduc04 femaleseduc04, cols(2) legendfrom(maleseduc04) graphregion(color(white)) ///
title("Cumulate change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(wageeduc04, replace) 

 graph export "WageEduc04.png", as(png)  replace
 
graph save wageeduc04 WageEduc04, replace
 

line fem_inc_pri0 fem_inc_pri1 fem_inc_pri2 fem_inc_pri3 fem_inc_pri4 fem_inc_pri5 anio, ///
 title("Female") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)  name(femaleseducpri, replace)
 graph export "WageFemalesEducpri.png", as(png)  replace
 graph save femaleseducpri WageFemalesEducpri, replace

 line mal_inc_pri0 mal_inc_pri1 mal_inc_pri2 mal_inc_pri3 mal_inc_pri4 mal_inc_pri5 anio, ///
 title("Male") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)   name(maleseducpri, replace)
 graph export "WageMalesEducpri.png", as(png)  replace
 graph save maleseducpri WageMalesEducpri, replace
 
  grc1leg maleseducpri femaleseducpri, cols(2) legendfrom(maleseducpri) graphregion(color(white)) ///
title("Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(wageeducpri, replace) 

 graph export "WageEducpri.png", as(png)  replace
 
graph save wageeducpri WageEducpri, replace

 save "$enahopost\cs_enaho_edwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide") sheetreplace
 
* By ISCO-Level
*-------------------------------------------------------------------------------
* Male:
use "$enahopost\base_cs_enaho.dta", clear

gen iscosklv=.
replace iscosklv=4 if grangrup==2
replace iscosklv=3 if grangrup==3
replace iscosklv=2 if inlist(grangrup,4,5,6,7,8)
replace iscosklv=1 if grangrup==9

lab def iscosklv 1 "1st Level" 2 "2nd Level" 3 "3rd level" 4 "4th level" 
lab val iscosklv iscosklv

collapse (mean) inc_pri if p207==1 [pweight=facpob07], by(anio iscosklv)

drop if iscosklv==.

gen inc_pri_04=0
replace inc_pri_04=3625.822 if iscosklv==1
replace inc_pri_04=6410.541 if iscosklv==2
replace inc_pri_04=16227.77 if iscosklv==3
replace inc_pri_04=19013.18 if iscosklv==4

gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_maled_iscosklv.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Male by iscosklv") sheetreplace
drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(iscosklv)

label variable anio "Year"

label variable inc_041 "1st Level"
label variable inc_042 "2nd Level"
label variable inc_043 "3rd Level"
label variable inc_044 "4th Level" 

line inc_041 inc_042 inc_043 inc_044 anio, ///
 title("Male") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(malesiscosklv, replace)
graph export "WageMalesiscosklv.png", as(png) replace 
graph save malesiscosklv WageMalesiscosklv, replace

* Female:
use "$enahopost\base_cs_enaho.dta", clear

gen iscosklv=.
replace iscosklv=4 if grangrup==2
replace iscosklv=3 if grangrup==3
replace iscosklv=2 if inlist(grangrup,4,5,6,7,8)
replace iscosklv=1 if grangrup==9

lab def iscosklv 1 "1st Level" 2 "2nd Level" 3 "3rd level" 4 "4th level" 
lab val iscosklv iscosklv


tab p207
tab p207, nolabel

collapse (mean) inc_pri if p207==2 [pweight=facpob07], by(anio iscosklv)

drop if iscosklv==.

gen inc_pri_04=0
replace inc_pri_04=1799.604 if iscosklv==1
replace inc_pri_04=4366.981 if iscosklv==2
replace inc_pri_04=10789.981 if iscosklv==3
replace inc_pri_04=10600.06 if iscosklv==4


gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_femaled_iscosklv.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Female by iscosklv") sheetreplace

drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(iscosklv)

label variable anio "Year"

label variable inc_041 "1st Level"
label variable inc_042 "2nd Level"
label variable inc_043 "3rd Level"
label variable inc_044 "4th Level" 

line inc_041 inc_042 inc_043 inc_044 anio, ///
 title("Female") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(femalesiscosklv, replace)
 graph export "WageFemalesiscosklv.png", as(png)  replace
 graph save femalesiscosklv WageFemalesiscosklv, replace
 
grc1leg malesiscosklv femalesiscosklv, cols(2) legendfrom(malesiscosklv) graphregion(color(white)) ///
title("Change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(wageiscosklv, replace) 

 graph export "Wageiscosklv.png", as(png)  replace
 
graph save wageiscosklv Wageiscosklv, replace

* Combination of both sex groups:

use "$enahopost\base_cs_enaho_femaled_iscosklv.dta", clear
rename inc_pri fem_inc_pri
rename inc_pri_04 fem_inc_pri_04 
rename inc_04 fem_inc_04
merge 1:1 anio iscosklv using "$enahopost\base_cs_enaho_maled_iscosklv.dta"
rename inc_pri mal_inc_pri
rename inc_pri_04 mal_inc_pri_04 
rename inc_04 mal_inc_04

drop _merge

save "$enahopost\cs_enaho_iscosklvwagechang.dta", replace


 export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Long - iscosklv") sheetreplace
 
 
 reshape wide fem_inc_pri fem_inc_pri_04 fem_inc_04 mal_inc_pri mal_inc_pri_04 mal_inc_04, i(anio) j(iscosklv)
drop *inc_pri_04*
 

label variable anio "Year"

label variable fem_inc_pri1 "1st Level"
label variable fem_inc_041 "1st Level"
label variable mal_inc_pri1 "1st Level"
label variable mal_inc_041 "1st Level"
label variable fem_inc_pri2 "2nd Level"
label variable fem_inc_042 "2nd Level"
label variable mal_inc_pri2 "2nd Level"
label variable mal_inc_042  "2nd Level"
label variable fem_inc_pri3  "3rd Level"
label variable fem_inc_043   "3rd Level"
label variable mal_inc_pri3   "3rd Level"
label variable mal_inc_043    "3rd Level"
label variable fem_inc_pri4 "4th Level"
label variable fem_inc_044  "4th Level"
label variable mal_inc_pri4 "4th Level"
label variable mal_inc_044 "4th Level"
 
 save "$enahopost\cs_enaho_iscosklvwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide - iscosklv") sheetreplace
  
line fem_inc_041 fem_inc_042 fem_inc_043 fem_inc_044 anio, ///
 title("Female") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(femalesiscosklv04, replace)
 graph export "WageFemalesiscosklv04.png", as(png)  replace
 graph save femalesiscosklv04 WageFemalesiscosklv04, replace

 line mal_inc_041 mal_inc_042 mal_inc_043 mal_inc_044 anio, ///
 title("Male") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)  name(malesiscosklv04, replace)
 graph export "WageMalesiscosklv04.png", as(png)  replace
 graph save malesiscosklv04 WageMalesiscosklv04, replace
 
 grc1leg malesiscosklv04 femalesiscosklv04, cols(2) legendfrom(malesiscosklv04) graphregion(color(white)) ///
title("Cumulate change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(wageiscosklv04, replace) 

 graph export "Wageiscosklv04.png", as(png)  replace
 
graph save wageiscosklv04 Wageiscosklv04, replace
 

 save "$enahopost\cs_enaho_iscosklvwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide - iscosklv") sheetreplace

********************************************************************************

*              Urban - Rural

********************************************************************************  
  
  * 1. Cumulative change in real weekly earnings of working age adults ages 16-64

* By educational level:

* Urban:
use "$enahopost\base_cs_enaho.dta", clear

collapse (mean) inc_pri if urban==1 [pweight=facpob07], by(anio educ)

drop if educ==.

gen inc_pri_04=0
replace inc_pri_04=376.4423 if educ==0
replace inc_pri_04=1470.624 if educ==1
replace inc_pri_04=3472.92 if educ==2
replace inc_pri_04=6099.064 if educ==3
replace inc_pri_04=9587.189 if educ==4
replace inc_pri_04=27449.86 if educ==5

gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_urbaned.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("urban by Educ") sheetreplace
drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(educ)

label variable anio "Year"

label variable inc_040 "No level"
label variable inc_041 "Primary"
label variable inc_042 "Secondary"
label variable inc_043 "Superior non-university"
label variable inc_044 "Superior university" 
label variable inc_045 "Postgraduated" 

line inc_040 inc_041 inc_042 inc_043 inc_044 inc_045 anio, ///
 title("Urban") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(urbaneduc, replace)
graph export "WageurbanEduc.png", as(png) replace 
graph save urbaneduc WageurbanEduc, replace

* Rural:
use "$enahopost\base_cs_enaho.dta", clear

collapse (mean) inc_pri if urban==0 [pweight=facpob07], by(anio educ)

drop if educ==.

gen inc_pri_04=0
replace inc_pri_04=368.7217 if educ==0
replace inc_pri_04=988.5375 if educ==1
replace inc_pri_04=1678.215 if educ==2
replace inc_pri_04=4479.523 if educ==3
replace inc_pri_04=5464.322 if educ==4
replace inc_pri_04=13836.28 if educ==5

gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_ruraled.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Rural by Educ") sheetreplace

drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(educ)

label variable anio "Year"

label variable inc_040 "No level"
label variable inc_041 "Primary"
label variable inc_042 "Secondary"
label variable inc_043 "Superior non-university"
label variable inc_044 "Superior university" 
label variable inc_045 "Postgraduated" 

line inc_040 inc_041 inc_042 inc_043 inc_044 inc_045 anio, ///
 title("Rural") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(ruraleduc, replace)
 graph export "WageruralEduc.png", as(png)  replace
 graph save ruraleduc WageruralEduc, replace
 
grc1leg urbaneduc ruraleduc, cols(2) legendfrom(urbaneduc) graphregion(color(white)) ///
title("Change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(URwageeduc, replace) 

 graph export "URWageEduc.png", as(png)  replace
 
graph save URwageeduc URWageEduc, replace

* Combination of both sex groups:

use "$enahopost\base_cs_enaho_ruraled.dta", clear
rename inc_pri rural_inc_pri
rename inc_pri_04 rural_inc_pri_04 
rename inc_04 rural_inc_04
merge 1:1 anio educ using "$enahopost\base_cs_enaho_urbaned.dta"
rename inc_pri urban_inc_pri
rename inc_pri_04 urban_inc_pri_04 
rename inc_04 urban_inc_04

drop _merge

save "$enahopost\cs_enaho_URedwagechang.dta", replace


 export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Long - UR") sheetreplace
 
 
 reshape wide rural_inc_pri rural_inc_pri_04 rural_inc_04 urban_inc_pri urban_inc_pri_04 urban_inc_04, i(anio) j(educ)
drop *inc_pri_04*
 

label variable anio "Year"

label variable  rural_inc_pri0  "No level"
label variable  rural_inc_040 "No level"
label variable urban_inc_pri0 "No level"
label variable urban_inc_040 "No level"
label variable rural_inc_pri1 "Primary"
label variable rural_inc_041 "Primary"
label variable urban_inc_pri1 "Primary"
label variable urban_inc_041 "Primary"
label variable rural_inc_pri2 "Secondary"
label variable rural_inc_042 "Secondary"
label variable urban_inc_pri2 "Secondary"
label variable urban_inc_042  "Secondary"
label variable rural_inc_pri3  "Superior non-university"
label variable rural_inc_043   "Superior non-university"
label variable urban_inc_pri3   "Superior non-university"
label variable urban_inc_043    "Superior non-university"
label variable rural_inc_pri4 "Superior university" 
label variable rural_inc_044  "Superior university" 
label variable urban_inc_pri4 "Superior university" 
label variable urban_inc_044 "Superior university" 
label variable rural_inc_pri5  "Postgraduated"
label variable rural_inc_045  "Postgraduated"
label variable urban_inc_pri5  "Postgraduated"
label variable urban_inc_045 "Postgraduated"
 
 save "$enahopost\cs_enaho_URedwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide - UR") sheetreplace
  
line rural_inc_040 rural_inc_041 rural_inc_042 rural_inc_043 rural_inc_044 rural_inc_045 anio, ///
 title("Rural") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(ruraleduc04, replace)
 graph export "WageRuralEduc04.png", as(png)  replace
 graph save ruraleduc04 WageruralEduc04, replace

 line urban_inc_040 urban_inc_041 urban_inc_042 urban_inc_043 urban_inc_044 urban_inc_045 anio, ///
 title("Urban") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)  name(urbaneduc04, replace)
 graph export "WageurbanEduc04.png", as(png)  replace
 graph save urbaneduc04 WageurbanEduc04, replace
 
 grc1leg urbaneduc04 ruraleduc04, cols(2) legendfrom(urbaneduc04) graphregion(color(white)) ///
title("Cumulate change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(URwageeduc04, replace) 

 graph export "URWageEduc04.png", as(png)  replace
 
graph save URwageeduc04 URWageEduc04, replace
 

line rural_inc_pri0 rural_inc_pri1 rural_inc_pri2 rural_inc_pri3 rural_inc_pri4 rural_inc_pri5 anio, ///
 title("Rural") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)  name(ruraleducpri, replace)
 graph export "WageruralEducpri.png", as(png)  replace
 graph save ruraleducpri WageruralEducpri, replace

 line urban_inc_pri0 urban_inc_pri1 urban_inc_pri2 urban_inc_pri3 urban_inc_pri4 urban_inc_pri5 anio, ///
 title("Urban") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)   name(urbaneducpri, replace)
 graph export "WageurbanEducpri.png", as(png)  replace
 graph save urbaneducpri WageMalesEducpri, replace
 
  grc1leg urbaneducpri ruraleducpri, cols(2) legendfrom(urbaneducpri) graphregion(color(white)) ///
title("Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(URwageeducpri, replace) 

 graph export "URWageEducpri.png", as(png)  replace
 
graph save URwageeducpri URWageEducpri, replace

 save "$enahopost\cs_enaho_URedwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide - UR") sheetreplace
 
* By ISCO-Level
*-------------------------------------------------------------------------------
* Urban:
use "$enahopost\base_cs_enaho.dta", clear

gen iscosklv=.
replace iscosklv=4 if grangrup==2
replace iscosklv=3 if grangrup==3
replace iscosklv=2 if inlist(grangrup,4,5,6,7,8)
replace iscosklv=1 if grangrup==9

lab def iscosklv 1 "1st Level" 2 "2nd Level" 3 "3rd level" 4 "4th level" 
lab val iscosklv iscosklv

collapse (mean) inc_pri if urban==1 [pweight=facpob07], by(anio iscosklv)

drop if iscosklv==.

gen inc_pri_04=0
replace inc_pri_04=3901.069 if iscosklv==1
replace inc_pri_04=7048.73 if iscosklv==2
replace inc_pri_04=14528.99 if iscosklv==3
replace inc_pri_04=15284.07 if iscosklv==4

gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_urban_iscosklv.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Urban by iscosklv") sheetreplace
drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(iscosklv)

label variable anio "Year"

label variable inc_041 "1st Level"
label variable inc_042 "2nd Level"
label variable inc_043 "3rd Level"
label variable inc_044 "4th Level" 

line inc_041 inc_042 inc_043 inc_044 anio, ///
 title("Urban") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(urbaniscosklv, replace)
graph export "Wageurbaniscosklv.png", as(png) replace 
graph save urbaniscosklv Wageurbaniscosklv, replace

* Rural:
use "$enahopost\base_cs_enaho.dta", clear

gen iscosklv=.
replace iscosklv=4 if grangrup==2
replace iscosklv=3 if grangrup==3
replace iscosklv=2 if inlist(grangrup,4,5,6,7,8)
replace iscosklv=1 if grangrup==9

lab def iscosklv 1 "1st Level" 2 "2nd Level" 3 "3rd level" 4 "4th level" 
lab val iscosklv iscosklv


tab p207
tab p207, nolabel

collapse (mean) inc_pri if urban==0 [pweight=facpob07], by(anio iscosklv)

drop if iscosklv==.

gen inc_pri_04=0
replace inc_pri_04=825.1903 if iscosklv==1
replace inc_pri_04=2827.856 if iscosklv==2
replace inc_pri_04=8278.663 if iscosklv==3
replace inc_pri_04=10726.33 if iscosklv==4


gen inc_04=inc_pri/inc_pri_04

save "$enahopost\base_cs_enaho_rural_iscosklv.dta", replace
 export excel using "$enahopost\Wage_Change.xls", firstrow(variables) sheet("Rural by iscosklv") sheetreplace

drop inc_pri inc_pri_04
reshape wide inc_04, i(anio) j(iscosklv)

label variable anio "Year"

label variable inc_041 "1st Level"
label variable inc_042 "2nd Level"
label variable inc_043 "3rd Level"
label variable inc_044 "4th Level" 

line inc_041 inc_042 inc_043 inc_044 anio, ///
 title("Rural") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(ruraliscosklv, replace)
 graph export "Wageruraliscosklv.png", as(png)  replace
 graph save ruraliscosklv Wageruraliscosklv, replace
 
grc1leg urbaniscosklv ruraliscosklv, cols(2) legendfrom(urbaniscosklv) graphregion(color(white)) ///
title("Change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(URwageiscosklv, replace) 

 graph export "URWageiscosklv.png", as(png)  replace
 
graph save URwageiscosklv URWageiscosklv, replace

* Combination of both UR groups:

use "$enahopost\base_cs_enaho_rural_iscosklv.dta", clear
rename inc_pri rural_inc_pri
rename inc_pri_04 rural_inc_pri_04 
rename inc_04 rural_inc_04
merge 1:1 anio iscosklv using "$enahopost\base_cs_enaho_urban_iscosklv.dta"
rename inc_pri urban_inc_pri
rename inc_pri_04 urban_inc_pri_04 
rename inc_04 urban_inc_04

drop _merge

save "$enahopost\cs_enaho_URiscosklvwagechang.dta", replace


 export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Long - iscosklv UR") sheetreplace
 
 
 reshape wide rural_inc_pri rural_inc_pri_04 rural_inc_04 urban_inc_pri urban_inc_pri_04 urban_inc_04, i(anio) j(iscosklv)
drop *inc_pri_04*
 

label variable anio "Year"

label variable rural_inc_pri1 "1st Level"
label variable rural_inc_041 "1st Level"
label variable urban_inc_pri1 "1st Level"
label variable urban_inc_041 "1st Level"
label variable rural_inc_pri2 "2nd Level"
label variable rural_inc_042 "2nd Level"
label variable urban_inc_pri2 "2nd Level"
label variable urban_inc_042  "2nd Level"
label variable rural_inc_pri3  "3rd Level"
label variable rural_inc_043   "3rd Level"
label variable urban_inc_pri3   "3rd Level"
label variable urban_inc_043    "3rd Level"
label variable rural_inc_pri4 "4th Level"
label variable rural_inc_044  "4th Level"
label variable urban_inc_pri4 "4th Level"
label variable urban_inc_044 "4th Level"
 
 save "$enahopost\cs_enaho_URiscosklvwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide - iscosklv UR") sheetreplace
  
line rural_inc_041 rural_inc_042 rural_inc_043 rural_inc_044 anio, ///
 title("Rural") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017) name(ruraliscosklv04, replace)
 graph export "Wageruraliscosklv04.png", as(png)  replace
 graph save ruraliscosklv04 Wageruraliscosklv04, replace

 line urban_inc_041 urban_inc_042 urban_inc_043 urban_inc_044 anio, ///
 title("Urban") graphregion(color(white)) ylabel(, nogrid)  xlab(2004(2)2017)  name(urbaniscosklv04, replace)
 graph export "Wageurbaniscosklv04.png", as(png)  replace
 graph save urbaniscosklv04 Wageurbaniscosklv04, replace
 
 grc1leg urbaniscosklv04 ruraliscosklv04, cols(2) legendfrom(urbaniscosklv04) graphregion(color(white)) ///
title("Cumulate change in Real Yearly Income of the Main Occupation", size(medium)) ///
 subtitle("2004-2017", size(small)) ///
name(URwageiscosklv04, replace) 

 graph export "URWageiscosklv04.png", as(png)  replace
 
graph save URwageiscosklv04 URWageiscosklv04, replace
 

 save "$enahopost\cs_enaho_URiscosklvwagechang_wide.dta", replace
 
  export excel using "$enahopost\wage-changes.xls", firstrow(variables) sheet("Wide - iscosklv UR") sheetreplace
  
  