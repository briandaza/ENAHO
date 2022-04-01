/* ---------------------------------------------------------------------------
      Preparación de base de datos a partir de los microdatos de ENAHO
                                2004 - 2020
  
  
 Brian Daza - bdaza@umich.edu - bdaza.github.io      Esta version:  14-11-2021 
==============================================================================

* Notas:
- Las bases de datos están descargadas tal cual INEI las ha subido a su página. 
- Los archivos .zip han sido descomprimidos en carpetas agrupadas por año.
- EL único cambio manual ha sido el cambio de nombre de "498_Modulo02" a 
"498-Modulo02" en el año 2015.

He separado este do-file en dos 'Cross-section_Merge_and_encoding' y
'Cross-section_Processing'. Fijate en ellos, este ya no esta actualizado.

                                                                              */

* Alistando el Entorno
																			   
clear
global mdir "C:\Users\dazav\Dropbox (Personal)\Datasets\ENAHO"

* Directorio de las bases de datos:
global mbd "$mdir\Raw"

* Raíz del nombre de los módulos por año:
global r2004 "\280"
global r2005 "\281"
global r2006 "\282"
global r2007 "\283"
global r2008 "\284"
global r2009 "\285"
global r2010 "\279"
global r2011 "\291"
global r2012 "\324"
global r2013 "\404"
global r2014 "\440"
global r2015 "\498"
global r2016 "\546"
global r2017 "\603"
global r2018 "\634"
global r2019 "\687"
global r2020 "\737"

* Folder for ISCO-88
global iscofolder "$mbd\2017\603-Modulo05"

* Output
global output "$mdir\Clean"
global post "$mbd\Products"

cd "$output"

* -----------------------------------------------------------------------------
* 		              SÍNTESIS DE LA BASE DE DATOS
* =============================================================================

*          Anualmente          :
* ==============================

local listaanios 2020 2019 2018 2017 2016 2015 2014 2013 2012 2011 2010 2009 2008 2007 2006 2005 2004

foreach x of local listaanios {
* Primero uniremos (merge) las bases de datos a nivel de personas:
* ---------------------------------------------------------------

* Módulo 2 (Características de los individuos)

use "$mbd\\`x'${r`x'}-Modulo02\enaho01-`x'-200.dta", clear

if `x' >= 2016 {
       keep nconglome conglome vivienda hogar ubigeo dominio estrato codperso p201p p203* p204 p205 p206 p207 p208* p210 p211* p212 p213 p214 facpob07 mes
       }
else if `x' < 2016 {
       keep conglome vivienda hogar ubigeo dominio estrato codperso p201p p203* p204 p205 p206 p207 p208* p210 p211* p212 p213 p214 facpob07 mes
       }   
	   
	   * Corregimos la vivienda, el codperso y el conglome del Modulo 02 de 2004 a 2006
	   
	   if inlist(`x',2004,2005,2006,2012,2013,2014) {
	   destring codperso, replace
	   tostring codperso, replace
	   replace codperso="0"+codperso if length(codperso)==1
	   
	   destring vivienda, replace
	   tostring vivienda, replace
	   replace vivienda="0"+vivienda if length(vivienda)==1
	   replace vivienda="0"+vivienda if length(vivienda)==2
	   
	   destring conglome, replace
	   tostring conglome, replace
	   replace conglome="0"+conglome if length(conglome)==1
	   replace conglome="0"+conglome if length(conglome)==2
	   replace conglome="0"+conglome if length(conglome)==3	   
	   }


* Módulo 3 (Educación)

merge 1:1 conglome vivienda hogar codperso using "$mbd\\`x'${r`x'}-Modulo03\enaho01a-`x'-300.dta", keepusing( ubigeo codinfor p300* p301* p302* p303* p304* p305 p306 p307 p308* p313 p314* p209 fac*)

drop _merge

* Módulo 4 (Salud)

if `x' >= 2014 {
       merge 1:1 conglome vivienda hogar codperso using "$mbd\\`x'${r`x'}-Modulo04\enaho01a-`x'-400.dta", keepusing(ubigeo p401h* p401f p401g factor07)
	   drop _merge
       }
else if `x' < 2014 {
	   * Módulo de salud no tiene información discapacidad ni indica si vivía en este distrito hace 5 años
       } 
	   
* Módulo 5 (Empleo)

if `x' >= 2012 {
       merge 1:1 conglome vivienda hogar codperso using "$mbd\\`x'${r`x'}-Modulo05\enaho01a-`x'-500.dta", keepusing(ocu500 codinfor p501 p520 p502 p503 p504* p505* p506* p516* p507 p511* p513* p515* p545 p558c p558d* fac500a  i524* d529* i530* d536 i538* d540* i541* d543 d544t )
       }
