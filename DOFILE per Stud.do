clear

use "/Users/williamgorman/Box/William_Work/analysis.dta"

gen tot_enroll=(inst_bach_tot+inst_master_tot+inst_doc_tot)*1000
gen FSS_per_stud=FSS_support/tot_enroll

bysort year: egen p25 = pctile(FSS_per_stud), p(25)
by year: egen p75 = pctile(FSS_per_stud), p(75)
by year: egen p50 = pctile(FSS_per_stud), p(50)
*collapse (mean) avg_FSS_support=FSS_support p25 p75, by(id year)

*keep if avg_FSS_support<=200000
*keep if id==110699

twoway connect p50 p25 p75 year
graph export Graphperstud.png

clear

use "/Users/williamgorman/Box/William_Work/analysis.dta"

sort year
by year: egen cp50=pctile(FSS_per_stud), p(50), if cs==1
by year: egen ncp50=pctile(FSS_per_stud), p(50), if cs==0

twoway connect cp50 ncp50 year
graph export mygraph2.png

clear

use "/Users/williamgorman/Box/William_Work/analysis.dta"

sort id year
egen anycs=max(cs), by (id)
keep if anycs==1
keep id instnm year FSS_per_stud cs
egen first_cs = min(year / (cs==1)), by(id)
gen t = (year-first_cs)

sort t
by t: egen taverage=pctile(FSS_per_stud), p(50)

twoway connect taverage t
graph export mygraph3.png




