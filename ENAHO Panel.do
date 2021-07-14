/* =============================================================================
 Peruvian National Household Survey (ENAHO)
 
 Data diagnosis, cleaning and descriptives statistics
 
============================================================================= */
* Note: For having a balanced panel, in terms of individuals, you need to 
* uncomment "* keep if perpanel1317==1"

global enahopre "C:\Users\\`c(username)'\OneDrive\ENAHO Panel 2013-2017"
global enahopost "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO\Bases de datos"
global iscofolder "C:\Users\\`c(username)'\OneDrive\CIUP\SIEP - Proyecto Brian\Bases de datos\2017\603-Modulo05"

cd "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO"

* We count the sample size using Module 500

use conglome* vivienda* hogar_* codperso_* hpan* perpanel* using "$enahopre\612-Modulo05\enaho01a_2013_2017_500_panel.dta", clear
*use conglome* vivienda* hogar_* codperso_* hpan* perpanel* using "$enahopre\612-Modulo03\enaho01a_2013_2017_300_panel.dta", clear

* 2013

unique conglome vivienda hogar_13 if hogar_13!=" " & (hpan1314==1| hpan1315==1 | hpan1316==1| hpan1317==1)
unique conglome vivienda hogar_13 codperso_13 if hogar_13!=" " & codperso_13!=" " & (hpan1314==1| hpan1315==1 | hpan1316==1| hpan1317==1)

unique conglome vivienda hogar_13 if hogar_13!=" " & (hpan1314==1|hpan1315==1)
* 2014

unique conglome vivienda hogar_14 if hogar_14!=" " & (hpan1314==1| hpan1315==1 | hpan1316==1| hpan1317==1 | hpan1415==1 | hpan1416==1| hpan1417==1 )
unique conglome vivienda hogar_14 codperso_14 if hogar_14!=" " & codperso_13!=" " & (hpan1314==1| hpan1315==1 | hpan1316==1| hpan1317==1 | hpan1415==1 | hpan1416==1| hpan1417==1 )

unique conglome vivienda hogar_14 codperso_14 if hogar_14!=" " & codperso_14!=" " & hpan1317==1
unique conglome vivienda hogar_15 codperso_15 if hogar_15!=" " & codperso_15!=" " & hpan1317==1
unique conglome vivienda hogar_16 codperso_16 if hogar_16!=" " & codperso_16!=" " & hpan1317==1
unique conglome vivienda hogar_17 codperso_17 if hogar_17!=" " & codperso_17!=" " & hpan1317==1


*========================
* Module 300 (Education)
*========================

use "$enahopre\612-Modulo03\enaho01a_2013_2017_300_panel.dta", clear

* Make statistics for individuals who stay between 2013 and 2017: 
sum perpanel1317 hpan1317 

* Keep Individuals who stay between 2013 and 2017
* keep if perpanel1317==1
 keep if hpan1317==1

* Keep people who were part of the household for the entire period
drop if p204_13==2 | p204_14==2 | p204_15==2 | p204_16==2 | p204_17==2

keep conglome* vivienda* hogar* codperso* p301a* p301b* p301c* p208a* perpanel1317 hpan1317 facpanel1317

foreach i in 13 14 15 16 17 {

* Schooling achieved(years)
gen sch_`i'=.
replace sch_`i'=0  if p301a_`i'==1 | p301a_`i'==2 					                                                            // Without level or initial level
replace sch_`i'=0  if p301a_`i'==3 & (p301b_`i'==0 & p301c_`i'==0)																    // Initial level
replace sch_`i'=1  if (p301a_`i'==3 & p301b_`i'==1) | (p301a_`i'==3 & p301c_`i'==1) | (p301a_`i'==4 & p301b_`i'==1) | (p301a_`i'==4 & p301c_`i'==1)     // 1 years  
replace sch_`i'=2  if (p301a_`i'==3 & p301b_`i'==2) | (p301a_`i'==3 & p301c_`i'==2) | (p301a_`i'==4 & p301b_`i'==2) | (p301a_`i'==4 & p301c_`i'==2)     // 2 years 
replace sch_`i'=3  if (p301a_`i'==3 & p301b_`i'==3) | (p301a_`i'==3 & p301c_`i'==3) | (p301a_`i'==4 & p301b_`i'==3) | (p301a_`i'==4 & p301c_`i'==3)     // 3 years 
replace sch_`i'=4  if (p301a_`i'==3 & p301b_`i'==4) | (p301a_`i'==3 & p301c_`i'==4) | (p301a_`i'==4 & p301b_`i'==4) | (p301a_`i'==4 & p301c_`i'==4)     // 4 years 
replace sch_`i'=5  if (p301a_`i'==3 & p301b_`i'==5) | (p301a_`i'==3 & p301c_`i'==5) | (p301a_`i'==4 & p301b_`i'==5) | (p301a_`i'==4 & p301c_`i'==5)     // 5 years 
replace sch_`i'=6  if (p301a_`i'==3 & p301b_`i'==6) | (p301a_`i'==3 & p301c_`i'==6) | (p301a_`i'==4 & p301b_`i'==6) | (p301a_`i'==4 & p301c_`i'==6)     // 6 years 
replace sch_`i'=7  if (p301a_`i'==5 & p301b_`i'==1) | (p301a_`i'==6 & p301b_`i'==1)                                                     // 7 years 
replace sch_`i'=8  if (p301a_`i'==5 & p301b_`i'==2) | (p301a_`i'==6 & p301b_`i'==2)   											        // 8 years 
replace sch_`i'=9  if (p301a_`i'==5 & p301b_`i'==3) | (p301a_`i'==6 & p301b_`i'==3)   												    // 9 years 
replace sch_`i'=10 if (p301a_`i'==5 & p301b_`i'==4) | (p301a_`i'==6 & p301b_`i'==4)   												    // 10 years 
replace sch_`i'=11 if (p301a_`i'==5 & p301b_`i'==5) | (p301a_`i'==6 & p301b_`i'==5)   												    // 11 years 
replace sch_`i'=12 if (p301a_`i'==6 & p301b_`i'==6) 	         																	// Secondary level
replace sch_`i'=12 if (p301a_`i'==7 & p301b_`i'==1) | (p301a_`i'==8 & p301b_`i'==1) | (p301a_`i'==9 & p301b_`i'==1) | (p301a_`i'==10 & p301b_`i'==1)   // 12 years 
replace sch_`i'=13 if (p301a_`i'==7 & p301b_`i'==2) | (p301a_`i'==8 & p301b_`i'==2) | (p301a_`i'==9 & p301b_`i'==2) | (p301a_`i'==10 & p301b_`i'==2)   // 13 years 
replace sch_`i'=14 if (p301a_`i'==7 & p301b_`i'==3) | (p301a_`i'==8 & p301b_`i'==3) | (p301a_`i'==9 & p301b_`i'==3) | (p301a_`i'==10 & p301b_`i'==3)   // 14 years 
replace sch_`i'=15 if (p301a_`i'==7 & p301b_`i'==4) | (p301a_`i'==8 & p301b_`i'==4) | (p301a_`i'==9 & p301b_`i'==4) | (p301a_`i'==10 & p301b_`i'==4)   // 15 years 
replace sch_`i'=16 if (p301a_`i'==7 & p301b_`i'==5) | (p301a_`i'==8 & p301b_`i'==5) | (p301a_`i'==9 & p301b_`i'==5) | (p301a_`i'==10 & p301b_`i'==5)   // 16 years 
replace sch_`i'=17 if (p301a_`i'==9 & p301b_`i'==6) | (p301a_`i'==10 & p301b_`i'==6) | (p301a_`i'==11 & p301b_`i'==1)
replace sch_`i'=18 if (p301a_`i'==9 & p301b_`i'==7) | (p301a_`i'==10 & p301b_`i'==7) | (p301a_`i'==11 & p301b_`i'==2)
label variable sch_`i' "Education level (years) `i' "

* Education level (years)
rename p208a_`i' age_`i'
label variable age_`i' "Age `i'"
}
*

* Generating an identificator por each individual  (Not sure if I will use it)
egen id_codperso=concat(conglome vivienda hogar_17 codperso_17)
duplicates list id_codperso

keep id_codperso sch_* age_*

save "$enahopost\modulo300_panel.dta", replace


*=====================
* Module 500 (Employment)
*=====================
use conglome* vivienda* hogar* codperso* p204_* p301a_* p207_* i524a1_* d529t_* i530a_* d536_* ///
i538a1_* d540t_* i541a_* d543_* d544t_* p558c* p505* p506* p516* p554* estrato_* dominio_* perpanel1317 hpan1317 facpanel1317 using "$enahopre\612-Modulo05\enaho01a_2013_2017_500_panel.dta", clear

* Make statistics for individuals who stay between 2013 and 2017: 
sum perpanel1317 hpan1317 

* Keep Individuals who stay between 2013 and 2017
*keep if perpanel1317==1
keep if hpan1317==1


* Generating an identificator por each individual  (Not sure if I will use it)
egen id_codperso=concat(conglome vivienda hogar_17 codperso_17)
duplicates list id_codperso

* There are some incongruences in the gender of some observations:
br id_codperso p207_* if !(p207_13==p207_14 & p207_13==p207_15 & p207_13==p207_16 & p207_13==p207_17 /// 
                                            & p207_14==p207_15 & p207_14==p207_16 & p207_14==p207_17 ///
                                                               & p207_15==p207_16 & p207_15==p207_17 ///								
                                                                                  & p207_16==p207_17 )
																	  
