
*** Housing Price Index for Raleigh

global dropbox "/Users/willow/Dropbox/Teardown Data/Rental Data"
set more off

************
* log(price) = quarter-year FE + houseid FE + error term
************
use "$dropbox/Rental_Final_Raleigh.dta", clear
gen lnprice = ln(price)

gen rental_quarter = qofd(rental_date)
format rental_quarter %tq
tab rental_quarter, gen(rentalqrt)
drop rentalqrt1

count if property_id == .
drop if unit_id == ""
egen houseid = group(property_id unit_id)

reghdfe lnprice rentalqrt*, a(houseid)



************
* log(price of 1st sale) - log(price of 2nd sale) = quarter-year FE + error term
************

* repeat sales: putting the prices of the first sale and the second sale in the same row
use "$dropbox/Rental_Final_Raleigh.dta", clear

gen rental_quarter = qofd(rental_date)
format rental_quarter %tq

count if property_id == .
drop if unit_id == ""
egen houseid = group(property_id unit_id)
sort houseid rental_date

gen repeat_price = .
gen repeat_rental_quarter = .
local obs = _N
forvalues i = 2 / `obs' {
	local j = `i' - 1
	replace repeat_price = price[`i'] if houseid[`j'] == houseid[`i'] & rental_quarter[`j'] < rental_quarter[`i'] in `j'
	replace repeat_rental_quarter = rental_quarter[`i'] if houseid[`j'] == houseid[`i'] & rental_quarter[`j'] < rental_quarter[`i'] in `j'
}
format repeat_rental_quarter %tq

gen lnpricediff = ln(repeat_price) - ln(price)

sort rental_quarter
egen quarteryear1 = group(rental_quarter)
sort repeat_rental_quarter
egen quarteryear2 = group(repeat_rental_quarter)
replace quarteryear2 = quarteryear2 + 1
tab rental_quarter, gen(rentalqrt)
drop rentalqrt1

forvalues i = 2/45{
	replace rentalqrt`i' = -1 if quarteryear1 == `i'
	replace rentalqrt`i' = 1 if quarteryear2 == `i'
}

keep price rental_quarter repeat_price repeat_rental_quarter lnpricediff rentalqrt* houseid
drop if repeat_price == .

reghdfe lnpricediff rentalqrt*, noabsorb