else if `x' < 2012 {
	   merge 1:1 conglome vivienda hogar codperso using "$mbd\\`x'${r`x'}-Modulo05\enaho01a-`x'-500.dta", keepusing(ocu500 codinfor p501 p520 p502 p503 p504* p505* p506* p516* p507 p511* p513* p515* p545 fac500a  i524* d529* i530* d536 i538* d540* i541* d543 d544t )
* if `x' == 2011 rename fac500a7 fac500a
} 

drop _merge 

save "$output\indi`x'.dta", replace

* Datos a nivel vivienda
* ---------------------------------------------------------------

* Modulo 01:
use "$mbd\\`x'${r`x'}-Modulo01\enaho01-`x'-100.dta", clear

* Aquí está la info de centro poblado con más detalle según el diccionario. Pero no lo veo en la BD

if `x' == 2020 {
       keep nconglome conglome vivienda hogar ubigeo dominio estrato panel p101 p102 p103 p103a p104 p104a p105a p110* p111* p112* p113* p114* p117* nbi* factor07 /*longitud latitud */
       }
else if `x' >= 2016 & `x' <= 2019 {
       keep nconglome conglome vivienda hogar ubigeo dominio estrato panel p101 p102 p103 p103a p104 p104a p105a p110* p111* p112* p113* p114* p117* nbi* factor07 longitud latitud
       }
else if `x' < 2016 & `x'> 2006 {
       keep conglome vivienda hogar ubigeo dominio estrato panel p101 p102 p103 p103a p104 p104a p105a p110* p111* p112* p113* p114* p117* nbi* factor07 longitud latitud
       }   
else if `x' <= 2006 {
       keep conglome vivienda hogar ubigeo dominio estrato panel p101 p102 p103 p103a p104 p104a p105a p110* p111* p112* p113* p114* p117* nbi* factor07 
       }  
	   
* Sumaria
* new: ingmo1hd mieperho inghog2d gashog2d linea gru*1hd
if `x' >= 2014 {
       merge 1:1 conglome vivienda hogar using "$mbd\\`x'${r`x'}-Modulo34\sumaria-`x'.dta", keepusing(ubigeo pobreza estrsocial ingmo1hd mieperho inghog2d gashog2d linea linpe gru*1hd )
       }
else if `x' < 2014 {
       merge 1:1 conglome vivienda hogar using "$mbd\\`x'${r`x'}-Modulo34\sumaria-`x'.dta", keepusing(ubigeo pobreza ingmo1hd mieperho inghog2d gashog2d linea linpe gru*1hd  ) // estrsocial)
       }   

	   drop _merge

save "$output\vivienda`x'.dta", replace

* Síntesis entre ambas bases:
* ---------------------------------------------------------------

use "$output\indi`x'.dta", clear

merge m:1 conglome vivienda hogar using "$output\vivienda`x'.dta"

drop _merge

*Generamos información respecto al año del cual es la información:

gen anio = `x' 

save "$output\basei`x'.dta", replace

* Eliminamos las bases intermedias:
capture erase "$output\indi`x'.dta"
capture erase "$output\vivienda`x'.dta"
}

*      Síntesis entre años     :
* ==============================

* Entre años:

set more off

use "$output\basei2004.dta", clear

forvalue j=2005/2020 {
append using "$output\basei`j'.dta", force
}

* Eliminamos las bases intermedias:

forvalue j=2004/2020 {
capture erase "$output\basei`j'.dta"
}

* Corregimos los ubigeo con menos de 5 caracteres:

destring ubigeo, gen(ubixeo)
tostring ubixeo, gen(ubigeo2)
gen lubixeo=length(ubigeo2)
replace ubigeo2="0" + ubigeo2 if lubixeo==5
replace ubigeo=ubigeo2
drop ubigeo2 lubixeo ubixeo

save "$output\base_cs_enaho_raw.dta", replace


* Raw data needs translation:
unicode analyze "base_cs_enaho_raw.dta"

if `r(N_needed)'>0 {
* So, we codify them:
unicode encoding set "ISO-8859-1"
unicode translate "base_cs_enaho_raw.dta"
}


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

save "$output\base_cs_enaho_raw.dta", replace

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

use "$output\base_cs_enaho_raw.dta", clear

merge m:1 codocupa using "$output\isco-88.dta"
drop if _merge==2
drop _merge

save "$output\base_cs_enaho.dta", replace
