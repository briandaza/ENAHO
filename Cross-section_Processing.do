/* ---------------------------------------------------------------------------
             Processing ENAHO Cross-Section Micro Data (2004 - 2020)
  
 Brian Daza - bdaza@umich.edu - bdaza.github.io      This version: 01-Apr-2021 
==============================================================================

- Defines and cleanes some variables.
- To do: 
  Translate commands and labels (probably do a bilingual version).  
  Analyze more variables.
  k: Look how to get the monetary variables in real units.
----------------------------------------------------------------------------- */

* Preparing the environment:												   
clear
global mdir "C:\Users\dazav\Dropbox (Personal)\Datasets\ENAHO"

* Datasets directory:
global output "$mdir\Clean"
global post "$mbd\Products"

* Datasets directory:
global mbd "$mdir\Raw"

* Folder for ISCO-88
global iscofolder "$mbd\2017\603-Modulo05"

cd "$output"


* Open the raw dataset:
use "$output\base_cs_enaho_raw.dta", clear

* Generamos algunas variables dentro del hogar:
* ---------------------------------------------

* Pobreza:

gen poor_ext = (pobreza == 1)
gen poor     = (pobreza <= 2)
gen no_poor  = (pobreza == 3)

* Indicadores con la metodología de Aragon y Rud (AEJ:EP, 2013)

gen y_raw = ingmo1hd/mieperho/12
gen y     = inghog2d/mieperho/12
gen exp   = gashog2d/mieperho/12

gen y_rel   =   y/linea
gen exp_rel = exp/linea

* Consumo por tipo:
*Tipo 1: alimentación 
*Tipo 2: ropa
*Tipo 3: vivienda, combustibles y servicios
*Tipo 4: mobiliario y mantenimiento del hogar
*Tipo 5: salud
*Tipo 6: transportes y comunicaciones
*Tipo 7: ocio, educación, y cultura

egen exp_1 = rowtotal(gru11hd) 
egen exp_2 = rowtotal(gru21hd)
egen exp_3 = rowtotal(gru31hd)
egen exp_4 = rowtotal(gru41hd)
egen exp_5 = rowtotal(gru51hd)
egen exp_6 = rowtotal(gru61hd)
egen exp_7 = rowtotal(gru71hd)

* Etiquetas de las variables generadas:

label var poor     "Hogar pobre"
label var poor_ext "Hogar pobre extremo"
label var no_poor  "Hogar no pobre"

label var exp_1 "Gasto en alimentación"
label var exp_2 "Gasto en ropa"
label var exp_3 "Gasto en vivienda, combustibles y servicios"
label var exp_4 "Gasto en mobiliario y mantenimiento del hogar"
label var exp_5 "Gasto en salud"
label var exp_6 "Gasto en transportes y comunicaciones"
label var exp_7 "Gasto en ocio, educación, y cultura"

label var linea "Linea de pobreza total"
label var linpe "Linea de pobreza de alimentos"

label var y_raw "Ingreso monetario del hogar per cápita bruto (mensual, PEN corrientes)"
label var y     "Ingreso monetario del hogar per cápita neto (mensual, PEN corrientes)"
label var exp   "Gasto total per cápita (mensual, PEN corrientes)"

label var y_rel   "Ingreso del hogar pc relativo a la linea de pobreza"
label var exp_rel "Gasto del hogar pc relativo a la linea de pobreza"

* For comparison with Panel:
* ==============================================================================

* Education level:
label define niveduc 0 "No level" 1 "Primary" 2 "Secondary" 3 "Superior non-university" 4 "Superior university" 5 "Postgraduated" 
gen educ=.
replace educ=0 if p301a==1 | p301a==2
replace educ=1 if p301a==3 | p301a==4
replace educ=2 if p301a==5 | p301a==6
replace educ=3 if p301a==7 | p301a==8
replace educ=4 if p301a==9 | p301a==10
replace educ=5 if p301a==11
label values educ niveduc
label variable educ "Education Level"