* So, we correct that information
replace p207_13=2 if id_codperso=="0078841221102"
replace p207_13=1 if id_codperso=="0059540951104"
replace p207_13=2 if id_codperso=="0054030091103"
replace p207_15=2 if id_codperso=="0073700521101"
replace p207_13=2 if id_codperso=="0056690351103"
replace p207_14=1 if id_codperso=="0074291091103"
replace p207_13=1 if id_codperso=="0056690351102"

* Keep people who were part of the household for the entire period
drop if p204_13==2 | p204_14==2 | p204_15==2 | p204_16==2 | p204_17==2


* Instruction/Education Level
label define niveduc 0 "No level" 1 "Primary" 2 "Secondary" 3 "Superior non-university" 4 "Superior university" 5 "Postgraduated" 

foreach i in 13 14 15 16 17 {

gen educ_`i'=.
replace educ_`i'=0 if p301a_`i'==1 | p301a_`i'==2
replace educ_`i'=1 if p301a_`i'==3 | p301a_`i'==4
replace educ_`i'=2 if p301a_`i'==5 | p301a_`i'==6
replace educ_`i'=3 if p301a_`i'==7 | p301a_`i'==8
replace educ_`i'=4 if p301a_`i'==9 | p301a_`i'==10
replace educ_`i'=5 if p301a_`i'==11
label values educ_`i' niveduc
label variable educ_`i' "Education Level `i'"


* Main Occupation Income
egen inc_pri_`i' = rowtotal(i524a1_`i' d529t_`i' i530a_`i' d536_`i')						

* Secondary Occupation Income
egen inc_sec_`i' = rowtotal(i538a1_`i' d540t_`i' i541a_`i' d543_`i')

* Total labor Income
egen inc_lab_`i' = rowtotal(inc_pri_`i' inc_sec_`i')  					

* Extraordinary Income (grati., bonus, CTS, etc)
rename d544t_`i' inc_extra_`i'

* Total monthly income
egen inc_total_`i' = rowtotal(inc_lab_`i' inc_extra_`i') 
replace inc_total_`i'=. if inc_lab_`i'==0 | inc_lab_`i'==. // It could happen that there is a missing at labor income and a payment of CTS

* Logarithm of wage from main occupation income
gen lw_`i'=ln(inc_pri_`i'+1)
replace lw_`i'=0 if lw_`i'==.

* Logarithm of total wage
gen lwage_`i'=ln(inc_total_`i'+1)
replace lwage_`i'=0 if lwage_`i'==.

* Sector of Principal Occupation:
* p506_`i' : CIIU r3
* p506r4_`i' : CIIU r4

gen sector_`i'=.
label variable sector_`i' "Sector Principal Occupation"

replace sector_`i'=1 if p506r4_`i'>=100 & p506r4_`i'<300   // OK
replace sector_`i'=2 if p506r4_`i'>=300 & p506r4_`i'<500   // OK
replace sector_`i'=3 if p506r4_`i'>=500 & p506r4_`i'<1000  // OK
replace sector_`i'=4 if p506r4_`i'>=1000 & p506r4_`i'<3500 // OK
replace sector_`i'=5 if p506r4_`i'>=3500 & p506r4_`i'<4000 // OK
replace sector_`i'=6 if p506r4_`i'>=4000 & p506r4_`i'<4500 // OK
replace sector_`i'=7 if p506r4_`i'>=4500 & p506r4_`i'<4900 // OK
replace sector_`i'=8 if p506r4_`i'>=8400 & p506r4_`i'<8500 // OK
replace sector_`i'=9 if p506r4_`i'>=4900 & p506r4_`i'<8400 // OK
replace sector_`i'=9 if p506r4_`i'>=8500 & p506r4_`i'<9998 // OK

lab def sector_`i' 1 "Agriculture" 2 "Fishing" 3 "Mining" ///
4 "Manufacture" 5 "Electricity and Water" 6 "Construction" 7 "Commerce" ///
8 "Government" 9 "Services"
lab val sector_`i' sector_`i'
 
* Gender
recode p207_`i' (2=0 "Female") (1=1 "Male"), gen(male_`i')
label variable male_`i' "Gender"

* Race or ethnic group
recode p558c_`i' (5=1 "White") (6=2 "Half-Blood") (1/3 9 =3 "Peruvian Native") (4=4 "Afroperuvian") (7=5 "Other") (8=.), gen(race_`i')
label variable race_`i' "Race or ethnic group"

* Area
recode estrato_`i' (1/5=1 "Urban") (6/8=0 "Rural"), gen(urban_`i') 
label variable urban_`i' "Urban `i'"

* Zone
recode dominio_`i' (1/3=1 "Coast") (4/6=2 "Highlands") (7/7=3 "Jungle") (8/8=4 "Lima Metropolis"), gen(zone_`i')
label var zone_`i' "Zone `i'"

drop p204_`i' p207_`i' p558c_`i' dominio_`i' i524a1_`i' d529t_`i' i530a_`i' d536_`i' i538a1_`i' d540t_`i' i541a_`i' d543_`i' p301a_`i'
}
*	

keep id_codperso inc_* educ_* male* race_* urban_* zone_* lw_* lwage_* sector_* perpanel1317 hpan1317 facpanel1317 estrato_* conglome* p505_* p505r4_* /* perpanel1317 hpan1317 facpanel1317 */
order id_codperso educ_* male* race* urban_* zone_* inc_* lwage_* lw_* sector_*  

save "$enahopost\modulo500_panel.dta",replace



* Merge both data bases:
use "$enahopost\modulo500_panel.dta", clear
merge m:1 id_codperso using  "$enahopost\modulo300_panel.dta"
drop if _m==2
drop _m


foreach i in 13 14 15 16 17 {
* Potential Experience
gen exper_`i' = age_`i' - sch_`i' - 6 
label var exper_`i' "Potential Experience `i'=  age - sch - 6"
}
*




* Change the id
gen id=_n
drop id_codperso

* Reshape a long data
reshape long age_ educ_ sch_ male_ sector_ race_ urban_ zone_ exper_ inc_extra_ inc_pri_ inc_sec_ inc_lab_ inc_total_ lw_ lwage_ estrato_  conglome_ p505_ p505r4_ , i(id) j(year)

* Rename indicator of occupation in order to merge with ISCO:

rename p505_ codocupa
rename p505r4_ codocupa_ciuo2015

* There weren´t changes of cluster (conglomerado) in any of our individuals
gen boolean = conglome_==conglome
tab boolean

* So, we can stay with any of those indicators:
drop boolean conglome_

* Renaming variables ending with "_"
rename (*_) (*)

* Replacing years:
replace year=2013 if year==13
replace year=2014 if year==14
replace year=2015 if year==15
replace year=2016 if year==16
replace year=2017 if year==17

save "$enahopost\base_panel_enaho.dta", replace

* Including ISCO:
* --------------

* Opening the table with ISCO codes from the year 88:
use  "$iscofolder\enaho-tabla-ciuo-88.dta", clear

* At ENAHO, we do no have information regarding variety. 
* So, we might drop out variety in order to have a mergeable database. 
* This database will have information regarding "grangrup", "grupo" and "subgrupo". 

* Reduce the dat confirmin each 'codocupa' is just in one combination of 'grangrup', 'grupo' & 'subgrupo': 
duplicates report grangrup grupo subgrupo
duplicates report codocupa // Both are the same.
keep codocupa grangrup grupo subgrupo
duplicates drop
isid codocupa
isid grangrup grupo subgrupo

* Codifying according to "https://www.ilo.org/public/english/bureau/stat/isco/isco88/major.htm"

label variable grangrup "Major Group"
lab def grangrup 1 "Major group 1" 2 "Major group 2" 3 "Major group 3" ///
4 "Major group 4" 5 "Major group 5" 6 "Major group 6" 7 "Major group 7" ///
8 "Major group 8" 9 "Major group 9" 0 "Major group 0"
lab val grangrup grangrup

*1 "Legislators, Officials and MGrs" 2 "Professionals" 3 "Technicians and Associate Professionals" ///
*4 "Clerks" 5 "Service workers and shop and market sales workers" 6 "Skilled agricultural and fishery workers" 7 "Craft and related trades workers" ///
*8 "Plant and machine operators and assemblers" 9 "Elementary occupations" 0 "Armed forces"


save "$enahopost\isco-88.dta", replace

* Merge with the older data set:

use "$enahopost\base_panel_enaho.dta", clear

merge m:1 codocupa using "$enahopost\isco-88.dta"
drop if _merge==2
drop _merge

save "$enahopost\base_panel_enaho.dta", replace

*==================
* BASE PANEL ENAHO
*==================
use "$enahopost\base_panel_enaho.dta", clear

gen iscosklv=.
replace iscosklv=4 if grangrup==1
replace iscosklv=3 if grangrup==2
replace iscosklv=2 if inlist(grangrup,4,5,6,7,8)
replace iscosklv=1 if grangrup==9

lab def iscosklv 1 "1st Level" 2 "2nd Level" 3 "3rd level" 4 "4th level" 
lab val iscosklv iscosklv

* Descriptive statistics:
* -----------------------

