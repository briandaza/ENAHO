/* ---------------------------------------------------------------------------
             Merging ENAHO Cross-Section Micro Data (2004 - 2020)
  
 Brian Daza - bdaza@umich.edu - bdaza.github.io      This version: 01-Apr-2021 
==============================================================================

- Datasets are downloaded in dta format as they are in 
http://iinei.inei.gob.pe/microdatos/
- Zip files were uncompressed in folders by year.
  For instance, the 2012 folder is: "...\ENAHO\Raw\2012" 
  and has the following folders on it:
  - 324-Modulo01
  - 324-Modulo02
   (...)
  - 324-Modulo77 
  There are not 77 folders, don't get afraid, I only downloaded those I'll use
  as you'll inferr from below.
- Each year data has a 3-digit prefix in their names. INEI put them. 
  I'm listing those as globals. 
- I had to rename (by hand) a folder name from "498_Modulo02" to 
"498-Modulo02" in the year 2015 folder. Every other change was done here.
 
To do: Add more modules. 
----------------------------------------------------------------------------- */

* Preparing the environment:												   
clear
global mdir "C:\Users\dazav\Dropbox (Personal)\Datasets\ENAHO"

* Datasets directory:
global mbd "$mdir\Raw"

* Modules suffix by year:
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
* 		              Data processing and merge
* =============================================================================

*          Yearly          :
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

* Modify labels that were mismatched at some point (estatal/no estatal instead of Yes/No)

label define LABB 1 "Yes" 2 "No", replace

save "$output\base_cs_enaho_raw.dta", replace

clear

* Raw data needs translation:
unicode analyze "base_cs_enaho_raw.dta"

if `r(N_needed)'>0 {
* So, we codify them:
unicode encoding set "ISO-8859-1"
unicode translate "base_cs_enaho_raw.dta"
}