* Schooling achieved(years)
gen sch=.
replace sch=0  if p301a==1 | p301a==2 					                                                            // Without level or initial level
replace sch=0  if p301a==3 & (p301b==0 & p301c==0)																    // Initial level
replace sch=1  if (p301a==3 & p301b==1) | (p301a==3 & p301c==1) | (p301a==4 & p301b==1) | (p301a==4 & p301c==1)     // 1 years  
replace sch=2  if (p301a==3 & p301b==2) | (p301a==3 & p301c==2) | (p301a==4 & p301b==2) | (p301a==4 & p301c==2)     // 2 years 
replace sch=3  if (p301a==3 & p301b==3) | (p301a==3 & p301c==3) | (p301a==4 & p301b==3) | (p301a==4 & p301c==3)     // 3 years 
replace sch=4  if (p301a==3 & p301b==4) | (p301a==3 & p301c==4) | (p301a==4 & p301b==4) | (p301a==4 & p301c==4)     // 4 years 
replace sch=5  if (p301a==3 & p301b==5) | (p301a==3 & p301c==5) | (p301a==4 & p301b==5) | (p301a==4 & p301c==5)     // 5 years 
replace sch=6  if (p301a==3 & p301b==6) | (p301a==3 & p301c==6) | (p301a==4 & p301b==6) | (p301a==4 & p301c==6)     // 6 years 
replace sch=7  if (p301a==5 & p301b==1) | (p301a==6 & p301b==1)                                                     // 7 years 
replace sch=8  if (p301a==5 & p301b==2) | (p301a==6 & p301b==2)   											        // 8 years 
replace sch=9  if (p301a==5 & p301b==3) | (p301a==6 & p301b==3)   												    // 9 years 
replace sch=10 if (p301a==5 & p301b==4) | (p301a==6 & p301b==4)   												    // 10 years 
replace sch=11 if (p301a==5 & p301b==5) | (p301a==6 & p301b==5)   												    // 11 years 
replace sch=12 if (p301a==6 & p301b==6) 	         																	// Secondary level
replace sch=12 if (p301a==7 & p301b==1) | (p301a==8 & p301b==1) | (p301a==9 & p301b==1) | (p301a==10 & p301b==1)   // 12 years 
replace sch=13 if (p301a==7 & p301b==2) | (p301a==8 & p301b==2) | (p301a==9 & p301b==2) | (p301a==10 & p301b==2)   // 13 years 
replace sch=14 if (p301a==7 & p301b==3) | (p301a==8 & p301b==3) | (p301a==9 & p301b==3) | (p301a==10 & p301b==3)   // 14 years 
replace sch=15 if (p301a==7 & p301b==4) | (p301a==8 & p301b==4) | (p301a==9 & p301b==4) | (p301a==10 & p301b==4)   // 15 years 
replace sch=16 if (p301a==7 & p301b==5) | (p301a==8 & p301b==5) | (p301a==9 & p301b==5) | (p301a==10 & p301b==5)   // 16 years 
replace sch=17 if (p301a==9 & p301b==6) | (p301a==10 & p301b==6) | (p301a==11 & p301b==1)
replace sch=18 if (p301a==9 & p301b==7) | (p301a==10 & p301b==7) | (p301a==11 & p301b==2)
label variable sch "Education level (years) "

* Main Occupation Income
egen inc_pri = rowtotal(i524a1 d529t i530a d536)						

* Secondary Occupation Income
egen inc_sec = rowtotal(i538a1 d540t i541a d543)

* Total labor Income
egen inc_lab = rowtotal(inc_pri inc_sec)  					

* Extraordinary Income (grati., bonus, CTS, etc)
rename d544t inc_extra

* Total income 
egen inc_total = rowtotal(inc_lab inc_extra) 
replace inc_total=. if inc_lab==0 | inc_lab==. // It could happen that there is a missing at labor income and a payment of CTS

* Monthly versions:

gen mon_pri = inc_pri/12 
gen mon_sec = inc_sec/12 
gen mon_lab = inc_lab/12
gen mon_extra = inc_extra/12
gen mon_total = inc_total/12

* Logarithm of wage from main occupation income
gen lw=ln(inc_pri+1)
replace lw=0 if lw==.

* Logarithm of total wage
gen lwage=ln(inc_total+1)
replace lwage=0 if lwage==.

* Sector of Principal Occupation:
* p506_`i' : CIIU r3
* p506r4_`i' : CIIU r4

gen sector=.
label variable sector "Sector Principal Occupation"