svyset conglome [pweight = facpanel1317], strata(estrato) /* || vivienda */ 

* Years of education:
svy: tab sch year, count format(%15.0fc)
* Educational Level:
svy: tab educ year, count format(%15.0fc) column percent 
* Urban-Rural:
svy: tab urban year, count format(%15.0fc) column percent
* Geographic zone:
svy: tab zone year, count format(%15.0fc) column percent  
* Sector:
svy: tab sector year, count format(%15.0fc) column percent  
* Grangroup:
svy: tab grangrup year, count format(%15.0fc) column percent  
* ISCO Skill-level:
svy: tab iscosklv year, count format(%15.0fc) column percent  

* Just observations:
* ===================

* Years of education:
tab sch year
* Educational Level:
tab educ year, column 
* Urban-Rural:
tab urban year,  column 
* Geographic zone:
tab zone year, column  
* Sector:
tab sector year, column 
* Grangroup:
tab grangrup year, column  
* ISCO Skill-level:
tab iscosklv year, column 

* Variables tables:
* ==============================================================================

cd "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO\Table"

* With "iweights", we get the same parameters estimates. 
* But do not get the same standard errors. For instance:
reg lw educ  if year==2013 [iweight = facpanel1317]
reg lw educ  if year==2013 [pweight = facpanel1317]

