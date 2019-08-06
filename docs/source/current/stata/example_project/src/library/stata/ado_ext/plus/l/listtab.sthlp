{smcl}
{.-}
help for {cmd:listtab} {right:(Roger Newson)}
{.-}
 
{title:List a variable list to a file or to the log for inclusion in a TeX, HTML or word processor table}

{p 8 21 2}
{cmd:listtab} [ {varlist} ] [ {helpb using} {it:filename} ] {ifin} [ ,
  {break}
  {cmdab:b:egin}{cmd:(}{it:string}{cmd:)} {cmdab:d:elimiter}{cmd:(}{it:string}{cmd:)}
  {cmdab:e:nd}{cmd:(}{it:string}{cmd:)} {cmdab:m:issnum}{cmd:(}{it:string}{cmd:)}
  {cmdab:rs:tyle}{cmd:(}{it:rowstyle}{cmd:)}
  {break}
  {cmdab:vb:egin}{cmd:(}{varname}{cmd:)} {cmdab:vd:elimiter}{cmd:(}{varname}{cmd:)}
  {cmdab:ve:nd}{cmd:(}{varname}{cmd:)}
  {break}
  {cmdab:he:adlines}{cmd:(}{it:string_list}{cmd:)} {cmdab:fo:otlines}{cmd:(}{it:string_list}{cmd:)}
  {cmdab:headc:hars}{cmd:(}{it:namelist}{cmd:)} {cmdab:footc:hars}{cmd:(}{it:namelist}{cmd:)}
  {cmdab:nol:abel} {cmdab:t:ype} {cmdab:replace:}
  {cmdab:ap:pendto}{cmd:(}{it:filename}{cmd:)} {cmdab:ha:ndle}{cmd:(}{it:handle_name}{cmd:)}
  ]

{p 8 21 2}
{cmd:listtab_vars} [ {varlist} ] [ ,
  {break}
  {cmdab:b:egin}{cmd:(}{it:string}{cmd:)} {cmdab:d:elimiter}{cmd:(}{it:string}{cmd:)}
  {cmdab:e:nd}{cmd:(}{it:string}{cmd:)} {cmdab:m:issnum}{cmd:(}{it:string}{cmd:)}
  {cmdab:rs:tyle}{cmd:(}{it:rowstyle}{cmd:)}
  {break}
  {cmdab:su:bstitute}{cmd:(}{it:variable_attribute}{cmd:)} {cmdab:lo:cal}{cmd:(}{help macro:{it:local_macro_name}}{cmd:)}
  ]

{p 8 21 2}
{cmd:listtab_rstyle} [ ,
  {cmdab:b:egin}{cmd:(}{it:string}{cmd:)} {cmdab:d:elimiter}{cmd:(}{it:string}{cmd:)}
  {cmdab:e:nd}{cmd:(}{it:string}{cmd:)} {cmdab:m:issnum}{cmd:(}{it:string}{cmd:)}
  {cmdab:rs:tyle}{cmd:(}{it:rowstyle}{cmd:)}
  {cmdab:lo:cal}{cmd:(}{help macro:{it:local_macro_name_list}}{cmd:)}
  ]  

