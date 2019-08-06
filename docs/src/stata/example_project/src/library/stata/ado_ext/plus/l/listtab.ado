#delim ;
prog def listtab;
version 11.0;
*
 List the variables in -varlist- as a table
 to files specified in -using- and/or -handle()-
 and/or to the Stata log
 with a value delimiter string
 and (optionally) a begin-line and/or end-line string.
 This program was first intended to output data to a file
 which is then input into a TeX table,
 in which case the value delimiter is usually "&"
 and the line terminator is usually "\cr".
*! Author: Roger Newson
*! Date: 04 November 2012
*;

syntax [varlist (min=1)] [using/] [if] [in]
 [, Begin(passthru) Delimiter(passthru) End(passthru) Missnum(passthru)
  VBegin(varname string) VDelimiter(varname string) VEnd(varname string)
  RStyle(passthru)
  HEadlines(string asis) FOotlines(string asis)
  HEADChars(namelist) FOOTChars(namelist)
  noLabel Type REPLACE APpendto(string) HAndle(name) ];
*
  -varlist- specifies variables to be written to output file.
  -using- specifies output file.
  -begin()- is string at beginning of each obs
    (set to "" if absent).
  -delimiter()- is delimiter for separating values of same obs
    (set in default to "&").
  -end()- is string at end of each obs
    (set to "" if absent).
  -missnum()- is string code for missing numeric value
    (defaulting to empty string if absent).
  -vbegin()- is a string variable,
    containing observation-specific begin() strings.
  -vdelimiter()- is a string variable,
    containing observation-specific delimiter() strings.
  -vend()- is a string variable,
    containing observation-specific end() strings.
  -rstyle()- is a row style
    (a named combination of -begin-, -end-, -using- and -missnum-).
  -headlines()- is a list of head lines to be added to the -using- file.
  -footlines()- is a list of foot lines to be added to the -using- file.
  -nolabel- specifies that numeric variables with value labels
    must be output as numbers and not as value labels.
  -type- specifies that the output file must be typed to the Stata log.
  -replace- specifies that any pre-existing file
    with the same name as the -using- file must be overwritten.
  -appendto()- specifies the name of a file not currently open,
    to which the variables (and headlines and footlines if specified)
    will be written, closing the file at the end of execution.
  -handle()- specifies a handle of a file currently open
    as a text file in write mode (using the -file open- command),
    to which the variables (and headlines and footlines if specified)
    will be written, leaving the file open at the end of execution,
    so that further output can be added using the -file- command.
*;

* Check that the user has specified either -using-, -type-, -appendto()- or -handle()- *;
if (`"`using'"'=="")&("`type'"=="")&(`"`appendto'"'=="")&("`handle'"=="") {;
  disp as error "You must specify using and/or type and/or appendto() and/or handle()."
    _n "If type is specified, then data are typed to the Stata log."
    _n "If using is specified, then data are output to a file."
    _n "If appendto() is specified, then data are appended to a file."
    _n "If handle() is specified, then data are added to a file already open with that handle.";
  error 498;
};

* Default output file *;
if `"`using'"'=="" {;
  tempfile tf0;
  local using `"`tf0'"';
};

*
 Extract row style elements
*;
listtab_rstyle, `begin' `delimiter' `end' `missnum' `rstyle';
mata: st_local("begin",st_global("r(begin)"));
mata: st_local("delimiter",st_global("r(delimiter)"));
mata: st_local("end",st_global("r(end)"));
mata: st_local("missnum",st_global("r(missnum)"));

local nvar:word count `varlist';

marksample touse, novarlist strok;

*
 Create temporary variables
 containing begin, delimiter and end strings,
 if these variables are not supplied
*;
foreach BDE in begin delimiter end {;
  if "`v`BDE''"=="" {;
    tempvar v`BDE';
    qui gene `v`BDE''="";
    qui replace `v`BDE''=`"``BDE''"' if `touse';
  };
};

*
 Create list of output variables
*;
local ovarlist `"`vbegin'"';
forvalues i1=1(1)`nvar' {;
  local vari1:word `i1' of `varlist';
  local typei1:type `vari1';
  if substr("`typei1'",1,3)=="str" {;
    * String variable - do not convert *;
    local ovarlist `"`ovarlist' `vari1'"';
  };
  else {;
    * Numeric variable - convert to temporary string variable *;
    tempvar sv`i1';
    local vli1: value label `vari1';
    if ("`label'"!="nolabel")&("`vli1'"!="") {;
      qui decode `vari1', gene(`sv`i1'');
    };
    else {;
      local fmti1: format `vari1';
      qui gene str1 `sv`i1''="";
      qui replace `sv`i1''=string(`vari1',"`fmti1'") if `touse';
      qui replace `sv`i1''=`"`missnum'"' if `touse' & missing(`vari1');
    };
    local ovarlist `"`ovarlist' `sv`i1''"';
  };
  * Append delimiter or end *;
  if `i1'==`nvar' {;local ovarlist `"`ovarlist' `vend'"';};
  else {;local ovarlist `"`ovarlist' `vdelimiter'"';};
};