* Calculating the stats. matrix for each year:
foreach year in 2013 2014 2015 2016 2017 {
svy: mean sch  if year==`year' 
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
_pctile sch if year==`year' [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix sch`year'_p25 = (`r(r1)')
_pctile sch if year==`year' [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix sch`year'_p50 = (`r(r1)')
_pctile sch if year==`year' [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix sch`year'_p75 = (`r(r1)')
matrix sch`year'_estat=`year',sch`year'_mean, sch`year'_se, sch`year'_sd, sch`year'_cv,  sch`year'_p25,  sch`year'_p50, sch`year'_p75
matrix list sch`year'_estat
}

* Calculating the stats. matrix for the total period:
svy: mean sch 
estat sd
matrix list r(sd)
matrix schT_sd=  r(sd)
matrix list r(mean)
matrix schT_mean=  r(mean)
estat cv
matrix list r(cv)
matrix schT_cv=  r(cv)
matrix list r(se)
matrix schT_se=  r(se)
_pctile sch [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix schT_p25 = (`r(r1)')
_pctile sch [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix schT_p50 = (`r(r1)')
_pctile sch [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix schT_p75 = (`r(r1)')
matrix schT_estat=20132017,schT_mean, schT_se, schT_sd, schT_cv,  schT_p25,  schT_p50, schT_p75
matrix list schT_estat

* Compacting each row matrix:
matrix  sch_estat=sch2013_estat\sch2014_estat\sch2015_estat\sch2016_estat\sch2017_estat\schT_estat
display "                          Variable: sch"
display "======================================================================"
matrix list sch_estat


*******************************************************************************


foreach indi in sch educ urban zone sector grangrup  iscosklv {

* Calculating the stats. matrix for each year:
foreach year in 2013 2014 2015 2016 2017 {
svy: mean `indi'  if year==`year' 
estat sd
matrix list r(sd)
matrix `indi'`year'_sd=  r(sd)
matrix list r(mean)
matrix `indi'`year'_mean=  r(mean)
estat cv
matrix list r(cv)
matrix `indi'`year'_cv=  r(cv)
matrix list r(se)
matrix `indi'`year'_se=  r(se)
_pctile `indi' if year==`year' [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix `indi'`year'_p25 = (`r(r1)')
_pctile `indi' if year==`year' [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix `indi'`year'_p50 = (`r(r1)')
_pctile `indi' if year==`year' [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix `indi'`year'_p75 = (`r(r1)')
matrix `indi'`year'_estat=`year',`indi'`year'_mean, `indi'`year'_se, `indi'`year'_sd, `indi'`year'_cv,  `indi'`year'_p25,  `indi'`year'_p50, `indi'`year'_p75
matrix list `indi'`year'_estat
}

* Calculating the stats. matrix for the total period:
svy: mean `indi' 
estat sd
matrix list r(sd)
matrix `indi'T_sd=  r(sd)
matrix list r(mean)
matrix `indi'T_mean=  r(mean)
estat cv
matrix list r(cv)
matrix `indi'T_cv=  r(cv)
matrix list r(se)
matrix `indi'T_se=  r(se)
_pctile `indi' [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix `indi'T_p25 = (`r(r1)')
_pctile `indi' [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix `indi'T_p50 = (`r(r1)')
_pctile `indi' [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix `indi'T_p75 = (`r(r1)')
matrix `indi'T_estat=20132017,`indi'T_mean, `indi'T_se, `indi'T_sd, `indi'T_cv,  `indi'T_p25,  `indi'T_p50, `indi'T_p75
matrix list `indi'T_estat

* Compacting each row matrix:
matrix  `indi'_estat=`indi'2013_estat\ `indi'2014_estat\ `indi'2015_estat\ `indi'2016_estat\ `indi'2017_estat\ `indi'T_estat
display "                          Variable: `indi'"
display "======================================================================"
matrix list `indi'_estat

}

* For "incr_pri" according to categories of each variable:
* ==============================================================================

* Sector:
* =======
tab sector year, column 

* For 2013:
* ---------
foreach sector in 1 2 3 4 5 6 7 8 9 {
* 2013
svy: mean inc_pri  if sector==`sector' & year==2013
 matrix list e(_N)
 matrix inc_priS`sector'2013_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priS`sector'2013_sd=  r(sd)
matrix list r(mean)
matrix inc_priS`sector'2013_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priS`sector'2013_cv=  r(cv)
matrix list r(se)
matrix inc_priS`sector'2013_se=  r(se)
_pctile inc_pri if sector==`sector' & year==2013 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priS`sector'2013_p25 = (`r(r1)')
_pctile inc_pri if sector==`sector' & year==2013 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priS`sector'2013_p50 = (`r(r1)')
_pctile inc_pri if sector==`sector' & year==2013 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priS`sector'2013_p75 = (`r(r1)')
matrix inc_priS`sector'2013_estat=`sector', inc_priS`sector'2013_mean, inc_priS`sector'2013_se, inc_priS`sector'2013_sd, inc_priS`sector'2013_cv,  inc_priS`sector'2013_p25,  inc_priS`sector'2013_p50, inc_priS`sector'2013_p75, inc_priS`sector'2013_N
matrix list inc_priS`sector'2013_estat
}

matrix  Inc_S_2013=inc_priS12013_estat\inc_priS22013_estat\inc_priS32013_estat\inc_priS42013_estat\inc_priS52013_estat\inc_priS62013_estat\inc_priS72013_estat\inc_priS82013_estat\inc_priS92013_estat
matrix list Inc_S_2013

* For 2017:
* ---------
foreach sector in 1 2 3 4 5 6 7 8 9 {
* 2017
svy: mean inc_pri  if sector==`sector' & year==2017
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
_pctile inc_pri if sector==`sector' & year==2017 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priS`sector'2017_p25 = (`r(r1)')
_pctile inc_pri if sector==`sector' & year==2017 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priS`sector'2017_p50 = (`r(r1)')
_pctile inc_pri if sector==`sector' & year==2017 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priS`sector'2017_p75 = (`r(r1)')
matrix inc_priS`sector'2017_estat=`sector', inc_priS`sector'2017_mean, inc_priS`sector'2017_se, inc_priS`sector'2017_sd, inc_priS`sector'2017_cv,  inc_priS`sector'2017_p25,  inc_priS`sector'2017_p50, inc_priS`sector'2017_p75, inc_priS`sector'2017_N
matrix list inc_priS`sector'2017_estat
}

matrix  Inc_S_2017=inc_priS12017_estat\inc_priS22017_estat\inc_priS32017_estat\inc_priS42017_estat\inc_priS52017_estat\inc_priS62017_estat\inc_priS72017_estat\inc_priS82017_estat\inc_priS92017_estat
matrix list Inc_S_2017

* For the balanced panel:
* -----------------------
 
foreach sector in 1 2 3 4 5 6 7 8 9 {
* Panel
svy: mean inc_pri  if sector==`sector' &  perpanel1317==1
 matrix list e(_N)
 matrix inc_priS`sector'Panel_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priS`sector'Panel_sd=  r(sd)
matrix list r(mean)
matrix inc_priS`sector'Panel_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priS`sector'Panel_cv=  r(cv)
matrix list r(se)
matrix inc_priS`sector'Panel_se=  r(se)
_pctile inc_pri if sector==`sector' &  perpanel1317==1 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priS`sector'Panel_p25 = (`r(r1)')
_pctile inc_pri if sector==`sector' &  perpanel1317==1 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priS`sector'Panel_p50 = (`r(r1)')
_pctile inc_pri if sector==`sector' &  perpanel1317==1 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priS`sector'Panel_p75 = (`r(r1)')
matrix inc_priS`sector'Panel_estat=`sector', inc_priS`sector'Panel_mean, inc_priS`sector'Panel_se, inc_priS`sector'Panel_sd, inc_priS`sector'Panel_cv,  inc_priS`sector'Panel_p25,  inc_priS`sector'Panel_p50, inc_priS`sector'Panel_p75, inc_priS`sector'Panel_N
matrix list inc_priS`sector'Panel_estat
}

matrix  Inc_S_Panel=inc_priS1Panel_estat\inc_priS2Panel_estat\inc_priS3Panel_estat\inc_priS4Panel_estat\inc_priS5Panel_estat\inc_priS6Panel_estat\inc_priS7Panel_estat\inc_priS8Panel_estat\inc_priS9Panel_estat
matrix list Inc_S_Panel

* Grangroup:
* ===========
tab grangrup year, column  

* For 2013:
* ---------
foreach grangrup in 0 1 2 3 4 5 6 7 8 9 {
* 2013
svy: mean inc_pri  if grangrup==`grangrup' & year==2013
 matrix list e(_N)
 matrix inc_priI`grangrup'2013_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priI`grangrup'2013_sd=  r(sd)
matrix list r(mean)
matrix inc_priI`grangrup'2013_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priI`grangrup'2013_cv=  r(cv)
matrix list r(se)
matrix inc_priI`grangrup'2013_se=  r(se)
_pctile inc_pri if grangrup==`grangrup' & year==2013 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priI`grangrup'2013_p25 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & year==2013 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priI`grangrup'2013_p50 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & year==2013 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priI`grangrup'2013_p75 = (`r(r1)')
matrix inc_priI`grangrup'2013_estat=`grangrup', inc_priI`grangrup'2013_mean, inc_priI`grangrup'2013_se, inc_priI`grangrup'2013_sd, inc_priI`grangrup'2013_cv,  inc_priI`grangrup'2013_p25,  inc_priI`grangrup'2013_p50, inc_priI`grangrup'2013_p75, inc_priI`grangrup'2013_N
matrix list inc_priI`grangrup'2013_estat
}

matrix  Inc_I_2013=inc_priI02013_estat\inc_priI12013_estat\inc_priI22013_estat\inc_priI32013_estat\inc_priI42013_estat\inc_priI52013_estat\inc_priI62013_estat\inc_priI72013_estat\inc_priI82013_estat\inc_priI92013_estat
matrix list Inc_I_2013

* For 2017:
* ---------
foreach grangrup in 0 1 2 3 4 5 6 7 8 9 {
* 2017
svy: mean inc_pri  if grangrup==`grangrup' & year==2017
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
_pctile inc_pri if grangrup==`grangrup' & year==2017 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priI`grangrup'2017_p25 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & year==2017 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priI`grangrup'2017_p50 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' & year==2017 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priI`grangrup'2017_p75 = (`r(r1)')
matrix inc_priI`grangrup'2017_estat=`grangrup', inc_priI`grangrup'2017_mean, inc_priI`grangrup'2017_se, inc_priI`grangrup'2017_sd, inc_priI`grangrup'2017_cv,  inc_priI`grangrup'2017_p25,  inc_priI`grangrup'2017_p50, inc_priI`grangrup'2017_p75, inc_priI`grangrup'2017_N
matrix list inc_priI`grangrup'2017_estat
}

matrix  Inc_I_2017=inc_priI02017_estat\inc_priI12017_estat\inc_priI22017_estat\inc_priI32017_estat\inc_priI42017_estat\inc_priI52017_estat\inc_priI62017_estat\inc_priI72017_estat\inc_priI82017_estat\inc_priI92017_estat
matrix list Inc_I_2017

* For the balanced panel:
* -----------------------
 
foreach grangrup in 0 1 2 3 4 5 6 7 8 9 {
* Panel
svy: mean inc_pri  if grangrup==`grangrup' &  perpanel1317==1
 matrix list e(_N)
 matrix inc_priI`grangrup'Panel_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priI`grangrup'Panel_sd=  r(sd)
matrix list r(mean)
matrix inc_priI`grangrup'Panel_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priI`grangrup'Panel_cv=  r(cv)
matrix list r(se)
matrix inc_priI`grangrup'Panel_se=  r(se)
_pctile inc_pri if grangrup==`grangrup' &  perpanel1317==1 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priI`grangrup'Panel_p25 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' &  perpanel1317==1 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priI`grangrup'Panel_p50 = (`r(r1)')
_pctile inc_pri if grangrup==`grangrup' &  perpanel1317==1 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priI`grangrup'Panel_p75 = (`r(r1)')
matrix inc_priI`grangrup'Panel_estat=`grangrup', inc_priI`grangrup'Panel_mean, inc_priI`grangrup'Panel_se, inc_priI`grangrup'Panel_sd, inc_priI`grangrup'Panel_cv,  inc_priI`grangrup'Panel_p25,  inc_priI`grangrup'Panel_p50, inc_priI`grangrup'Panel_p75, inc_priI`grangrup'Panel_N
matrix list inc_priI`grangrup'Panel_estat
}

matrix  Inc_I_Panel=inc_priI0Panel_estat\inc_priI1Panel_estat\inc_priI2Panel_estat\inc_priI3Panel_estat\inc_priI4Panel_estat\inc_priI5Panel_estat\inc_priI6Panel_estat\inc_priI7Panel_estat\inc_priI8Panel_estat\inc_priI9Panel_estat
matrix list Inc_I_Panel


* ISCO Skill-level:
* ==================
tab iscosklv year, column
tab iscosklv, nolabel

* For 2013:
* ---------
foreach iscosklv in 1 2 3 4 {
* 2013
svy: mean inc_pri  if iscosklv==`iscosklv' & year==2013
 matrix list e(_N)
 matrix inc_priSL`iscosklv'2013_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priSL`iscosklv'2013_sd=  r(sd)
matrix list r(mean)
matrix inc_priSL`iscosklv'2013_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priSL`iscosklv'2013_cv=  r(cv)
matrix list r(se)
matrix inc_priSL`iscosklv'2013_se=  r(se)
_pctile inc_pri if iscosklv==`iscosklv' & year==2013 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priSL`iscosklv'2013_p25 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & year==2013 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2013_p50 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & year==2013 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2013_p75 = (`r(r1)')
matrix inc_priSL`iscosklv'2013_estat=`iscosklv', inc_priSL`iscosklv'2013_mean, inc_priSL`iscosklv'2013_se, inc_priSL`iscosklv'2013_sd, inc_priSL`iscosklv'2013_cv,  inc_priSL`iscosklv'2013_p25,  inc_priSL`iscosklv'2013_p50, inc_priSL`iscosklv'2013_p75, inc_priSL`iscosklv'2013_N
matrix list inc_priSL`iscosklv'2013_estat
}

matrix  Inc_SL_2013=inc_priSL12013_estat\inc_priSL22013_estat\inc_priSL32013_estat\inc_priSL42013_estat
matrix list Inc_SL_2013

* For 2017:
* ---------
foreach iscosklv in 1 2 3 4 {
* 2017
svy: mean inc_pri  if iscosklv==`iscosklv' & year==2017
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
_pctile inc_pri if iscosklv==`iscosklv' & year==2017 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priSL`iscosklv'2017_p25 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & year==2017 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2017_p50 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' & year==2017 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priSL`iscosklv'2017_p75 = (`r(r1)')
matrix inc_priSL`iscosklv'2017_estat=`iscosklv', inc_priSL`iscosklv'2017_mean, inc_priSL`iscosklv'2017_se, inc_priSL`iscosklv'2017_sd, inc_priSL`iscosklv'2017_cv,  inc_priSL`iscosklv'2017_p25,  inc_priSL`iscosklv'2017_p50, inc_priSL`iscosklv'2017_p75, inc_priSL`iscosklv'2017_N
matrix list inc_priSL`iscosklv'2017_estat
}

matrix  Inc_SL_2017=inc_priSL12017_estat\inc_priSL22017_estat\inc_priSL32017_estat\inc_priSL42017_estat
matrix list Inc_SL_2017

* For the balanced panel:
* -----------------------
 
foreach iscosklv in 1 2 3 4 {
* Panel
svy: mean inc_pri  if iscosklv==`iscosklv' &  perpanel1317==1
 matrix list e(_N)
 matrix inc_priSL`iscosklv'Panel_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priSL`iscosklv'Panel_sd=  r(sd)
matrix list r(mean)
matrix inc_priSL`iscosklv'Panel_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priSL`iscosklv'Panel_cv=  r(cv)
matrix list r(se)
matrix inc_priSL`iscosklv'Panel_se=  r(se)
_pctile inc_pri if iscosklv==`iscosklv' &  perpanel1317==1 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priSL`iscosklv'Panel_p25 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' &  perpanel1317==1 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priSL`iscosklv'Panel_p50 = (`r(r1)')
_pctile inc_pri if iscosklv==`iscosklv' &  perpanel1317==1 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priSL`iscosklv'Panel_p75 = (`r(r1)')
matrix inc_priSL`iscosklv'Panel_estat=`iscosklv', inc_priSL`iscosklv'Panel_mean, inc_priSL`iscosklv'Panel_se, inc_priSL`iscosklv'Panel_sd, inc_priSL`iscosklv'Panel_cv,  inc_priSL`iscosklv'Panel_p25,  inc_priSL`iscosklv'Panel_p50, inc_priSL`iscosklv'Panel_p75, inc_priSL`iscosklv'Panel_N
matrix list inc_priSL`iscosklv'Panel_estat
}

matrix  Inc_SL_Panel=inc_priSL1Panel_estat\inc_priSL2Panel_estat\inc_priSL3Panel_estat\inc_priSL4Panel_estat
matrix list Inc_SL_Panel

* Educational Level:
* ==================
tab educ year, column 
tab educ, nolabel

* For 2013:
* ---------
foreach educ in 0 1 2 3 4 5  {
* 2013
svy: mean inc_pri  if educ==`educ' & year==2013
 matrix list e(_N)
 matrix inc_priE`educ'2013_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priE`educ'2013_sd=  r(sd)
matrix list r(mean)
matrix inc_priE`educ'2013_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priE`educ'2013_cv=  r(cv)
matrix list r(se)
matrix inc_priE`educ'2013_se=  r(se)
_pctile inc_pri if educ==`educ' & year==2013 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priE`educ'2013_p25 = (`r(r1)')
_pctile inc_pri if educ==`educ' & year==2013 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priE`educ'2013_p50 = (`r(r1)')
_pctile inc_pri if educ==`educ' & year==2013 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priE`educ'2013_p75 = (`r(r1)')
matrix inc_priE`educ'2013_estat=`educ', inc_priE`educ'2013_mean, inc_priE`educ'2013_se, inc_priE`educ'2013_sd, inc_priE`educ'2013_cv,  inc_priE`educ'2013_p25,  inc_priE`educ'2013_p50, inc_priE`educ'2013_p75, inc_priE`educ'2013_N
matrix list inc_priE`educ'2013_estat
}

matrix  Inc_E_2013=inc_priE02013_estat\inc_priE12013_estat\inc_priE22013_estat\inc_priE32013_estat\inc_priE42013_estat\inc_priE52013_estat
matrix list Inc_E_2013

* For 2017:
* ---------
foreach educ in 0 1 2 3 4 5 {
* 2017
svy: mean inc_pri  if educ==`educ' & year==2017
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
_pctile inc_pri if educ==`educ' & year==2017 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priE`educ'2017_p25 = (`r(r1)')
_pctile inc_pri if educ==`educ' & year==2017 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priE`educ'2017_p50 = (`r(r1)')
_pctile inc_pri if educ==`educ' & year==2017 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priE`educ'2017_p75 = (`r(r1)')
matrix inc_priE`educ'2017_estat=`educ', inc_priE`educ'2017_mean, inc_priE`educ'2017_se, inc_priE`educ'2017_sd, inc_priE`educ'2017_cv,  inc_priE`educ'2017_p25,  inc_priE`educ'2017_p50, inc_priE`educ'2017_p75, inc_priE`educ'2017_N
matrix list inc_priE`educ'2017_estat
}

matrix  Inc_E_2017=inc_priE02017_estat\inc_priE12017_estat\inc_priE22017_estat\inc_priE32017_estat\inc_priE42017_estat\inc_priE52017_estat
matrix list Inc_E_2017

* For the balanced panel:
* -----------------------
 
foreach educ in 0 1 2 3 4 5  {
* Panel
svy: mean inc_pri  if educ==`educ' &  perpanel1317==1
 matrix list e(_N)
 matrix inc_priE`educ'Panel_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priE`educ'Panel_sd=  r(sd)
matrix list r(mean)
matrix inc_priE`educ'Panel_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priE`educ'Panel_cv=  r(cv)
matrix list r(se)
matrix inc_priE`educ'Panel_se=  r(se)
_pctile inc_pri if educ==`educ' &  perpanel1317==1 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priE`educ'Panel_p25 = (`r(r1)')
_pctile inc_pri if educ==`educ' &  perpanel1317==1 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priE`educ'Panel_p50 = (`r(r1)')
_pctile inc_pri if educ==`educ' &  perpanel1317==1 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priE`educ'Panel_p75 = (`r(r1)')
matrix inc_priE`educ'Panel_estat=`educ', inc_priE`educ'Panel_mean, inc_priE`educ'Panel_se, inc_priE`educ'Panel_sd, inc_priE`educ'Panel_cv,  inc_priE`educ'Panel_p25,  inc_priE`educ'Panel_p50, inc_priE`educ'Panel_p75, inc_priE`educ'Panel_N
matrix list inc_priE`educ'Panel_estat
}

matrix  Inc_E_Panel=inc_priE0Panel_estat\inc_priE1Panel_estat\inc_priE2Panel_estat\inc_priE3Panel_estat\inc_priE4Panel_estat\inc_priE5Panel_estat
matrix list Inc_E_Panel

* Urban-Rural:
tab urban year,  column 
tab urban, nolabel

* For 2013:
* ---------
foreach urban in 0 1 {
* 2013
svy: mean inc_pri  if urban==`urban' & year==2013
 matrix list e(_N)
 matrix inc_priU`urban'2013_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priU`urban'2013_sd=  r(sd)
matrix list r(mean)
matrix inc_priU`urban'2013_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priU`urban'2013_cv=  r(cv)
matrix list r(se)
matrix inc_priU`urban'2013_se=  r(se)
_pctile inc_pri if urban==`urban' & year==2013 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priU`urban'2013_p25 = (`r(r1)')
_pctile inc_pri if urban==`urban' & year==2013 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priU`urban'2013_p50 = (`r(r1)')
_pctile inc_pri if urban==`urban' & year==2013 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priU`urban'2013_p75 = (`r(r1)')
matrix inc_priU`urban'2013_estat=`urban', inc_priU`urban'2013_mean, inc_priU`urban'2013_se, inc_priU`urban'2013_sd, inc_priU`urban'2013_cv,  inc_priU`urban'2013_p25,  inc_priU`urban'2013_p50, inc_priU`urban'2013_p75, inc_priU`urban'2013_N
matrix list inc_priU`urban'2013_estat
}

matrix  Inc_U_2013=inc_priU02013_estat\inc_priU12013_estat
matrix list Inc_U_2013

* For 2017:
* ---------
foreach urban in 0 1 {
* 2017
svy: mean inc_pri  if urban==`urban' & year==2017
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
_pctile inc_pri if urban==`urban' & year==2017 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priU`urban'2017_p25 = (`r(r1)')
_pctile inc_pri if urban==`urban' & year==2017 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priU`urban'2017_p50 = (`r(r1)')
_pctile inc_pri if urban==`urban' & year==2017 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priU`urban'2017_p75 = (`r(r1)')
matrix inc_priU`urban'2017_estat=`urban', inc_priU`urban'2017_mean, inc_priU`urban'2017_se, inc_priU`urban'2017_sd, inc_priU`urban'2017_cv,  inc_priU`urban'2017_p25,  inc_priU`urban'2017_p50, inc_priU`urban'2017_p75, inc_priU`urban'2017_N
matrix list inc_priU`urban'2017_estat
}

matrix  Inc_U_2017=inc_priU02017_estat\inc_priU12017_estat
matrix list Inc_U_2017

* For the balanced panel:
* -----------------------
 
foreach urban in 0 1  {
* Panel
svy: mean inc_pri  if urban==`urban' &  perpanel1317==1
 matrix list e(_N)
 matrix inc_priU`urban'Panel_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priU`urban'Panel_sd=  r(sd)
matrix list r(mean)
matrix inc_priU`urban'Panel_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priU`urban'Panel_cv=  r(cv)
matrix list r(se)
matrix inc_priU`urban'Panel_se=  r(se)
_pctile inc_pri if urban==`urban' &  perpanel1317==1 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priU`urban'Panel_p25 = (`r(r1)')
_pctile inc_pri if urban==`urban' &  perpanel1317==1 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priU`urban'Panel_p50 = (`r(r1)')
_pctile inc_pri if urban==`urban' &  perpanel1317==1 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priU`urban'Panel_p75 = (`r(r1)')
matrix inc_priU`urban'Panel_estat=`urban', inc_priU`urban'Panel_mean, inc_priU`urban'Panel_se, inc_priU`urban'Panel_sd, inc_priU`urban'Panel_cv,  inc_priU`urban'Panel_p25,  inc_priU`urban'Panel_p50, inc_priU`urban'Panel_p75, inc_priU`urban'Panel_N
matrix list inc_priU`urban'Panel_estat
}

matrix  Inc_U_Panel=inc_priU0Panel_estat\inc_priU1Panel_estat
matrix list Inc_U_Panel

* Geographic zone:
* ================
tab zone year, column  

tab zone, nolabel

* For 2013:
* ---------
foreach zone in 1 2 3 4  {
* 2013
svy: mean inc_pri  if zone==`zone' & year==2013
 matrix list e(_N)
 matrix inc_priZ`zone'2013_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priZ`zone'2013_sd=  r(sd)
matrix list r(mean)
matrix inc_priZ`zone'2013_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priZ`zone'2013_cv=  r(cv)
matrix list r(se)
matrix inc_priZ`zone'2013_se=  r(se)
_pctile inc_pri if zone==`zone' & year==2013 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priZ`zone'2013_p25 = (`r(r1)')
_pctile inc_pri if zone==`zone' & year==2013 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priZ`zone'2013_p50 = (`r(r1)')
_pctile inc_pri if zone==`zone' & year==2013 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priZ`zone'2013_p75 = (`r(r1)')
matrix inc_priZ`zone'2013_estat=`zone', inc_priZ`zone'2013_mean, inc_priZ`zone'2013_se, inc_priZ`zone'2013_sd, inc_priZ`zone'2013_cv,  inc_priZ`zone'2013_p25,  inc_priZ`zone'2013_p50, inc_priZ`zone'2013_p75, inc_priZ`zone'2013_N
matrix list inc_priZ`zone'2013_estat
}

matrix  Inc_Z_2013=inc_priZ12013_estat\inc_priZ22013_estat\inc_priZ32013_estat\inc_priZ42013_estat
matrix list Inc_Z_2013

* For 2017:
* ---------
foreach zone in 1 2 3 4 {
* 2017
svy: mean inc_pri  if zone==`zone' & year==2017
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
_pctile inc_pri if zone==`zone' & year==2017 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priZ`zone'2017_p25 = (`r(r1)')
_pctile inc_pri if zone==`zone' & year==2017 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priZ`zone'2017_p50 = (`r(r1)')
_pctile inc_pri if zone==`zone' & year==2017 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priZ`zone'2017_p75 = (`r(r1)')
matrix inc_priZ`zone'2017_estat=`zone', inc_priZ`zone'2017_mean, inc_priZ`zone'2017_se, inc_priZ`zone'2017_sd, inc_priZ`zone'2017_cv,  inc_priZ`zone'2017_p25,  inc_priZ`zone'2017_p50, inc_priZ`zone'2017_p75, inc_priZ`zone'2017_N
matrix list inc_priZ`zone'2017_estat
}

matrix  Inc_Z_2017=inc_priZ12017_estat\inc_priZ22017_estat\inc_priZ32017_estat\inc_priZ42017_estat
matrix list Inc_Z_2017

* For the balanced panel:
* -----------------------
 
foreach zone in 1 2 3 4 {
* Panel
svy: mean inc_pri  if zone==`zone' &  perpanel1317==1
 matrix list e(_N)
 matrix inc_priZ`zone'Panel_N= e(_N)
estat sd
matrix list r(sd)
matrix inc_priZ`zone'Panel_sd=  r(sd)
matrix list r(mean)
matrix inc_priZ`zone'Panel_mean=  r(mean)
estat cv
matrix list r(cv)
matrix inc_priZ`zone'Panel_cv=  r(cv)
matrix list r(se)
matrix inc_priZ`zone'Panel_se=  r(se)
_pctile inc_pri if zone==`zone' &  perpanel1317==1 [pweight=facpanel1317], p(25)
 di `r(r1)'
 matrix inc_priZ`zone'Panel_p25 = (`r(r1)')
_pctile inc_pri if zone==`zone' &  perpanel1317==1 [pweight=facpanel1317], p(50)
 di `r(r1)'
  matrix inc_priZ`zone'Panel_p50 = (`r(r1)')
_pctile inc_pri if zone==`zone' &  perpanel1317==1 [pweight=facpanel1317], p(75)
 di `r(r1)'
  matrix inc_priZ`zone'Panel_p75 = (`r(r1)')
matrix inc_priZ`zone'Panel_estat=`zone', inc_priZ`zone'Panel_mean, inc_priZ`zone'Panel_se, inc_priZ`zone'Panel_sd, inc_priZ`zone'Panel_cv,  inc_priZ`zone'Panel_p25,  inc_priZ`zone'Panel_p50, inc_priZ`zone'Panel_p75, inc_priZ`zone'Panel_N
matrix list inc_priZ`zone'Panel_estat
}

matrix  Inc_Z_Panel=inc_priZ1Panel_estat\inc_priZ2Panel_estat\inc_priZ3Panel_estat\inc_priZ4Panel_estat
matrix list Inc_Z_Panel


* ===============================================
* REPORTING ALL MATRIX:
* ===============================================
* Sector:
matrix list Inc_S_2013
matrix list Inc_S_2017
matrix list Inc_S_Panel
* Grangroup:
matrix list Inc_I_2013
matrix list Inc_I_2017
matrix list Inc_I_Panel
* ISCO Skill-level:
matrix list Inc_SL_2013
matrix list Inc_SL_2017
matrix list Inc_SL_Panel
* Educational Level:
matrix list Inc_E_2013
matrix list Inc_E_2017
matrix list Inc_E_Panel
* Urban-Rural:
matrix list Inc_U_2013
matrix list Inc_U_2017
matrix list Inc_U_Panel
* Geographic zone:
matrix list Inc_Z_2013
matrix list Inc_Z_2017
matrix list Inc_Z_Panel


* Graphics on wage:
* ==============================================================================

cd "C:\Users\\`c(username)'\OneDrive\Reportes - ENAHO\Graphs"

* Main Occupation Income by Sector: 
* ------------------------------------------------------------------------------
graph hbox lw if year==2013 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  title("Year 2013", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Sx13, replace)

graph hbox lw  if year==2017 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Sx17, replace)

graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white)) title("Balanced Panel 2013-2017", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SxT, replace)

graph combine Sx13 Sx17 SxT, rows(3) title("Yearly Income of the Main Ocupation by Sector", size(small)) ///
subtitle("ENAHO Panel 2013-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(SxC, replace)
graph export "S.eps", as(eps) replace  
graph save Sx13 WagebySector_13p, replace
graph save Sx17 WagebySector_17p, replace
graph save SxT WagebySector_Panel, replace
graph save SxC WagebySector_Combinedp, replace
graph close

* Main Occupation Income - By Occupation Group:
* ------------------------------------------------------------------------------

graph hbox lw if year==2013 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  title("Year 2013", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ix13, replace)

graph hbox lw  if year==2017 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ix17, replace)

graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white)) title("Balanced Panel 2013-2017", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(IxT, replace)

graph combine Ix13 Ix17 IxT, rows(3) title("Yearly Income of the Main Ocupation by ISCO Major Group", size(small)) ///
subtitle("ENAHO Panel 2013-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(IxC, replace)
graph export "I.eps", as(eps) replace  
graph save Ix13 WagebyISCO_13p
graph save Ix17 WagebyISCO_17p
graph save IxT WagebyISCO_Panel
graph save IxC WagebyISCO_Combinedp
graph close


* Main Occupation Income - By ISCO Skill Level:
* ------------------------------------------------------------------------------

graph hbox lw if year==2013 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  title("Year 2013", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SLx13, replace)

graph hbox lw  if year==2017 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SLx17, replace)

graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white)) title("Balanced Panel 2013-2017", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(SLxT, replace)

graph combine SLx13 SLx17 SLxT, rows(3) title("Yearly Income of the Main Ocupation by ISCO Skill Level", size(small)) ///
subtitle("ENAHO Panel 2013-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(SLxC, replace)
graph export "SL.eps", as(eps) replace  
graph save SLx13 WagebyISCOlv_13p
graph save SLx17 WagebyISCOlv_17p
graph save SLxT WagebyISCOlv_Panel
graph save SLxC WagebyISCOlv_Combinedp
graph close


* Main Occupation Income by Educational Level Achieved:
* ------------------------------------------------------------------------------
graph hbox lw if year==2013 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  title("Year 2013", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ex13, replace)

graph hbox lw  if year==2017 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ex17, replace)

graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white)) title("Balanced Panel 2013-2017", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(ExT, replace)

graph combine Ex13 Ex17 ExT, rows(3) title("Yearly Income of the Main Ocupation by Educational Level Achieved", size(small)) ///
subtitle("ENAHO Panel 2013-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(ExC, replace)
graph export "E.eps", as(eps) replace  
graph save Ex13 WagebyEdLevel_13p
graph save Ex17 WagebyEdLevel_17p
graph save ExT WagebyEdLevel_Panel
graph save ExC WagebyEdLevel_Combinedp
graph close

* Main Occupation Income - Urban vs. Rural:
* ------------------------------------------------------------------------------
graph hbox lw if year==2013 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white))  title("Year 2013", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ux13, replace)

graph hbox lw  if year==2017 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Ux17, replace)

graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white)) title("Balanced Panel 2013-2017", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(UxT, replace)

graph combine Ux13 Ux17 UxT, rows(3) title("Yearly Income of the Main Ocupation -  Urban vs. Rural", size(small)) ///
subtitle("ENAHO Panel 2013-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(UxC, replace)
graph export "U.eps", as(eps) replace  
graph save Ux13 WagebyUrban_13p
graph save Ux17 WagebyUrban_17p
graph save UxT WagebyUrban_Panel
graph save UxC WagebyUrban_Combinedp
graph close


* Main Occupation Income - By Geographic Zone:
* ------------------------------------------------------------------------------
graph hbox lw if year==2013 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  title("Year 2013", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Zx13, replace)

graph hbox lw  if year==2017 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  title("Year 2017", size(medium)) ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(Zx17, replace)

graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white)) title("Balanced Panel 2013-2017", size(medium))  ///
ylabel(, nogrid labsize(medsmall)) ytitle("Distribution at Individual Level (log of S/.)")   name(ZxT, replace)

graph combine Zx13 Zx17 ZxT, rows(3) title("Yearly Income of the Main Ocupation by Geographic Zone", size(small)) ///
subtitle("ENAHO Panel 2013-2017", size(small))  graphregion(color(white)) iscale(0.5) ysize(5) name(ZxC, replace)
graph export "Z.eps", as(eps) replace  
graph save Zx13 WagebyZone_13p, replace
graph save Zx17 WagebyZone_17p, replace
graph save ZxT WagebyZone_Panel, replace
graph save ZxC WagebyZone_Combinedp, replace
graph close

/*

* Main Occupation Income by Sector: 
* ------------------------------------------------------------------------------
graph hbar inc_pri if year==2013 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(S/.)")   name(Sr13, replace)
graph hbox lw if year==2013 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(Sx13, replace)

graph hbar inc_pri if year==2017 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(S/.)")   name(Sr17, replace)
graph hbox lw  if year==2017 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(Sx17, replace)

graph hbar inc_pri if perpanel1317==1 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(S/.)")   name(SrT, replace)
graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(SxT, replace)

graph combine Sr13 Sx13, name(S13, replace) graphregion(color(white)) title("Year 2013", size(small))
graph combine Sr17 Sx17, name(S17, replace) graphregion(color(white)) title("Year 2017", size(small))
graph combine SrT SxT, name(ST, replace)  graphregion(color(white)) title("Balanced Panel 2013-2017", size(small))
graph combine S13 S17 ST, rows(3) title("Yearly Income of the Main Ocupation by Sector", size(medsmall)) ///
subtitle("ENAHO Panel 2013-2017", size(vsmall))  graphregion(color(white)) iscale(0.6)
graph export "S.eps", as(eps) replace  

* Main Occupation Income - By Occupation Group:
* ------------------------------------------------------------------------------
graph hbar inc_pri if year==2013 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(S/.)")   name(Ir13, replace)
graph hbox lw if year==2013 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(Ix13, replace)

graph hbar inc_pri  if year==2017 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(S/.)")   name(Ir17, replace)
graph hbox lw  if year==2017 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(Ix17, replace)

graph hbar inc_pri if perpanel1317==1 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(S/.)")   name(IrT, replace)
graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(IxT, replace)

graph combine Ir13 Ix13, name(I13, replace) graphregion(color(white)) title("Year 2013", size(small))
graph combine Ir17 Ix17, name(I17, replace) graphregion(color(white)) title("Year 2017", size(small))
graph combine IrT IxT, name(IT, replace)  graphregion(color(white)) title("Balanced Panel 2013-2017", size(small))
graph combine I13 I17 IT, rows(3) title("Yearly Income of the Main Ocupation by ISCO Major Group", size(medsmall)) ///
subtitle("ENAHO Panel 2013-2017", size(vsmall))  graphregion(color(white)) iscale(0.6)
graph export "I.eps", as(eps) replace  
graph close


* Main Occupation Income - By ISCO Skill Level:
* ------------------------------------------------------------------------------
graph hbar inc_pri if year==2013 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level (S/.)")   name(SLr13, replace)
graph hbox lw if year==2013 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(SLx13, replace)

graph hbar inc_pri  if year==2017 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level (S/.)")   name(SLr17, replace)
graph hbox lw  if year==2017 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(SLx17, replace)

graph hbar inc_pri if perpanel1317==1 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level (S/.)")   name(SLrT, replace)
graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(iscosklv)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")   name(SLxT, replace)

graph combine SLr13 SLx13, name(SL13, replace) graphregion(color(white)) title("Year 2013", size(small))
graph combine SLr17 SLx17, name(SL17, replace) graphregion(color(white)) title("Year 2017", size(small))
graph combine SLrT SLxT, name(SLT, replace)  graphregion(color(white)) title("Balanced Panel 2013-2017", size(small))
graph combine SL13 SL17 SLT, rows(3) title("Yearly Income of the Main Ocupation by ISCO Skill Level", size(medsmall)) ///
subtitle("ENAHO Cross-Sections 2013-2017", size(vsmall))  graphregion(color(white)) iscale(0.6)
graph export "SL.eps", as(eps) replace  
graph close


* Main Occupation Income by Educational Level Achieved:
* ------------------------------------------------------------------------------
graph hbar inc_pri if year==2013 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(Er13, replace)
graph hbox lw if year==2013 [pweight = facpanel1317], over(educ)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(Ex13, replace)

graph hbar inc_pri if year==2017 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(Er17, replace)
graph hbox lw if year==2017 [pweight = facpanel1317], over(educ)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(Ex17, replace)

graph hbar inc_pri if perpanel1317==1 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(ErT, replace)
graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(educ)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(ExT, replace)

graph combine Er13 Ex13, name(E13, replace) graphregion(color(white)) title("Year 2013", size(small))
graph combine Er17 Ex17, name(E17, replace) graphregion(color(white)) title("Year 2017", size(small))
graph combine ErT ExT, name(ET, replace)  graphregion(color(white)) title("Balanced Panel 2013-2017", size(small))
graph combine E13 E17 ET, rows(3) title("Yearly Income of the Main Ocupation by Educational Level Achieved", size(medsmall)) ///
subtitle("ENAHO Panel 2013-2017", size(vsmall))  graphregion(color(white)) iscale(0.6)
graph export "E.eps", as(eps) replace 
graph close

* Main Occupation Income - Urban vs. Rural:
* ------------------------------------------------------------------------------
graph hbar inc_pri if year==2013 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(Ur13, replace)
graph hbox lw if year==2013 [pweight = facpanel1317], over(urban)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(Ux13, replace)

graph hbar inc_pri if year==2017 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(Ur17, replace)
graph hbox lw if year==2017 [pweight = facpanel1317], over(urban)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(Ux17, replace)

graph hbar inc_pri if perpanel1317==1 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(UrT, replace)
graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(urban)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(UxT, replace)

graph combine Ur13 Ux13, name(U13, replace) graphregion(color(white)) title("Year 2013", size(small))
graph combine Ur17 Ux17, name(U17, replace) graphregion(color(white)) title("Year 2017", size(small))
graph combine UrT UxT, name(UT, replace)  graphregion(color(white)) title("Balanced Panel 2013-2017", size(small))
graph combine U13 U17 UT, rows(3) title("Yearly Income of the Main Ocupation -  Urban vs. Rural", size(medsmall)) ///
subtitle("ENAHO Panel 2013-2017", size(vsmall))  graphregion(color(white)) iscale(0.6)
graph export "U.eps", as(eps) replace 
graph close

* Main Occupation Income - By Geographic Zone:
* ------------------------------------------------------------------------------
graph hbar inc_pri if year==2013 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(Zr13, replace)
graph hbox lw if year==2013 [pweight = facpanel1317], over(zone)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(Zx13, replace)

graph hbar inc_pri if year==2017 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(Zr17, replace)
graph hbox lw if year==2017 [pweight = facpanel1317], over(zone)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(Zx17, replace)

graph hbar inc_pri if perpanel1317==1 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average at Individual Level(log of S/.)")   name(ZrT, replace)
graph hbox lw if perpanel1317==1 [pweight = facpanel1317], over(zone)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Distribution at Individual Level (log of S/.)")  name(ZxT, replace)

graph combine Zr13 Zx13, name(Z13, replace) graphregion(color(white)) title("Year 2013", size(small))
graph combine Zr17 Zx17, name(Z17, replace) graphregion(color(white)) title("Year 2017", size(small))
graph combine ZrT ZxT, name(ZT, replace)  graphregion(color(white)) title("Balanced Panel 2013-2017", size(small))
graph combine Z13 Z17 ZT, rows(3) title("Yearly Income of the Main Ocupation by Geographic Zone", size(medsmall)) ///
subtitle("ENAHO Panel 2013-2017", size(vsmall))  graphregion(color(white)) iscale(0.6)
graph export "Z.eps", as(eps) replace 
graph close


* Prior graphs:
* -----------------------------------------------------------------------------


* By Educational Level Achieved
* =============================================================================

* Total Income by Educational Level Achieved: 
graph hbar inc_total [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(Et1, replace)
graph hbox inc_total [pweight = facpanel1317], over(educ)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Et2, replace)
graph hbar inc_total  if inc_total<100000 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Et3, replace)
graph hbox inc_total  if inc_total<100000 [pweight = facpanel1317], over(educ) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Et4, replace)
graph combine Et1 Et2 Et3 Et4, title("Monthly Total Income") ///
 subtitle("By Educational Level Achieved", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "Et.eps", as(eps) replace  

* Main Occupation Income by Educational Level Achieved: 
graph hbar inc_pri [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(EI1, replace)
graph hbox inc_pri [pweight = facpanel1317], over(educ)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(EI2, replace)
graph hbar inc_pri  if inc_total<100000 [pweight = facpanel1317], over(educ)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(EI3, replace)
graph hbox inc_pri  if inc_total<100000 [pweight = facpanel1317], over(educ) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(EI4, replace)
graph combine EI1 EI2 EI3 EI4, title("Monthly Income of the Main Ocupation") ///
 subtitle("By Educational Level Achieved", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "EI.eps", as(eps) replace  
  
  
* By Sector:
* ==============================================================================
* Total Income by Sector:
graph hbar inc_total [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(St1, replace)
graph hbox inc_total [pweight = facpanel1317], over(sector)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(St2, replace)
graph hbar inc_total  if inc_total<100000 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(St3, replace)
graph hbox inc_total  if inc_total<100000 [pweight = facpanel1317], over(sector) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(St4, replace)
graph combine St1 St2 St3 St4, title("Monthly Total Income") ///
 subtitle("By Sector", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "St.eps", as(eps) replace  


* Main Occupation Income by Sector: 
graph hbar inc_pri [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(SI1, replace)
graph hbox inc_pri [pweight = facpanel1317], over(sector)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(SI2, replace)
graph hbar inc_pri  if inc_pri<100000 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(SI3, replace)
graph hbox inc_pri  if inc_pri<100000 [pweight = facpanel1317], over(sector) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(SI4, replace)
graph combine SI1 SI2 SI3 SI4, title("Monthly Income of the Main Ocupation") ///
 subtitle("By Sector", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "SI.eps", as(eps) replace  

* By ISIC Grand Group:
* ==============================================================================
* Total Income by Sector:
graph hbar inc_total [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(Gt1, replace)
graph hbox inc_total [pweight = facpanel1317], over(grangrup)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Gt2, replace)
graph hbar inc_total  if inc_total<100000 [pweight = facpanel1317], over(grangrup)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Gt3, replace)
graph hbox inc_total  if inc_total<100000 [pweight = facpanel1317], over(grangrup) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Gt4, replace)
graph combine Gt1 Gt2 Gt3 Gt4, title("Monthly Total Income") ///
 subtitle("By Sector", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
*  graph export "Gt.eps", as(eps) replace  


* Main Occupation Income by Sector: 
graph hbar inc_pri [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(SI1, replace)
graph hbox inc_pri [pweight = facpanel1317], over(sector)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(SI2, replace)
graph hbar inc_pri  if inc_pri<100000 [pweight = facpanel1317], over(sector)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(SI3, replace)
graph hbox inc_pri  if inc_pri<100000 [pweight = facpanel1317], over(sector) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(SI4, replace)
graph combine SI1 SI2 SI3 SI4, title("Monthly Income of the Main Ocupation") ///
 subtitle("By Sector", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "SI.eps", as(eps) replace  
  
* By Zone:
* ==============================================================================
* Total Income by Zone: 
graph hbar inc_total [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(Zt1, replace)
graph hbox inc_total [pweight = facpanel1317], over(zone)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Zt2, replace)
graph hbar inc_total  if inc_total<100000 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Zt3, replace)
graph hbox inc_total  if inc_total<100000 [pweight = facpanel1317], over(zone) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(Zt4, replace)
graph combine Zt1 Zt2 Zt3 Zt4, title("Monthly Total Income") ///
 subtitle("By Geographic Zone", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "Zt.eps", as(eps) replace  


* Main Occupation Income by Zone:
graph hbar inc_pri [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")   name(ZI1, replace)
graph hbox inc_pri [pweight = facpanel1317], over(zone)   ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(ZI2, replace)
graph hbar inc_pri  if inc_pri<100000 [pweight = facpanel1317], over(zone)  ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(ZI3, replace)
graph hbox inc_pri  if inc_pri<100000 [pweight = facpanel1317], over(zone) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(ZI4, replace)
graph combine ZI1 ZI2 ZI3 ZI4, title("Monthly Income of the Main Ocupation") ///
 subtitle("By Geographic Zone", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "ZI.eps", as(eps) replace  



* Urban vs. Rural
* ==============================================================================

* Total Income - Urban vs. Rural: 
graph hbar inc_total [pweight = facpanel1317], over(urban) ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URt1, replace)
graph hbox inc_total [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URt2, replace)
graph hbar inc_total if inc_total<100000 [pweight = facpanel1317], over(urban) ///
 graphregion(color(white)) caption("For Incomes < S/.100,000")   ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URt3, replace)
graph hbox inc_total  if inc_total<100000 [pweight = facpanel1317], over(urban) ///
 graphregion(color(white))  caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URt4, replace)
graph combine URt1 URt2 URt3 URt4, title("Monthly Total Income") ///
 subtitle("Urban vs. Rural", size(small))  t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "URt.eps", as(eps) replace  

* Main Occupation Income - Urban vs. Rural:

graph hbar inc_pri [pweight = facpanel1317], over(urban) ///
 graphregion(color(white))  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URI1, replace)
graph hbox inc_pri [pweight = facpanel1317], over(urban) ///
 graphregion(color(white)) ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URI2, replace)
graph hbar inc_pri if  inc_pri<100000  [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white)) caption("For Incomes < S/.100,000")  ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URI3, replace)
graph hbox inc_pri  if  inc_pri<100000 [pweight = facpanel1317], over(urban)  ///
 graphregion(color(white)) caption("For Incomes < S/.100,000") ///
ylabel(, nogrid) ytitle("Average by Individual (S/.)")  name(URI4, replace)
graph combine URI1 URI2 URI3 URI4, title("Monthly Income of the Main Ocupation") ///
 subtitle("Urban vs. Rural", size(small)) t2title("ENAHO Panel 2013-2017", size(small)) graphregion(color(white)) 
  graph export "URI.eps", as(eps) replace  
*/

* Mincer Equation:
* ----------------

gen exper2=exper^2
global id id
global t year
global ylist lwage
global xlist exper exper2 age race sector sch male urban zone

describe $id $t $ylist $xlist
summarize $id $t $ylist $xlist

* Set data as panel data
sort $id $t
xtset $id $t
xtdescribe
xtsum $id $t $ylist $xlist

global xlt exper exper2 sch 
global xlist exper exper2 i.race i.sector sch male urban ib4.zone

* Pooled OLS estimator
reg $ylist $xlt
estimates store m1

reg $ylist $xlist
estimates store m1c

* Between estimator
xtreg $ylist $xlt, be
estimates store m2
xtreg $ylist $xlist, be
estimates store m2c

* Fixed effects or within estimator
xtreg $ylist $xlt, fe
estimates store m3
xtreg $ylist $xlist, fe
estimates store m3c

* Random effects estimator
xtreg $ylist $xlt, re theta
estimates store m4
xtreg $ylist $xlist, re theta
estimates store m4c

esttab m1 m2 m3 m4 m1c m2c m3c m4c , label b(3) se(3) ///
                    stats(N r2 r2_w r2_o r2_b sigma sigma_u sigma_e rho, ///
					fmt(0 3 3 3 3)) wide star(* 0.10 ** 0.05 *** 0.01) ///
					mtitle("Pooled OLS" "Between" "Fixed" "Random" "Pooled OLS" "Between" "Fixed" "Random") ///
					title("Sample Mincer estimation")

					
esttab m1 m2 m3 m4 using Mincer.tex , replace label b(3) se(3) ///
                    stats(N r2 r2_w r2_o r2_b sigma sigma_u sigma_e rho, ///
					fmt(0 3 3 3 3)) wide star(* 0.10 ** 0.05 *** 0.01) ///
					mtitle("Pooled OLS" "Between" "Fixed" "Random") ///
					title("Sample Mincer estimation")
					
esttab m1c m2c m3c m4c using MincerC.tex , replace  label b(3) se(3) ///
                    stats(N r2 r2_w r2_o r2_b sigma sigma_u sigma_e rho, ///
					fmt(0 3 3 3 3)) wide star(* 0.10 ** 0.05 *** 0.01) ///
					mtitle("Pooled OLS" "Between" "Fixed" "Random") ///
					title("Sample Extd. Mincer estimation")

					
* Previous calculations might be innacurate since we are ignoring survey design:

svyset conglome [pweight = facpanel1317], strata(estrato) /* || vivienda */ 

svy: reg $ylist $xlt
estimates store sm1

svy: reg $ylist $xlist
estimates store sm1c

esttab m1 m1c sm1 sm1c , label b(3) se(3) ///
                         stats(F r2 N, fmt(3 3 0)) wide star(* 0.10 ** 0.05 *** 0.01) ///
						 mtitle("Sample" "Sample" "Survey" "Survey") ///
						 title("Survey Mincer estimation (Pooled OLS)")

esttab m1 m1c sm1 sm1c using MincerSvy.tex , replace label b(3) se(3) ///
                         stats(F r2 N, fmt(3 3 0)) wide star(* 0.10 ** 0.05 *** 0.01) ///
						 mtitle("Sample" "Sample" "Survey" "Survey") ///
						 title("Survey Mincer estimation (Pooled OLS)")
						 
* 

xtset $id $t

xtreg $ylist $xlt, fe vce(cluster conglome)
estimates store m3
xtreg $ylist $xlist, fe vce(cluster conglome)
estimates store m3c						

esttab m3 m3c , label b(3) se(3) ///
                stats(F r2 N, fmt(3 3 0)) star(* 0.10 ** 0.05 *** 0.01) ///
			    title("Survey Mincer estimation (Pooled OLS)") keep(exper exper2 sch)
				
forvalues s=1/8{
	
xtreg $ylist $xlt if estrato==`s', fe vce(cluster conglome)
estimates store m3_`s'
xtreg $ylist $xlist if estrato==`s', fe vce(cluster conglome)
estimates store m3c_`s'	
	
}				
				
						

esttab m3_1 m3_2 m3_3 m3_4 m3_5 m3_6 m3_7 m3_8  , label b(3) se(3) ///
                stats(F r2 N, fmt(3 3 0)) star(* 0.10 ** 0.05 *** 0.01) ///
			    title("Survey Mincer estimation (Pooled OLS)") keep(exper exper2 sch)				

esttab m3c_1 m3c_2 m3c_3 m3c_4 m3c_5 m3c_6 m3c_7 m3c_8  , label b(3) se(3) ///
                stats(F r2 N, fmt(3 3 0)) star(* 0.10 ** 0.05 *** 0.01) ///
			    title("Survey Mincer estimation (Pooled OLS)") keep(exper exper2 sch)					
				
				