{pstd}
where {it:rowstyle} is a {help listtab##listtab_row_styles:row style} as defined below under {helpb listtab##listtab_row_styles:Row Styles},
{break}
{it:variable_attribute} is

{pstd}
{cmd:name} | {cmd:type} | {cmd:format} | {cmd:vallab} | {cmd:varlab} | {cmd:char} {help char:{it:charname}}

{pstd}
and {help char:{it:charname}} is a {help char:characteristic name}.


{title:Description}

{pstd}
{cmd:listtab} lists the variables in the {varlist} (or all variables, if the {varlist}
is absent) to the Stata log, or to a file (or files) specified by {helpb using}, {cmd:appendto()} or {cmd:handle()},
in a table format, with one table row per observation and the values of different variables separated by a delimiter string.
Optionally, the user may specify a list of header lines before the data rows
and/or a list of footer lines after the data rows.
The log or output file can then
be cut and pasted, or linked or embedded (eg with the TeX  {cmd:\input} command),
into a TeX, HTML or word processor table.
Values of numeric variables are output according to their display formats or value labels (if non-missing),
or as the missing value string specified by {cmd:missnum()} (if missing).

{pstd}
The commands {cmd:listtab_vars} and {cmd:listtab_rstyle} are tools for programmers to use with {cmd:listtab}.
{cmd:listtab_vars} generates a table row, containing, in each column,
an attribute (such as the name) of the variable corresponding to the column.
This generated table row is saved in {cmd:r(vars)} and (optionally) in a local macro,
and is then typically used to specify a {cmd:headlines()} option for {cmd:listtab}.
{cmd:listtab_rstyle} inputs a {cmd:listtab} {help listtab##listtab_row_styles:row style},
and saves the components of the {help listtab##listtab_row_styles:row style}
in {cmd:r()} and (optionally) in local macros.


{title:Options for {cmd:listtab}, {cmd:listtab_vars}, and {cmd:listtab_rstyle}}

{phang}
{cmd:begin(}{it:string}{cmd:)} specifies a string to be output at the beginning of every
output line corresponding to an observation.
If absent, it is set to an empty string.

{phang}
{cmd:delimiter(}{it:string}{cmd:)} specifies the delimiter between values in an observation.
If absent, it is set to an empty string.

{phang}
{cmd:end(}{it:string}{cmd:)} specifies a string to be output at the end of every
output line corresponding to an observation.
If absent, it is set to an empty string.

{phang}
{cmd:missnum(}{it:string}{cmd:)} specifies a string to be output for numeric missing values.
If absent, it is set to an empty string.

{phang}
{cmd:rstyle(}{it:rowstyle}{cmd:)} specifies a {help listtab##listtab_row_styles:row style} for the table rows.
A {help listtab##listtab_row_styles:row style} is a named combination of values
for the {cmd:begin()}, {cmd:end()}, {cmd:delimiter()} and {cmd:missnum()} options.
It may be {cmd:html}, {cmd:htmlhead}, {cmd:tabular}, {cmd:halign},
{cmd:settabs} or {cmd:tabdelim}.
Row styles are specified under {helpb listtab##listtab_row_styles:Row styles} below.
The options set by a {help listtab##listtab_row_styles:row style}
may be overridden by the {cmd:begin()}, {cmd:end()}, {cmd:delimiter()} and {cmd:missnum()} options.


{title:Options for {cmd:listtab} only}

{phang}
{cmd:vbegin(}{varname}{cmd:)} specifies a string variable to be output
before any variables in the {varlist}.
If {cmd:vbegin()} is absent, then the {cmd:begin()} string is output instead.

{phang}
{cmd:vdelimiter(}{varname}{cmd:)} specifies a string variable to be output as a delimiter
between consecutive variables in the {varlist}.
If {cmd:vdelimiter()} is absent, then the {cmd:delimiter()} string is output instead.

{phang}
{cmd:vend(}{varname}{cmd:)} specifies a string variable to be output
after all variables in the {varlist}.
If {cmd:vend()} is absent, then the {cmd:end()} string is output instead.

{pstd}
Note that the option {cmd:vbegin()} overrides {cmd:begin()},
{cmd:vdelimiter()} overrides {cmd:delimiter()},
and {cmd:vend()} overrides {cmd:end()}.
The {cmd:vbegin()}, {cmd:vdelimiter()} and {cmd:vend()} options
allow the user to use different begin, delimiter and end strings
for different observations.

{phang}
{cmd:headlines(}{it:string_list}{cmd:)} specifies a list of lines of text to appear before the first
of the table rows in the output.
This option enables the user to add table preludes and/or headers.

{phang}
{cmd:footlines(}{it:string_list}{cmd:)} specifies a list of lines of text to appear after the last
of the table rows in the output.
This option enables the user to add table postludes and/or footnotes.

{phang}
{cmd:headchars(}{it:namelist}{cmd:)} specifies a list of {help char:variable characteristic names},
used to create table header rows containing the values of these characteristics for the variables in the {varlist},
prefixed, delimited and suffixed with the strings
specified by the {cmd:begin()}, {cmd:delimiter()} and {cmd:end()} options.
These header rows appear after the lines of text specified by {cmd:headlines()},
and before the first of the table rows containing the variable values.
This option enables the user to add column header labels for the variables in the {varlist}.

{phang}
{cmd:footchars(}{it:namelist}{cmd:)} specifies a list of {help char:variable characteristic names},
used to create table footer rows containing the values of these characteristics for the variables in the {varlist},
prefixed, delimited and suffixed with the strings
specified by the {cmd:begin()}, {cmd:delimiter()} and {cmd:end()} options.
These header rows appear before the lines of text specified by {cmd:footlines()},
and after the last of the table rows containing the variable values.
This option enables the user to add column footer labels for the variables in the {varlist}.

{phang}
{cmd:nolabel} specifies that numeric variables with variable labels will be output as
numbers and not as labels.

{phang}
{cmd:type} specifies that the output from {cmd:listtab} will be typed to the Stata log
(or to the Results window).
The data can then be cut and pasted from the Stata log (or from the Results window)
to a TeX, HTML or word processor file.

{phang}
{cmd:replace} specifies that any existing file with the same name as the {helpb using}
file will be overwritten.

{phang}
{cmd:appendto(}{it:filename}{cmd:)} specifies the name of an existing file,
to which the output from {cmd:listtab} will be appended.

{phang}
{cmd:handle(}{it:handle_name}{cmd:)} specifies the name of a file handle,
specifying a file that is already open for output as a text file,
to which the output from {cmd:listtab} will be added, without closing the file.
See help for {helpb file} for details about file handles.
This option allows the user to use {cmd:listtab}
together with {helpb file} as a low-level output utility, possibly combining {cmd:listtab} output with
other output.

{pstd}
Note that the user must specify the {helpb using} qualifier and/or the {cmd:type} option
and/or the {cmd:appendto()} option and/or the {cmd:handle()} option.


{title:Options for {cmd:listtab_vars} only}

{phang}
{cmd:substitute(}{it:variable_attribute}{cmd:)} specifies a variable attribute
to be entered into the columns of the generated table row.
This attribute may be
{cmd:name}, {cmd:type}, {cmd:format}, {cmd:vallab}, {cmd:varlab}, or {cmd:char} {help char:{it:charname}},
specifying the {help varname:variable name}, {help data types:storage type}, {help format:display format},
{help label:value label}, {help label:variable label},
or a named {help char:variable characteristic}, respectively.
If {cmd:substitute()} is not specified, then {cmd:substitute(name)} is assumed,
and variable names are entered in the columns of the generated table row.
In the table row generated by {cmd:listtab_vars},
the attributes of the variables in the {varlist} (or of all the variables, if the {varlist} is absent)
appear in the columns,
and are separated by the {cmd:delimiter()} string,
and prefixed and suffixed by the {cmd:begin()} and {cmd:end()} strings,
specified by the {help listtab##listtab_row_styles:row style}.


{title:Options for {cmd:listtab_rstyle} and {cmd:listtab_vars}}

{phang}
{cmd:local(}{help macro:{it:local_macro_name_list}}{cmd:)} specifies the name of a {help macro:local macro}
in the program that calls {cmd:listtab_vars},
or the names of up to 4 local macros in the program that calls {cmd:listtab_rstyle}.
In the case of {cmd:listtab_vars},
the macro will be set to the value of the row of variable attributes generated by {cmd:listtab_vars},
specified by the {cmd:substitute()} option.
In the case of {cmd:listtab_rstyle},
these macros will be set to the {cmd:begin()}, {cmd:delimiter()}, {cmd:end()} and {cmd:missnum()} options,
respectively,
of the row style generated by {cmd:listtab_rstyle}.
The {cmd:local()} option has the advantage that the user can save multiple header rows,
or multiple row style specifications,
in multiple local macros.
For instance, the user might want two header rows,
one containing variable names, and the other containing variable labels.


{marker listtab_row_styles}{...}
{title:Row styles}

{pstd}
A row style is a combination of the {cmd:begin()}, {cmd:end()},
{cmd:delimiter()} and {cmd:missnum()} options.
Each row style produces rows for a particular
type of table (HTML, TeX or word processor).
The row styles available are as follows:

{hline}
{it:Row style}   {cmd:begin()}     {cmd:delimiter()}     {cmd:end()}           {cmd:missnum()}   {it:Description}
{cmd:html}        {cmd:"<tr><td>"}  {cmd:"</td><td>"}     {cmd:"</td></tr>"}    {cmd:""}          HTML table rows
{cmd:htmlhead}    {cmd:"<tr><th>"}  {cmd:"</th><th>"}     {cmd:"</th></tr>"}    {cmd:""}          HTML table header rows
{cmd:tabular}     {cmd:""}          {cmd:"&"}             {cmd:`"\\"'}          {cmd:""}          LaTeX {cmd:\tabular} environment table rows
{cmd:halign}      {cmd:""}          {cmd:"&"}             {cmd:"\cr"}           {cmd:""}          Plain TeX {cmd:\halign} table rows
{cmd:settabs}     {cmd:"\+"}        {cmd:"&"}             {cmd:"\cr"}           {cmd:""}          Plain TeX {cmd:\settabs} table rows
{cmd:tabdelim}    {cmd:""}          {cmd:char(9)}         {cmd:""}              {cmd:""}          Tab-delimited text file rows
{hline}

{pstd}
The {cmd:tabdelim} row style produces text rows delimited by the tab character,
returned by the {help strfun:char() function} as {cmd:char(9)}.
It should be used with {helpb using}, or with the {cmd:appendto()} or {cmd:handle()} options,
to output the table rows to a file.
If it is used with the {cmd:type} option,
then the tab character is not preserved in the Stata log or Results window.
Any of these row styles may be specified together with {cmd:begin()} and/or {cmd:delimiter()}
and/or {cmd:end()} and/or {cmd:missnum()} options,
and the default options for the row style will then be overridden.
For instance, the user may specify any of the above options with {cmd:missnum(-)}, and
then missing numeric values will be given as minus signs.

{pstd}
Row styles can also be created for output to tables in Rich Text Format (RTF) documents,
using the {helpb rtfutil:rtfrstyle} module of the {helpb rtfutil} package,
which can be downloaded from {help ssc:SSC}.
Row styles for RTF documents are more complicated than those for other documents,
because the {cmd:begin()} and/or {cmd:end()} options used depend on the number of variables output,
and on the spacing of these variables as columns in the table.
It may also be necessary to use the {cmd:vbegin()}, {cmd:vdelimiter)} and {cmd:vend()} options,
if the user requires borders and/or vertical alignment for some table rows and not for others.

{pstd}
More about plain TeX can be found in {help listtab##references:Knuth (1992)}.
More about LaTeX can be found in {help listtab##references:Lamport (1994)}.
More about HTML can be found at
{browse "http://www.w3.org/MarkUp/":The W3C HyperText Markup Language (HTML) Home Page at http://www.w3.org/MarkUp/}.
More about RTF can be found in {help listtab##references:Burke (2003)},
or at {browse "http://interglacial.com/rtf/":Sean Burke's RTF web page}.


{title:Remarks}

{pstd}
{cmd:listtab} is used with a group of other Stata packages to produce tables from Stata datasets,
as described in {help listtab##references:Newson (2012)}.
It creates (on disk and/or in the Stata log and/or Results window)
a text table with up to 3 kinds of rows.
These are headline rows, data rows and footline rows.
Any of these categories of rows may be empty.
The headline and footline rows can be anything the user specifies in the {cmd:headline()} and
{cmd:footline()} options, respectively.
This allows the user to specify TeX preambles, LaTeX
environment delimiters, HTML table delimiters and header rows, or other headlines and/or footlines
for table formats not yet invented.
The data rows must contain variable values, separated by the
{cmd:delimiter()} string, with the {cmd:begin()} string on the left and the
{cmd:end()} string on the right.
This general plan allows the option of using the same package
to generate TeX, LaTeX, HTML, RTF, Microsoft Word, and possibly other tables.
The {cmd:rstyle()} option saves the user from having to remember other options.
The text table generated can then
be cut and pasted, embedded, or linked (eg with the TeX {hi:\input} command) into a document.
The {helpb inccat} command, available on {help ssc:SSC},
can be used to embed a {helpb using} file produced by {cmd:listtab} into a document.
If all the variables are string,
then title rows may sometimes be created using the {helpb ingap} package, also on {help ssc:SSC},
instead of using the {cmd:headlines()} option of {cmd:listtab}.

{pstd}
The {helpb ssc}, {helpb findit} or {helpb net} commands can also be used to find the various
alternatives to {cmd:listtab},
such as
{helpb corrtex}, {helpb estout}, {helpb outtable}, {helpb outtex}, {helpb textab} and {helpb sutex},
which also produce tables from Stata.


{title:Historical note}

{pstd}
The {cmd:listtab} package is a revision of the {helpb listtex} package,
which can also be downloaded from {help ssc:SSC}.
In {helpb listtex}, the {cmd:delimiter()} option defaults to the ampersand ({cmd:"&"}),
which is used in most TeX tables,
and often also for tables pasted manually into Microsoft Word documents and converted.
This {helpb listtex} option cannot be reset to an empty string ({cmd:""}).
In {cmd:listtab}, the default delimiter is an empty string,
which will probably only be used occasionally,
but can be reset to any non-empty string.

{pstd}
For more about the use of {cmd:listtab} and {helpb listtex} with other packages,
see
{help listtab##references:Newson (2012), Newson (2006), Newson (2004), and Newson (2003)}.


{title:Examples}

{pstd} To type text table lines separated by {hi:&} characters for cutting and pasting into a
Microsoft Word table using the menu sequence {hi:Table->Convert->Text to Table}:

{p 16 20}{inp:. listtab make foreign weight mpg, type delim(&)}{p_end}

{pstd}
To output text table lines separated by tab characters to a text file
for cutting and pasting into a
Microsoft Word table using {hi:Table->Convert->Text to Table}:

{p 8 12 2}{inp:. listtab make foreign weight mpg using trash1.txt, rstyle(tabdelim)}{p_end}

{pstd}
To produce TeX table lines for a plain TeX {cmd:\halign} table:

{p 8 12 2}{inp:. listtab make foreign weight mpg using trash1.tex, rs(halign) replace}{p_end}

{pstd}
To produce TeX table lines for a plain TeX {cmd:\halign} table with
horizontal and vertical rules:

{p 8 12 2}{inp:. listtab make foreign weight mpg using trash1.tex, b(&&) d(&&) e(&\cr{\noalign{\hrule}}) replace}{p_end}

{pstd}
To produce TeX table lines for a plain TeX {cmd:\settabs} table:

{p 8 12 2}{inp:. listtab make foreign weight mpg using trash1.tex, rstyle(settabs) replace}{p_end}

{pstd}
To produce LaTeX table lines for the LaTeX {cmd:tabular} environment:

{p 8 12 2}{inp:. listtab make foreign weight mpg using trash1.tex, rstyle(tabular) replace}{p_end}

{pstd}
To produce a LaTeX {hi:tabular} environment with a title line, for cutting and pasting into a document:

{p 8 12 2}{inp:. listtab make weight mpg if foreign, type rstyle(tabular) head("\begin{tabular}{rrr}" `"\textit{Make}&\textit{Weight (lbs)}&\textit{Mileage (mpg)}\\"') foot("\end{tabular}")}{p_end}

{pstd}
Note that the user must specify compound quotes {hi:`""'}
around strings in the {cmd:head()} option containing the double backslash {hi:\\} at the end of a LaTeX line.
This is because, inside Stata strings delimited by simple quotes {hi:""},
a double backslash is interpreted as a single backslash.

{pstd}
To produce HTML table rows for insertion into a HTML table:

{p 8 12 2}{inp:. listtab make foreign weight mpg using trash1.htm, rstyle(html) replace}{p_end}

{pstd}
To produce a HTML table for cutting and pasting into a HTML document:

{p 8 12 2}{inp:. listtab make weight mpg if foreign, type rstyle(html) head(`"<table border="1">"' "<tr><th>Make and Model</th><th>Weight (lbs)</th><th>Mileage (mpg)</th></tr>") foot("</table>")}{p_end}

{pstd}
To produce the same HTML table, using {cmd:listtab_vars}:

{p 8 12 2}{inp:. listtab_vars make weight mpg, substitute(varlab) rstyle(htmlhead) local(headrow)}{p_end}
{p 8 12 2}{inp:. listtab make weight mpg if foreign, type rstyle(html) head(`"<table border="1">"' `"`headrow'"') foot("</table>")}{p_end}

{pstd}
To produce a HTML table of variable attributes using {cmd:listtab_vars} with the {helpb descsave} package
(an extended version of {helpb describe} downloadable from {help ssc:SSC}):

{p 8 12 2}{inp:. preserve}{p_end}
{p 8 12 2}{inp:. descsave, norestore}{p_end}
{p 8 12 2}{inp:. list, noobs abbr(32) subvarname}{p_end}
{p 8 12 2}{inp:. listtab_vars, rstyle(htmlhead) substitute(char varname)}{p_end}
{p 8 12 2}{inp:. listtab, type rstyle(html) head("<table frame=box>" "`r(vars)'") foot("</table>")}{p_end}
{p 8 12 2}{inp:. restore}{p_end}

{pstd}
For examples using Rich Text Format (RTF), see on-line help for {helpb rtfutil},
if installed.
The {helpb rtfutil} package can be downloaded from {help ssc:SSC}.


{title:Saved results}

{pstd}
{cmd:listtab_rstyle} saves the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(begin)}}{cmd:begin()} string{p_end}
{synopt:{cmd:r(delimiter)}}{cmd:delimiter()} string{p_end}
{synopt:{cmd:r(end)}}{cmd:end()} string{p_end}
{synopt:{cmd:r(missnum)}}{cmd:missnum()} string{p_end}
{p2colreset}{...}

{pstd}
{cmd:listtab_vars} saves the above items in {cmd:r()},
and also the following:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(vars)}}generated table row{p_end}
{p2colreset}{...}


{title:Author}

{pstd}
Roger Newson, National Heart and Lung Institute, Imperial College London, UK.
Email: {browse "mailto:r.newson@imperial.ac.uk":r.newson@imperial.ac.uk}


{marker references}{title:References}

{phang}
Burke S. M.
2003.
{it:RTF Pocket Guide}.
Sebastopol, CA: O'Reilly & Associates Inc.
Download more information from {browse "http://interglacial.com/rtf/":Sean Burke's RTF web page}.

{phang}
Knuth D. E.  1992.
{it:The TeXbook.}
Reading, Mass:  Addison-Wesley.

{phang}
Lamport L.  1994.
{it:LaTeX: a document preparation system.  2nd edition.}
Boston, Mass:  Addison-Wesley.

{phang}
Newson, R. B.  2012.
From resultssets to resultstables in Stata.
{it:The Stata Journal} 12 (2): 191-213.
Download from {browse "http://www.stata-journal.com/article.html?article=st0254":{it:The Stata Journal} website}.

{phang}
Newson, R.  2006. 
Resultssets, resultsspreadsheets and resultsplots in Stata.
Presented at {browse "http://ideas.repec.org/s/boc/dsug06.html" :the 4th German Stata User Meeting, Mannheim, 31 March, 2006}.

{phang}
Newson, R.  2004.
From datasets to resultssets in Stata.
Presented at {browse "http://ideas.repec.org/s/boc/usug04.html" :the 10th United Kingdom Stata Users' Group Meeting, London, 29 June, 2004}.

{phang}
Newson, R.  2003.
Confidence intervals and {it:p}-values for delivery to the end user.
{it:The Stata Journal} 3(3): 245-269.
Download from {browse "http://www.stata-journal.com/article.html?article=st0043":{it:The Stata Journal} website}.


{title:Also see}

{psee}
Manual:  {manlink D describe}, {manlink P file}, {manlink D insheet}, {manlink D list}, {manlink D outsheet}, {manlink R ssc}, {manlink D type}
{p_end}

{psee}
{space 2}Help:  {manhelp describe D}, {manhelp file P}, {manhelp insheet D}, {manhelp list D}, {manhelp outsheet D}, {manhelp ssc R}, {manhelp type D}
{break}
{helpb descsave}, {helpb inccat}, {helpb ingap}, {helpb listtex}, {helpb rtfutil}, {helpb sdecode},
{break}
{helpb corrtex}, {helpb estout}, {helpb outtable}, {helpb outtex}, {helpb textab}, {helpb sutex} if installed
{p_end}

{psee}
{space 1}Other:  {browse "http://www.w3.org/MarkUp/":The W3C HyperText Markup Language (HTML) Home Page at http://www.w3.org/MarkUp/}
{break}
{browse "http://interglacial.com/rtf/":Sean Burke's RTF web page}
{p_end}