* Output to temporary file *;
tempfile tempout;
qui outfile `ovarlist' using `"`tempout'"' if `touse', runtogether replace;

*
 Copy temporary output file to permanent output file,
 adding headlines and footlines
 and characteristic headlines and footlines,
 if requested
*;
* Tokenize headlines and footlines and count the tokens *;
mata:listtab_tokenize("nhead","headlines");
forv i1=1(1)`nhead' {;
  local headline`i1' `"`macval(`i1')'"';
};
mata:listtab_tokenize("nfoot","footlines");
forv i1=1(1)`nfoot' {;
  local footline`i1' `"`macval(`i1')'"';
};
local nheadchar: word count `headchars';
local nfootchar: word count `footchars';
if `nhead'+`nheadchar'<=0 & `nfoot'+`nfootchar'<=0 {;
  * No headlines or footlines *;
  copy `"`tempout'"' `"`using'"', text `replace';
};
else {;
  * Headlines or footlines required *;
  tempfile tempout2;
  tempname handle1 handle2;
  file open `handle2' using `"`tempout2'"', write text;
  * Head lines and characteristics *;
  forv i1=1(1)`nhead' {;
    local linecur `"`macval(headline`i1')'"';
    file write `handle2' `"`macval(linecur)'"' _n;
  };
  forv i1=1(1)`nheadchar' {;
    local charcur: word `i1' of `headchars';
    listtab_vars `varlist', b(`"`macval(begin)'"') d(`"`macval(delimiter)'"') e(`"`macval(end)'"')
      sub(char `charcur') lo(linecur);
    file write `handle2' `"`macval(linecur)'"' _n;
  };
  * Table body *;
  file open `handle1' using `"`tempout'"',read;
  file read `handle1' linecur;
  while r(eof)==0 {;
    file write `handle2' `"`macval(linecur)'"' _n;
    file read `handle1' linecur;
  };
  file close `handle1';
  * Foot characteristics and lines *;
  forv i1=1(1)`nfootchar' {;
    local charcur: word `i1' of `footchars';
    listtab_vars `varlist', b(`"`macval(begin)'"') d(`"`macval(delimiter)'"') e(`"`macval(end)'"')
      sub(char `charcur') lo(linecur);
    file write `handle2' `"`macval(linecur)'"' _n;
  };
  forv i1=1(1)`nfoot' {;
    local linecur `"`macval(footline`i1')'"';
    file write `handle2' `"`macval(linecur)'"' _n;
  };
  file close `handle2';
  copy `"`tempout2'"' `"`using'"', text `replace';
};

* Append to a file if -appendto()- is requested *;
if `"`appendto'"'!="" {;
  tempname aphandle uhandle;
  file open `aphandle' using `"`appendto'"', write append text;
  file open `uhandle' using `"`using'"', read;
  file read `uhandle' linecur;
  while r(eof)==0 {;
    file write `aphandle' `"`macval(linecur)'"' _n;
    file read `uhandle' linecur;
  };
  file close `uhandle';
  file close `aphandle';
};

* Add to an already open text file if -handle()- is requested *;
if "`handle'"!="" {;
  tempname uhandle;
  file open `uhandle' using `"`using'"', read;
  file read `uhandle' linecur;
  while r(eof)==0 {;
    file write `handle' `"`macval(linecur)'"' _n;
    file read `uhandle' linecur;
  };
  file close `uhandle';
};

* Type to the Stata log if requested *;
if "`type'"!="" {;type `"`using'"';};

end;

#delim cr
version 11.0
/*
  Private Mata programs
*/
mata:

void listtab_tokenize(string scalar tokencount,string scalar tokenlist)
{
/*
 Count tokens in local macro with name in tokenlist
 and return result in local macro with name in tokencount
*/
string rowvector tokenrow;
real i1;
/*
 tokenrow will be a row vector of the tokens.
 i1 will be a counter.
*/

tokenrow=tokens(st_local(tokenlist));
st_local(tokencount,strofreal(cols(tokenrow)));
for(i1=1;i1<=cols(tokenrow);i1++){
  st_local(strofreal(i1),tokenrow[i1]);
}

}

end
