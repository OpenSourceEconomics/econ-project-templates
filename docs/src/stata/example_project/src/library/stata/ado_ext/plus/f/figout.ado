program define figout

*! 1.0.1 Ian Watson 21mar07
* 1.0.0 Ian Watson 30mar05
* Program to create mini datasets extracted 
* from tabout results for use in graphs


version 8.2
syntax using/ ///
   , [REPlace] infile(string) ///
   gvars(string) over(string) ///
   start(string) stop(string)
   

if "`infile'" ~="" {
     local infile = "`infile'"
     local outfile = "`using'"
   }
   else {
     local infile = "`using'"
     local outfile = "`using'"
   }

if "`replace'" == "replace" {
   local opt "replace"
}


tempfile tempfile 
tempname tablefile
tempname mainfile

capture file open `mainfile' using `tempfile', write `opt'

     file write `mainfile' "`over'" _tab
     tokenize "`gvars'"
     while "`1'" ~= "" {
          local outword = "`1'"
          file write `mainfile' "`outword'" _tab
          mac shift
     }
     file write `mainfile' _n



* open the table file with all the existing output

file open `tablefile' using "`infile'", read

file read `tablefile' line
     while r(eof) == 0 {
         if index("`line'","`start'") ~= 0 {
            file read `tablefile' line
               local end = 0
               while `end' == 0 {
                 local cleanline = subinstr("`line'","\&","and",.)
                 local cleanline = subinstr("`line'","\","",.)
*                 local line : subinstr local line "\&" "and"
*                 local line : subinstr local line "\" ""
                 tokenize "`cleanline'", parse("&")
                 while "`1'" ~= "" {
                    local outword = "`1'"
                    file write `mainfile' "`outword'" _tab
                    mac shift 2
                 }
                 file write `mainfile' _n
                 file read `tablefile' line
                 local end = index("`line'","`stop'")
                 if r(eof)!=0 {
                    di as err "figout failed to find your stop word or phrase"
                    exit
                }
               }     
          }     
          else {
             file read `tablefile' line
          }  
      } // end while not eof 
      file write `mainfile' _n

file close `mainfile'
file close `tablefile'

clear
insheet using `tempfile'
if _N!=0 {
    local k = _N
    egen order = fill(1/`k')
    keep `over' `gvars' order
    save "`outfile'.dta", `opt'
    list
}
else di as err "figout failed to find your start word or phrase"

end