replace sector=1 if p506r4>=100 & p506r4<300   // OK
replace sector=2 if p506r4>=300 & p506r4<500   // OK
replace sector=3 if p506r4>=500 & p506r4<1000  // OK
replace sector=4 if p506r4>=1000 & p506r4<3500 // OK
replace sector=5 if p506r4>=3500 & p506r4<4000 // OK
replace sector=6 if p506r4>=4000 & p506r4<4500 // OK
replace sector=7 if p506r4>=4500 & p506r4<4900 // OK
replace sector=8 if p506r4>=8400 & p506r4<8500 // OK
replace sector=9 if p506r4>=4900 & p506r4<8400 // OK
replace sector=9 if p506r4>=8500 & p506r4<9998 // OK

lab def sector 1 "Agriculture" 2 "Fishing" 3 "Mining" ///
4 "Manufacture" 5 "Electricity and Water" 6 "Construction" 7 "Commerce" ///
8 "Government" 9 "Services"
lab val sector sector
 
* Gender
recode p207 (2=0 "Female") (1=1 "Male"), gen(male)
label variable male "Gender"

* Race or ethnic group
recode p558c (5=1 "White") (6=2 "Half-Blood") (1/3 9 =3 "Peruvian Native") (4=4 "Afroperuvian") (7=5 "Other") (8=.), gen(race)
label variable race "Race or ethnic group"

* Area
recode estrato (1/5=1 "Urban") (6/8=0 "Rural"), gen(urban) 
label variable urban "Urban"

* Zone
recode dominio (1/3=1 "Coast") (4/6=2 "Highlands") (7/7=3 "Jungle") (8/8=4 "Lima Metropolis"), gen(zone)
label var zone "Zone"

* Cod ocupa:

gen codocupa=p505

* Did you live in the district five years ago?

recode p401f (1 = 1) (2/3 = 0), gen(vivdist)

* Defining variables we will use:
rename p208a age
* Weekly earnings
gen earn = mon_total/4 // Ingresos laborales totales. Falta deflactar anualmente
label variable earn "Earnings"
* Three age groups:
recode age (15/24=1 "15-24")(25/44=2 "25-44")(45/64=3 "45-64"), gen(age_gr3)
label variable age "Age"
label variable age_gr3 "Age group"
* Four education groups:
recode p301a (1/2=0 "No schooling")(3/4=1 "Primary")(5/6=2 "Secondary")(7/12=3 "Tertiary"), gen(edu) // Why is there a category "12" in 2017-2018?
label variable edu "Education Level"


save "$output\base_cs_enaho.dta", replace

/* To do k:
* We use the IPC as a deflator
preserve 
tempfile IPCset   /* create a temporary file */
import excel using "$mbd/IPC - Anual 2000-2018", clear cellrange(A3:B21)
rename A anio
rename B IPC_variation
sort anio
gen anion=-anio
gen IPC = 100
replace IPC=IPC[_n-1]*(1+IPC_variation/100) if anio>2009
sort anion 
replace IPC=IPC[_n-1]/(1+IPC_variation[_n-1]/100) if anio<2009
drop anion
sort anio
drop if anio<2004 

label variable IPC "Price Index for Consumers (2009=100)"

save "`IPCset'"      /* save memory into the temporary file */
restore

merge m:1 anio using "`IPCset'", nogenerate

gen real_earn = earn*100/IPC

label variable real_earn "Weekly total labor earnings (in 2009 soles)"
*/

* Including ISCO:
* --------------

* Opening the table with ISCO codes from the year 88:
use  "$iscofolder\enaho-tabla-ciuo-88.dta", clear

* At ENAHO, we do no have information regarding variety. 
* So, we might drop out variety in order to have a mergeable database. 
* This database will have information regarding "grangrup", "grupo" and "subgrupo". 

* Reduce the data confirming each 'codocupa' is just in one combination of 'grangrup', 'grupo' & 'subgrupo': 
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


save "$output\isco-88.dta", replace

* Merge with the older data set:

use "$output\base_cs_enaho.dta", clear

merge m:1 codocupa using "$output\isco-88.dta"
drop if _merge==2
drop _merge

save "$output\base_cs_enaho.dta", replace
