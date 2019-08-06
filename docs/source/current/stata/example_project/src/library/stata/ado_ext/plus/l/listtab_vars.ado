#delim ;
prog def listtab_vars, rclass;
version 11.0;
/*
 Input a varlist and a listtab rstyle() option
 (with or without amendments)
 and create as output a macro in r(vars)
 containing a row in the input row style
 with variable names or other attributes in place of the variable values.
*! Author: Roger Newson
*! Date: 22 October 2009
*/

syntax [varlist (min=1)] [, SUbstitute(string) LOcal(name local) Begin(passthru) Delimiter(passthru) End(passthru) Missnum(passthru) RStyle(passthru) ];
/*
  substitute() indicates the variable attribute to be substituted for the variable values
    in the result returned in r(vars).
  local() specifies the name of a local macro in the calling program
    set to contain the result returned in r(vars).
  begin() is string at beginning of each obs
    (set to "" if absent).
  delimiter() is delimiter for separating values of same obs
    (set to "" if absent).
  end() is string at end of each obs
    (set to "" if absent).
  missnum() is string code for missing numeric value
    (defaulting to empty string if absent)
  rstyle() is a row style
    (a named combination of -begin-, -end-, -using- and -missnum-)
*/

*
 Set default for substitute() option if necessary
 and check that substitute() option is valid
*;
if `"`substitute'"'=="" {;
  local substitute "name";
};
local sub1: word 1 of `substitute';
if !inlist("`sub1'","name","type","format","vallab","varlab","char") {;
  disp as error "Invalid substitute() option: `substitute'";
  error 498;
};
if "`sub1'"=="char" {;
  * Characteristic value *;
  local charname: word 2 of `substitute';
  cap confirm name `charname';
  if _rc!=0 {;
    disp as error "Invalid substitute() option: `substitute'";
    error 498;
  };
};

*
 Extract row style elements
*;
listtab_rstyle, `begin' `delimiter' `end' `missnum' `rstyle';
mata: st_local("begin",st_global("r(begin)"));
mata: st_local("delimiter",st_global("r(delimiter)"));
mata: st_local("end",st_global("r(end)"));
return add;

*
 Create row of variable attributes
*;
mata: st_local("vars",st_local("begin"));
local nvar: word count `varlist';
forv i1=1(1)`nvar' {;
  local varcur: word `i1' of `varlist';
  if "`sub1'"=="name" {;local subcur "`varcur'";};
  else if "`sub1'"=="type" {;local subcur: type `varcur';};
  else if "`sub1'"=="format" {;local subcur: format `varcur';};
  else if "`sub1'"=="varlab" {;local subcur: var label `varcur';};
  else if "`sub1'"=="vallab" {;local subcur: value label `varcur';};
  else if "`sub1'"=="char" {;local subcur: char `varcur'[`charname'];};
  mata: st_local("vars",st_local("vars")+st_local("subcur"));
  if `i1'==`nvar' {;
    mata: st_local("vars",st_local("vars")+st_local("end"));
  };
  else {;
    mata: st_local("vars",st_local("vars")+st_local("delimiter"));
  };
};

*
 Return local result if requested
*;
if "`local'"!="" {;
  c_local `local': copy local vars;
};

*
 Return results
*;
return local vars: copy local vars;

end;
