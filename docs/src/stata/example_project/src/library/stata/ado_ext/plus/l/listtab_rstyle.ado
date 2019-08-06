#delim ;
prog def listtab_rstyle, rclass;
version 11.0;
/*
 Input a listtab rstyle() option
 (with or without amendments)
 and save begin, delimiter and end strings in r().
*! Author: Roger Newson
*! Date: 04 November 2012
*/

syntax [, Begin(string) Delimiter(string) End(string) Missnum(string) RStyle(string)
  LOcal(namelist max=4 local)
  ];
/*
  begin() is string at beginning of each obs
    (set to "" if absent).
  delimiter() is delimiter for separating values of same obs
    (set to "" if absent).
  end() is string at end of each obs
    (set to "" if absent).
  missnum() is string code for missing numeric value
    (defaulting to empty string if absent)
  rstyle() is a row style
    (a named combination of begin(), delimiter(), end() and -missnum-)
  local() specifies a list of names of local macros in the calling program,
    to contain the begin, delimiter, end and missnum strings, respectively,
    of the generated row style.
*/

* Interpret row styles *;
if `"`rstyle'"'=="html" {;
  if `"`begin'"'=="" {;local begin "<tr><td>";};
  if `"`delimiter'"'=="" {;local delimiter "</td><td>";};
  if `"`end'"'=="" {;local end "</td></tr>";};
};
else if `"`rstyle'"'=="htmlhead" {;
  if `"`begin'"'=="" {;local begin "<tr><th>";};
  if `"`delimiter'"'=="" {;local delimiter "</th><th>";};
  if `"`end'"'=="" {;local end "</th></tr>";};
};
else if `"`rstyle'"'=="tabular" {;
  if `"`delimiter'"'=="" {;local delimiter "&";};
  if `"`end'"'=="" {;local end `"\\"';};
};
else if `"`rstyle'"'=="halign" {;
  if `"`delimiter'"'=="" {;local delimiter "&";};
  if `"`end'"'=="" {;local end "\cr";};
};
else if `"`rstyle'"'=="settabs" {;
  if `"`begin'"'=="" {;local begin "\+";};
  if `"`delimiter'"'=="" {;local delimiter "&";};
  if `"`end'"'=="" {;local end "\cr";};
};
else if `"`rstyle'"'=="tabdelim" {;
  if `"`delimiter'"'=="" {;local delimiter=char(9);};
};
else if `"`rstyle'"'!="" {;
  disp as text "Unrecognised row style: " as result `"`rstyle'"';
  disp as text "Default row style used instead";
};

*
 Return row style definition in local macros
*;
local i1=0;
foreach R in begin delimiter end missnum {;
  local i1=`i1'+1;
  local cmac: word `i1' of `local';
  if "`cmac'"!="" {;
    c_local `cmac' `"``R''"';
  };
};

*
 Return results in r()
*;
return local missnum: copy local missnum;
return local end: copy local end;
return local delimiter: copy local delimiter;
return local begin: copy local begin;

end;
