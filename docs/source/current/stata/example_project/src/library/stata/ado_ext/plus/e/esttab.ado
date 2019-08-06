*! version 2.0.6  02jun2014  Ben Jann
*! wrapper for estout

program define esttab
    version 8.2
    local caller : di _caller()

// mode specific defaults
    local cdate "`c(current_date)'"
    local ctime "`c(current_time)'"
// - fixed
    local fixed_open0         `""% `cdate' `ctime'""'
    local fixed_close0        `""""'
    local fixed_open          `""'
    local fixed_close         `""'
    local fixed_caption       `""@title""'
    local fixed_open2         `""'
    local fixed_close2        `""'
    local fixed_toprule       `""@hline""'
    local fixed_midrule       `""@hline""'
    local fixed_bottomrule    `""@hline""'
    local fixed_topgap        `""""'
    local fixed_midgap        `""""'
    local fixed_bottomgap     `""""'
    local fixed_eqrule        `"begin(@hline "")"'
    local fixed_ssl           `"N R-sq "adj. R-sq" "pseudo R-sq" AIC BIC"'
    local fixed_lsl           `"Observations R-squared "Adjusted R-squared" "Pseudo R-squared" AIC BIC"'
    local fixed_starlevels    `"* 0.05 ** 0.01 *** 0.001"'
    local fixed_starlevlab    `""'
    local fixed_begin         `""'
    local fixed_delimiter     `"" ""'
    local fixed_end           `""'
    local fixed_incelldel     `"" ""'
    local fixed_varwidth      `"\`= cond("\`label'"=="", 12, 20)'"'
    local fixed_modelwidth    `"12"'
    local fixed_abbrev        `"abbrev"'
    local fixed_substitute    `""'
    local fixed_interaction   `"" # ""'
    local fixed_tstatlab      `"t statistics"'
    local fixed_zstatlab      `"z statistics"'
    local fixed_pvallab       `"p-values"'
    local fixed_cilab         `"\`level'% confidence intervals"'
// - smcl
    local smcl_open0          `"{smcl} "{* % `cdate' `ctime'}{...}""'
    local smcl_close0         `""""'
    local smcl_open           `""'
    local smcl_close          `""'
    local smcl_caption        `""@title""'
    local smcl_open2          `""'
    local smcl_close2         `""'
    local smcl_toprule        `""{hline @width}""'
    local smcl_midrule        `""{hline @width}""'
    local smcl_bottomrule     `""{hline @width}""'
    local smcl_topgap         `""""'
    local smcl_midgap         `""""'
    local smcl_bottomgap      `""""'
    local smcl_eqrule         `"begin("{hline @width}" "")"'
    local smcl_ssl            `"`macval(fixed_ssl)'"'
    local smcl_lsl            `"`macval(fixed_lsl)'"'
    local smcl_starlevels     `"`macval(fixed_starlevels)'"'
    local smcl_starlevlab     `""'
    local smcl_begin          `""'
    local smcl_delimiter      `"" ""'
    local smcl_end            `""'
    local smcl_incelldel      `"" ""'
    local smcl_varwidth       `"`macval(fixed_varwidth)'"'
    local smcl_modelwidth     `"`macval(fixed_modelwidth)'"'
    local smcl_abbrev         `"`macval(fixed_abbrev)'"'
    local smcl_substitute     `""'
    local smcl_interaction    `"" # ""'
    local smcl_tstatlab       `"`macval(fixed_tstatlab)'"'
    local smcl_zstatlab       `"`macval(fixed_zstatlab)'"'
    local smcl_pvallab        `"`macval(fixed_pvallab)'"'
    local smcl_cilab          `"`macval(fixed_cilab)'"'
// - tab
    local tab_open0           `"`macval(fixed_open0)'"'
    local tab_close0          `""""'
    local tab_open            `""'
    local tab_close           `""'
    local tab_caption         `""@title""'
    local tab_open2           `""'
    local tab_close2          `""'
    local tab_topgap          `""""'
    local tab_midgap          `""""'
    local tab_bottomgap       `""""'
    local tab_ssl             `"`macval(fixed_ssl)'"'
    local tab_lsl             `"`macval(fixed_lsl)'"'
    local tab_starlevels      `"`macval(fixed_starlevels)'"'
    local tab_starlevlab      `""'
    local tab_begin           `""'
    local tab_delimiter       `"_tab"'
    local tab_end             `""'
    local tab_incelldel       `"" ""'
    local tab_varwidth        `""'
    local tab_modelwidth      `""'
    local tab_abbrev          `""'
    local tab_substitute      `""'
    local tab_interaction     `"" # ""'
    local tab_tstatlab        `"`macval(fixed_tstatlab)'"'
    local tab_zstatlab        `"`macval(fixed_zstatlab)'"'
    local tab_pvallab         `"`macval(fixed_pvallab)'"'
    local tab_cilab           `"`macval(fixed_cilab)'"'
// - csv
    local csv_open0           `"`"\`csvlhs'% `cdate' `ctime'""'"'
    local csv_close0          `""""'
    local csv_open            `""'
    local csv_close           `""'
    local csv_caption         `"`"\`csvlhs'@title""'"'
    local csv_open2           `""'
    local csv_close2          `""'
    local csv_topgap          `""""'
    local csv_midgap          `""""'
    local csv_bottomgap       `""""'
    local csv_ssl             `"`macval(fixed_ssl)'"'
    local csv_lsl             `"`macval(fixed_lsl)'"'
    local csv_starlevels      `"`macval(fixed_starlevels)'"'
    local csv_starlevlab      `""'
    local csv_begin           `"`"\`csvlhs'"'"'
    local csv_delimiter       `"`"",\`csvlhs'"'"'
    local scsv_delimiter      `"`"";\`csvlhs'"'"'
    local csv_end             `"`"""'"'
    local csv_incelldel       `"" ""'
    local csv_varwidth        `""'
    local csv_modelwidth      `""'
    local csv_abbrev          `""'
    local csv_substitute      `""'
    local csv_interaction     `"" # ""'
    local csv_tstatlab        `"`macval(fixed_tstatlab)'"'
    local csv_zstatlab        `"`macval(fixed_zstatlab)'"'
    local csv_pvallab         `"`macval(fixed_pvallab)'"'
    local csv_cilab           `"`macval(fixed_cilab)'"'
// - rtf
    local rtf_open0           `""'
    local rtf_close0          `""'
      local rtf_ct            `"\yr`=year(d(`cdate'))'\mo`=month(d(`cdate'))'\dy`=day(d(`cdate'))'\hr`=substr("`ctime'",1,2)'\min`=substr("`ctime'",4,2)'"'
      local rtf_open_l1       `"`"{\rtf1`=cond("`c(os)'"=="MacOSX", "\mac", "\ansi")'\deff0 {\fonttbl{\f0\fnil Times New Roman;}}"'"'
      local rtf_open_l2       `" `"{\info {\author .}{\company .}{\title .}{\creatim`rtf_ct'}}"'"'
      local rtf_open_l3       `" `"\deflang1033\plain\fs24"'"'
      local rtf_open_l4       `" `"{\footer\pard\qc\plain\f0\fs24\chpgn\par}"'"'
    local rtf_open            `"`rtf_open_l1'`rtf_open_l2'`rtf_open_l3'`rtf_open_l4'"'
    local rtf_close           `""{\pard \par}" "}""'
    local rtf_caption         `"`"{\pard\keepn\ql @title\par}"'"'
    local rtf_open2           `""{""'
    local rtf_close2          `""}""'
    local rtf_toprule         `""'
    local rtf_midrule         `""'
    local rtf_bottomrule      `""'
    local rtf_topgap          `""'
    local rtf_midgap          `"{\trowd\trgaph108\trleft-108@rtfemptyrow\row}"'
    local rtf_bottomgap       `""'
    local rtf_eqrule          `"begin("{\trowd\trgaph108\trleft-108@rtfrowdefbrdrt\pard\intbl\ql {") replace"'
    local rtf_ssl             `""{\i N}" "{\i R}{\super 2}" "adj. {\i R}{\super 2}" "pseudo {\i R}{\super 2}" "{\i AIC}" "{\i BIC}""'
    local rtf_lsl             `"Observations "{\i R}{\super 2}" "Adjusted {\i R}{\super 2}" "Pseudo {\i R}{\super 2}" "{\i AIC}" "{\i BIC}""'
    local rtf_starlevels      `""{\super *}" 0.05 "{\super **}" 0.01 "{\super ***}" 0.001"'
    local rtf_starlevlab      `", label(" {\i p} < ")"'
      local rtf_rowdef        `"\`=cond("\`lines'"=="", "@rtfrowdef", "@rtfrowdefbrdr")'"'
    local rtf_begin           `"{\trowd\trgaph108\trleft-108\`rtf_rowdef'\pard\intbl\ql {"'
    local rtf_delimiter       `"}\cell \pard\intbl\q\`=cond(`"\`alignment'"'!="", `"\`alignment'"', "c")' {"'
    local rtf_end             `"}\cell\row}"'
    local rtf_incelldel       `""\line ""'
    local rtf_varwidth        `"\`= cond("\`label'"=="", 12, 20)'"'
    local rtf_modelwidth      `"12"'
    local rtf_abbrev          `""'
    local rtf_substitute      `""'
    local rtf_interaction     `"" # ""'
    local rtf_tstatlab        `"{\i t} statistics"'
    local rtf_zstatlab        `"{\i z} statistics"'
    local rtf_pvallab         `"{\i p}-values"'
    local rtf_cilab           `"\`level'% confidence intervals"'
// - html
    local html_open0          `"<html> <head> "<title>`=cond(`"\`macval(title)'"'=="","estimates table, created `cdate' `ctime'","@title")'</title>" </head> <body> """'
    local html_close0         `""" </body> </html> """'
    local html_open           `"`"<table border="0" width="\`=cond("\`width'"=="","*","\`width'")'">"'"'
    local html_close          `""</table>""'
    local html_caption        `""<caption>@title</caption>""'
    local html_open2          `""'
    local html_close2         `""'
    local html_toprule        `""<tr><td colspan=@span><hr></td></tr>""'
    local html_midrule        `""<tr><td colspan=@span><hr></td></tr>""'
    local html_bottomrule     `""<tr><td colspan=@span><hr></td></tr>""'
    local html_topgap         `""'
    local html_midgap         `""<tr><td colspan=@span>&nbsp;</td></tr>""'
    local html_bottomgap      `""'
    local html_eqrule         `"begin("<tr><td colspan=@span><hr></td></tr>" "")"'
    local html_ssl            `"<i>N</i> <i>R</i><sup>2</sup> "adj. <i>R</i><sup>2</sup>" "pseudo <i>R</i><sup>2</sup>" <i>AIC</i> <i>BIC</i>"'
    local html_lsl            `"Observations <i>R</i><sup>2</sup> "Adjusted <i>R</i><sup>2</sup>" "Pseudo <i>R</i><sup>2</sup>" <i>AIC</i> <i>BIC</i>"'
    local html_starlevels     `"<sup>*</sup> 0.05 <sup>**</sup> 0.01 <sup>***</sup> 0.001"'
    local html_starlevlab     `", label(" <i>p</i> < ")"'
    local html_begin          `"<tr><td>"'
    local html_delimiter      `"</td><td\`=cond(`"\`alignment'"'!="", `" align="\`alignment'""', "")'>"'
    local html_end            `"</td></tr>"'
    local html_incelldel      `"<br />"'
    local html_varwidth       `"\`= cond("\`label'"=="", 12, 20)'"'
    local html_modelwidth     `"12"'
    local html_abbrev         `""'
    local html_substitute     `""'
    local html_interaction    `"" # ""'
    local html_tstatlab       `"<i>t</i> statistics"'
    local html_zstatlab       `"<i>z</i> statistics"'
    local html_pvallab        `"<i>p</i>-values"'
    local html_cilab          `"\`level'% confidence intervals"'
// - tex
    local tex_open0           `""% `cdate' `ctime'" \documentclass{article} \`texpkgs' \`=cond("\`longtable'"!="","\usepackage{longtable}","")' \begin{document} """'
    local tex_close0          `""" \end{document} """'
    local tex_open            `"\`=cond("\`longtable'"=="", "\begin{table}[htbp]\centering", `"{"')'"'
    local tex_close           `"\`=cond("\`longtable'"=="", "\end{table}", "}")'"'
    local tex_caption         `"\caption{@title}"'
    local tex_open2           `"\`=cond("\`longtable'"!="", "\begin{longtable}", "\begin{tabular" + cond("\`width'"=="", "}", "*}{\`width'}"))'"'
    local tex_close2          `"\`=cond("\`longtable'"!="", "\end{longtable}", "\end{tabular" + cond("\`width'"=="", "}", "*}"))'"'
    local tex_toprule         `"\`="\hline\hline" + cond("\`longtable'"!="", "\endfirsthead\hline\endhead\hline\endfoot\endlastfoot", "")'"'
    local tex_midrule         `""\hline""'
    local tex_bottomrule      `""\hline\hline""'
    local tex_topgap          `""'
    local tex_midgap          `"[1em]"' // `"\\\"'
    local tex_bottomgap       `""'
    local tex_eqrule          `"begin("\hline" "")"'
    local tex_ssl             `"\(N\) \(R^{2}\) "adj. \(R^{2}\)" "pseudo \(R^{2}\)" \textit{AIC} \textit{BIC}"'
    local tex_lsl             `"Observations \(R^{2}\) "Adjusted \(R^{2}\)" "Pseudo \(R^{2}\)" \textit{AIC} \textit{BIC}"'
    local tex_starlevels      `"\sym{*} 0.05 \sym{**} 0.01 \sym{***} 0.001"'
    local tex_starlevlab      `", label(" \(p<@\)")"'
    local tex_begin           `""'
    local tex_delimiter       `"&"'
    local tex_end             `"\\\"'
    local tex_incelldel       `"" ""'
    local tex_varwidth        `"\`= cond("\`label'"=="", 12, 20)'"'
    local tex_modelwidth      `"12"'
    local tex_abbrev          `""'
    local tex_tstatlab        `"\textit{t} statistics"'
    local tex_zstatlab        `"\textit{z} statistics"'
    local tex_pvallab         `"\textit{p}-values"'
    local tex_cilab           `"\`level'\% confidence intervals"'
    local tex_substitute      `"_ \_ "\_cons " \_cons"'
    local tex_interaction     `"" $\times$ ""'
// - booktabs
    local booktabs_open0      `""% `cdate' `ctime'" \documentclass{article} \`texpkgs' \usepackage{booktabs} \`=cond("\`longtable'"!="","\usepackage{longtable}","")' \begin{document} """'
    local booktabs_close0     `"`macval(tex_close0)'"'
    local booktabs_open       `"`macval(tex_open)'"'
    local booktabs_close      `"`macval(tex_close)'"'
    local booktabs_caption    `"`macval(tex_caption)'"'
    local booktabs_open2      `"`macval(tex_open2)'"'
    local booktabs_close2     `"`macval(tex_close2)'"'
    local booktabs_toprule    `"\`="\toprule" + cond("\`longtable'"!="", "\endfirsthead\midrule\endhead\midrule\endfoot\endlastfoot", "")'"'
    local booktabs_midrule    `""\midrule""'
    local booktabs_bottomrule `""\bottomrule""'
    local booktabs_topgap     `"`macval(tex_topgap)'"'
    local booktabs_midgap     `"\addlinespace"'
    local booktabs_bottomgap  `"`macval(tex_bottomgap)'"'
    local booktabs_eqrule     `"begin("\midrule" "")"'
    local booktabs_ssl        `"`macval(tex_ssl)'"'
    local booktabs_lsl        `"`macval(tex_lsl)'"'
    local booktabs_starlevels `"`macval(tex_starlevels)'"'
    local booktabs_starlevlab `"`macval(tex_starlevlab)'"'
    local booktabs_begin      `"`macval(tex_begin)'"'
    local booktabs_delimiter  `"`macval(tex_delimiter)'"'
    local booktabs_end        `"`macval(tex_end)'"'
    local booktabs_incelldel  `"`macval(tex_incelldel)'"'
    local booktabs_varwidth   `"`macval(tex_varwidth)'"'
    local booktabs_modelwidth `"`macval(tex_modelwidth)'"'
    local booktabs_abbrev     `"`macval(tex_abbrev)'"'
    local booktabs_tstatlab   `"`macval(tex_tstatlab)'"'
    local booktabs_zstatlab   `"`macval(tex_zstatlab)'"'
    local booktabs_pvallab    `"`macval(tex_pvallab)'"'
    local booktabs_cilab      `"`macval(tex_cilab)'"'
    local booktabs_substitute `"`macval(tex_substitute)'"'
    local booktabs_interaction `"`macval(tex_interaction)'"'

// syntax
    syntax [anything] [using] [ , ///
 /// coefficients and t-stats, se, etc.
     b Bfmt(string) ///
     noT Tfmt(string) ///
     z Zfmt(string) ///
     se SEfmt(string) ///
     p Pfmt(string) ///
     ci CIfmt(string) ///
     BEta BEtafmt(string) ///
     main(string) /// syntax: name format
     aux(string) /// syntax: name format
     abs  /// absolute t-values
     wide ///
     NOSTAr STAR STAR2(string asis) ///
     staraux ///
     NOCONstant CONstant ///
     COEFlabels(string asis) ///
 /// summary statistics
     noOBS obslast ///
     r2 R2fmt(string) ar2 AR2fmt(string) pr2 PR2fmt(string) ///
     aic AICfmt(string) bic BICfmt(string) ///
     SCAlars(string asis) /// syntax: "name1 [label1]" "name2 [label2]" etc.
     sfmt(string) ///
 /// layout
     NOMTItles MTItles MTItles2(string asis) ///
     NOGAPs GAPs ///
     NOLInes LInes ///
     ADDNotes(string asis) ///
     COMpress ///
     plain ///
     smcl FIXed tab csv SCsv rtf HTMl tex BOOKTabs ///
     Fragment ///
     page PAGE2(str) ///
     ALIGNment(str asis) ///
     width(str asis) ///
 /// other
     Noisily ///
     * ]
    _more_syntax , `macval(options)'
    _estout_options , `macval(options)'

// matrix mode
    MatrixMode, `anything'

// syntax consistency etc
    gettoken chunk using0: using
    if `"`macval(star2)'"'!="" local star star
    foreach opt in constant gaps lines star abbrev depvars numbers parentheses ///
        notes mtitles type outfilenoteoff {
        NotBothAllowed "``opt''" `no`opt''
    }
    NotBothAllowed "`staraux'" `nostar'
    if `"`macval(mtitles2)'"'!="" NotBothAllowed "mtitles" `nomtitles'
    if `"`page2'"'!=""   local page page
    NotBothAllowed "`fragment'" `page'
    if `"`pfmt'"'!=""    local p p
    if `"`zfmt'"'!=""    local z z
    if `"`sefmt'"'!=""   local se se
    if `"`cifmt'"'!=""   local ci ci
    if `"`betafmt'"'!="" local beta beta
    if "`level'"==""     local level $S_level
    if ((("`margin'"!="" | `"`margin2'"'!="") & "`nomargin'"=="") | ///
       ("`beta'"!="") | ("`eform'"!="" & "`noeform'"=="")) ///
       & "`constant'"==""  local noconstant noconstant
    if `"`r2fmt'"'!="" local r2 r2
    if `"`ar2fmt'"'!="" local ar2 ar2
    if `"`pr2fmt'"'!="" local pr2 pr2
    if `"`aicfmt'"'!="" local aic aic
    if `"`bicfmt'"'!="" local bic bic
    if "`type'"=="" & `"`using'"'!="" local notype notype
    local nocellsopt = `"`macval(cells)'"'==""
    if `"`width'"'!="" & `"`longtable'"'!="" {
        di as err "width() and longtable not both allowed"
        exit 198
    }

// format modes
    local mode `smcl' `fixed' `tab' `csv' `scsv' `rtf' `html' `tex' `booktabs'
    if `:list sizeof mode'>1 {
        di as err "only one allowed of smcl, fixed, tab, csv, scsv, rtf, html, tex, or booktabs"
        exit 198
    }
    if `"`using'"'!="" {
        _getfilename `"`using0'"'
        local fn `"`r(filename)'"'
        _getfilesuffix `"`fn'"'
        local suffix `"`r(suffix)'"'
    }
    if "`mode'"=="" {
        if `"`using'"'!="" {
            if inlist(`"`suffix'"', ".html", ".htm") local mode html
            else if `"`suffix'"'==".tex"             local mode tex
            else if `"`suffix'"'==".csv"             local mode csv
            else if `"`suffix'"'==".rtf"             local mode rtf
            else if `"`suffix'"'==".smcl"            local mode smcl
            else local mode fixed
        }
        else local mode smcl
    }
    else {
        if "`mode'"=="scsv" {
            local csv_delimiter `"`macval(`mode'_delimiter)'"'
            local mode "csv"
        }
    }
    if `"`using'"'!="" & `"`suffix'"'=="" {
        if inlist("`mode'","fixed","tab")         local suffix ".txt"
        else if inlist("`mode'","csv","scsv")     local suffix ".csv"
        else if "`mode'"=="rtf"                   local suffix ".rtf"
        else if "`mode'"=="html"                  local suffix ".html"
        else if inlist("`mode'","tex","booktabs") local suffix ".tex"
        else if "`mode'"=="smcl"                  local suffix ".smcl"
        local using `"using `"`fn'`suffix'"'"'
        local using0 `" `"`fn'`suffix'"'"'
    }
    if "`mode'"=="smcl" local smcltags smcltags
    local mode0 `mode'
    if "`mode0'"=="booktabs" local mode0 tex
    else if "`mode0'"=="csv" {
        if "`plain'"=="" local csvlhs `"=""'
        else local csvlhs `"""'
    }
    if "`compress'"!="" {
        if "``mode'_modelwidth'"!="" {
            local `mode'_modelwidth = ``mode'_modelwidth' - 3
        }
        if "``mode'_varwidth'"!="" {
            local `mode'_varwidth = ``mode'_varwidth' - cond("`label'"!="", 4, 2)
        }
    }
    if `"`modelwidth'"'=="" {
        if `nocellsopt' & `"``mode'_modelwidth'"'!="" & "`ci'"!="" {
            local modelwidth = 2*``mode'_modelwidth' - 2
            if "`wide'"!="" local modelwidth "``mode'_modelwidth' `modelwidth'"
        }
        else {
            local modelwidth "``mode'_modelwidth'"
        }
    }
    if `"`varwidth'"'=="" {
        local varwidth "``mode'_varwidth'"
    }
    if "`plain'"=="" & `matrixmode'==0 {
        foreach opt in star depvars numbers parentheses notes {
            SwitchOnIfEmpty `opt' `no`opt''
        }
        if "`wide'"=="" & ("`t'"=="" | "`z'`se'`p'`ci'`aux'"!="") & `nocellsopt'==1 ///
         SwitchOnIfEmpty gaps `nogaps'
    }
    if "`plain'"=="" {
        SwitchOnIfEmpty lines `nolines'
    }
    if `"`lines'"'!="" {
        SwitchOnIfEmpty eqlines `noeqlines'
    }
    if inlist("`mode0'", "tab", "csv") {
        local lines
        local eqlines
    }
    if "`notes'"!="" & "`nolegend'"=="" & `nocellsopt'==1 & `matrixmode'==0 local legend legend
    if "`plain'"!="" {
        if "`bfmt'"==""    local bfmt %9.0g
        if "`tfmt'"==""    local tfmt `bfmt'
        if "`zfmt'"==""    local zfmt `bfmt'
        if "`sefmt'"==""   local sefmt `bfmt'
        if "`pfmt'"==""    local pfmt `bfmt'
        if "`cifmt'"==""   local cifmt `bfmt'
        if "`betafmt'"=="" local betafmt `bfmt'
    }
    //if "`nomtitles'"!="" local depvars
    //else if "`depvars'"=="" local mtitles mtitles

// prepare append for rtf, tex, and html
    local outfilenoteoff2 "`outfilenoteoff'"
    if "`outfilenoteoff2'"=="" local outfilenoteoff2 "`nooutfilenoteoff'"
    if `"`using'"'!="" & "`append'"!="" &  ///
     (("`mode0'"=="rtf" & "`fragment'"=="") | ///
     ("`page'"!="" & inlist("`mode0'", "tex", "html"))) {
        capture confirm file `using0'
        if _rc==0 {
            tempfile appendfile
            if "`mode'"=="rtf" local `mode'_open
            else local `mode'_open0
            local append
            if "`outfilenoteoff2'"=="" local outfilenoteoff2 outfilenoteoff
        }
    }

// cells() option
    if "`notes'"!="" {
        if ("`margin'"!="" | `"`margin2'"'!="") & "`nomargin'"=="" ///
         local thenote "`thenote'Marginal effects"
        if "`eform'"!="" & "`noeform'"=="" ///
         local thenote "`thenote'Exponentiated coefficients"
    }
    if "`bfmt'"=="" local bfmt a3
    if `nocellsopt' & `matrixmode'==0 {
        if "`star'"!="" & "`staraux'"=="" local bstar star
        if "`beta'"!="" {
            if "`main'"!="" {
                di as err "beta() and main() not allowed both"
                exit 198
            }
            if "`betafmt'"==""  local betafmt 3
            local cells fmt(`betafmt') `bstar'
            local cells beta(`cells')
            if "`notes'"!="" {
                if `"`thenote'"'!="" local thenote "`thenote'; "
                local thenote "`thenote'Standardized beta coefficients"
            }
        }
        else if "`main'"!="" {
            tokenize "`main'"
            if "`2'"=="" local 2 "`bfmt'"
            local cells fmt(`2') `bstar'
            local cells `1'(`cells')
            if "`notes'"!="" {
                if `"`thenote'"'!="" local thenote "`thenote'; "
                local thenote "`thenote'`1' coefficients"
            }
        }
        else {
            local cells fmt(`bfmt') `bstar'
            local cells b(`cells')
        }
        if "`t'"=="" | "`z'`se'`p'`ci'`aux'"!="" {
            if "`onecell'"!="" {
                local cells `cells' &
            }
// parse aux option
            tokenize "`aux'"
            local auxname `1'
            local auxfmt `2'
// type of auxiliary statistic
            local aux `z' `se' `p' `ci' `auxname'
            if `"`aux'"'=="" local aux t
            else {
                if `:list sizeof aux'>1 {
                    di as err "only one allowed of z, se, p, ci, and aux()"
                    exit 198
                }
            }
            if !inlist(`"`aux'"', "t", "z")  local abs
// parentheses/brackets
            if "`parentheses'"!="" | "`brackets'"!="" {
                if `"`aux'"'=="ci" {
                    local brackets brackets
                    if "`mode'"!="smcl" | "`onecell'"!="" local paren par
                    else local paren `"par("{ralign @modelwidth:{txt:[}" "{txt:,}" "{txt:]}}")"'
                }
                else if "`brackets'"!="" {
                    if "`mode'"!="smcl" | "`onecell'"!="" local paren "par([ ])"
                    else local paren `"par("{ralign @modelwidth:{txt:[}" "{txt:]}}")"'
                }
                else {
                    if "`mode'"!="smcl" | "`onecell'"!="" local paren par
                    else local paren `"par("{ralign @modelwidth:{txt:(}" "{txt:)}}")"'
                }
            }
// compose note
            if "`notes'"!="" {
                if `"`thenote'"'!="" local thenote "`thenote'; "
                if `"`auxname'"'!="" {
                    local thenote `"`macval(thenote)'`auxname'"'
                }
                else if inlist(`"`aux'"', "t", "z")  {
                    if "`abs'"!="" local thenote `"`macval(thenote)'Absolute "'
                    local thenote `"`macval(thenote)'``mode'_`aux'statlab'"'
                }
                else if `"`aux'"'=="se" {
                    local thenote `"`macval(thenote)'Standard errors"'
                }
                else if `"`aux'"'=="p" {
                    local thenote `"`macval(thenote)'``mode'_pvallab'"'
                }
                else if `"`aux'"'=="ci" {
                    local thenote `"`macval(thenote)'``mode'_cilab'"'
                }
                if "`parentheses'"=="" {
                    if "`wide'"=="" local thenote `"`macval(thenote)' in second row"'
                    else local thenote `"`macval(thenote)' in second column"'
                }
                else if "`brackets'"!="" {
                    local thenote `"`macval(thenote)' in brackets"'
                }
                else local thenote `"`macval(thenote)' in parentheses"'
            }
// formats
            if "`tfmt'"==""     local tfmt 2
            if "`zfmt'"==""     local zfmt 2
            if "`sefmt'"==""    local sefmt `bfmt'
            if "`pfmt'"==""     local pfmt 3
            if "`cifmt'"==""    local cifmt `bfmt'
            if `"`auxfmt'"'=="" local auxfmt `bfmt'
            if `"`auxname'"'=="" {
                local auxfmt ``aux'fmt'
            }
// stars
            if "`staraux'"!="" local staraux star
// put together
            local temp fmt(`auxfmt') `paren' `abs' `staraux'
            local cells `cells' `aux'(`temp')
        }
        if "`wide'"!="" local cells cells(`"`cells'"')
        else            local cells cells(`cells')
    }

// stats() option
    if `"`macval(stats)'"'=="" & `matrixmode'==0 {
        if `"`sfmt'"'=="" local sfmt `bfmt'
        if `"`r2fmt'"'=="" local r2fmt = cond("`plain'"!="", "`bfmt'", "3")
        if `"`ar2fmt'"'=="" local ar2fmt = cond("`plain'"!="", "`bfmt'", "3")
        if `"`pr2fmt'"'=="" local pr2fmt = cond("`plain'"!="", "`bfmt'", "3")
        if `"`aicfmt'"'=="" local aicfmt `bfmt'
        if `"`bicfmt'"'=="" local bicfmt `bfmt'
        if "`label'"=="" {
            local stalabs `"``mode'_ssl'"'
        }
        else {
            local stalabs `"``mode'_lsl'"'
        }
        gettoken obslab stalabs: stalabs
        if "`obs'"=="" & "`obslast'"=="" {
            local sta N
            local stalab `"`"`macval(obslab)'"'"'
            local stafmt %18.0g
        }
        local i 0
        foreach s in r2 ar2 pr2 aic bic {
            local ++i
            if "``s''"!="" {
                local sta `sta' `:word `i' of r2 r2_a r2_p aic bic'
                local chunk: word `i' of `macval(stalabs)'
                local stalab `"`macval(stalab)' `"`macval(chunk)'"'"'
                local stafmt `stafmt' ``s'fmt'
            }
        }
        local i 0
        CheckScalarOpt `macval(scalars)'
        foreach addstat of local scalars {
            local ++i
            gettoken addstatname addstatlabel: addstat
            local addstatlabel = substr(`"`macval(addstatlabel)'"',2,.)
            if `: list posof `"`addstatname'"' in sta' continue
            if `"`addstatname'"'=="N" & "`obs'"=="" & "`obslast'"!="" continue
            if trim(`"`macval(addstatlabel)'"')=="" local addstatlabel `addstatname'
            local addstatfmt: word `i' of `sfmt'
            if `"`addstatfmt'"'=="" {
                local addstatfmt: word `: list sizeof sfmt' of `sfmt'
            }
            local sta `sta' `addstatname'
            local stalab `"`macval(stalab)' `"`macval(addstatlabel)'"'"'
            local stafmt `stafmt' `addstatfmt'
        }
        if "`obs'"=="" & "`obslast'"!="" {
            local sta `sta' N
            local stalab `"`macval(stalab)' `"`macval(obslab)'"'"'
            local stafmt `stafmt' %18.0g
        }
        if "`sta'"!="" {
            local stats stats(`sta', fmt(`stafmt') labels(`macval(stalab)'))
        }
    }

// table header
    if `"`macval(mlabels)'"'=="" {
        if "`mode0'"=="tex" local mspan " span prefix(\multicolumn{@span}{c}{) suffix(})"
        if `"`depvars'"'!="" {
            local mlabels `"mlabels(, depvar`mspan')"'
        }
        if `"`nomtitles'"'!="" local mlabels `"mlabels(none)"'
        if "`mtitles'"!="" {
            local mlabels `"mlabels(, titles`mspan')"'
        }
        if `"`macval(mtitles2)'"'!="" {
            local mlabels `"mlabels(`macval(mtitles2)', titles`mspan')"'
        }
    }
    if `"`macval(collabels)'"'=="" & `nocellsopt' & `matrixmode'==0 & "`plain'"=="" {
        local collabels `"collabels(none)"'
    }
    if "`mode0'"=="tex" & "`numbers'"!="" {
        local numbers "numbers(\multicolumn{@span}{c}{( )})"
    }

// pre-/posthead, pre-/postfoot, gaps and lines
// - complete note
    if `"`macval(thenote)'"'!="" {
        local thenote `"`"`macval(thenote)'"'"'
    }
    if `"`macval(note)'"'!="" {
        local thenote `""@note""'
    }
    if `"`macval(addnotes)'"'!="" {
        if index(`"`macval(addnotes)'"', `"""')==0 {
            local addnotes `"`"`macval(addnotes)'"'"'
        }
        local thenote `"`macval(thenote)' `macval(addnotes)'"'
    }
    if "`legend'"!="" {
        if ("`margin'"!="" | `"`margin2'"'!="") & ///
           "`nomargin'"=="" & "`nodiscrete'"=="" {
            local thenote `"`macval(thenote)' "@discrete""'
        }
        if "`star'"!="" | `nocellsopt'==0 {
            local thenote `"`macval(thenote)' "@starlegend""'
        }
    }
// - mode specific settings
    if "`star'"!="" {
        if `"`macval(star2)'"'!="" {
            FormatStarSym "`mode0'" `"`macval(star2)'"'
            local `mode'_starlevels `"`macval(star2)'"'
        }
        if `"`macval(starlevels)'"'=="" {
            local starlevels `"starlevels(`macval(`mode'_starlevels)'`macval(`mode'_starlevlab)')"'
        }
    }
    foreach opt in begin delimiter end substitute interaction {
        if `"`macval(`opt')'"'=="" & `"``mode'_`opt''"'!="" {
            local `opt' `"`opt'(``mode'_`opt'')"'
        }
    }
    if "`onecell'"!="" {
        if `"`macval(incelldelimiter)'"'=="" {
            local incelldelimiter `"incelldelimiter(``mode'_incelldel')"'
        }
    }
    if "`noabbrev'`abbrev'"=="" {
        local abbrev ``mode'_abbrev'
    }
    if `"`fragment'"'=="" {
        if "`page'"!="" {
            if `"`page2'"'!="" {
                local texpkgs `""\usepackage{`page2'}""'
            }
            local opening `"``mode'_open0'"'
        }
        if `"`macval(title)'"'!="" {
            local opening `"`macval(opening)' ``mode'_open'"'
            if "`mode0'"=="tex" & "`star'"!="" {
                local opening `"`macval(opening)' "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}""'
            }
            if !("`longtable'"!="" & "`mode0'"=="tex") {
                local opening `"`macval(opening)' ``mode'_caption'"'
            }
        }
        else if "`mode0'"=="tex" & "`star'"!="" {
            local opening `"`macval(opening)' "{" "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}""'
        }
        else if "`mode0'"!="tex" {
            local opening `"`macval(opening)' ``mode'_open'"'
        }
        local opening `"`macval(opening)' ``mode'_open2'"'
        if  "`mode0'"=="tex" {
            if `"`labcol2'"'!="" local lstubtex "lc"
            else local lstubtex "l"
            if `"`width'"'!="" local extracolsep "@{\hskip\tabcolsep\extracolsep\fill}"
            if `"`macval(alignment)'"'!="" {
                local opening `"`macval(opening)'{`extracolsep'`lstubtex'*{@E}{`macval(alignment)'}}"'
            }
            else {
                if `nocellsopt' {
                    MakeTeXColspec "`wide'" "`not'" "`star'" "`stardetach'" "`staraux'"
                }
                else {
                    MakeTeXColspecAlt, `cells'
                }
                local opening `"`macval(opening)'{`extracolsep'`lstubtex'*{@E}{`value'}}"'
            }
            if "`longtable'"!="" {
                if `"`macval(title)'"'!="" {
                    local opening `"`macval(opening)' ``mode'_caption'\\\"'
                }
            }
        }
        if "`mode0'"=="html" {
            local brr
            foreach chunk of local thenote {
                local closing `"`macval(closing)' `"`brr'`macval(chunk)'"'"'
                local brr "<br />"
            }
            if `"`macval(closing)'"'!="" {
                local closing `""<tr><td colspan=@span>" `macval(closing)' "</td></tr>""'
            }
        }
        else if "`mode0'"=="tex" {
            foreach chunk of local thenote {
                local closing `"`macval(closing)' `"\multicolumn{@span}{l}{\footnotesize `macval(chunk)'}\\\"'"'
            }
        }
        else if "`mode0'"=="csv" {
            foreach chunk of local thenote {
                local closing `"`macval(closing)' `"`csvlhs'`macval(chunk)'""'"'
            }
        }
        else if "`mode0'"=="rtf" {
            foreach chunk of local thenote {
                local closing `"`macval(closing)' `"{\pard\ql\fs20 `macval(chunk)'\par}"'"'
            }
        }
        else {
            local closing `"`macval(thenote)'"'
        }
        local closing `"`macval(closing)' ``mode'_close2'"'
        if `"`macval(title)'"'!="" | "`mode0'"!="tex" {
            local closing `"`macval(closing)' ``mode'_close'"'
        }
        else if "`mode0'"=="tex" & "`star'"!="" {
            local closing `"`macval(closing)' }"'
        }
        if "`page'"!="" {
            local closing `"`macval(closing)' ``mode'_close0'"'
        }
        local toprule    `"``mode'_toprule'"'
        local bottomrule `"``mode'_bottomrule'"'
        local topgap     `"``mode'_topgap'"'
        local bottomgap  `"``mode'_bottomgap'"'
    }
    local midrule `"``mode'_midrule'"'
    local midgap  `"``mode'_midgap'"'
    local eqrule  `"``mode'_eqrule'"'
// - compose prehead()
    if `"`macval(prehead)'"'=="" {
        if `"`lines'"'!="" {
            local opening `"`macval(opening)' `macval(toprule)'"'
        }
        else if `"`gaps'"'!="" {
            local opening `"`macval(opening)' `macval(topgap)'"'
        }
        SaveRetok `macval(opening)'
        local opening `"`macval(value)'"'
        if `"`macval(opening)'"'!="" {
            local prehead `"prehead(`macval(opening)')"'
        }
    }
// - compose posthead()
    if `"`macval(posthead)'"'=="" {
        if `"`lines'"'!="" {
            local posthead `"posthead(`macval(midrule)')"'
        }
        else if `"`gaps'"'!="" {
            local posthead `"posthead(`macval(midgap)')"'
        }
    }
// - compose prefoot()
    if `"`macval(prefoot)'"'=="" & `"`macval(stats)'"'!="" {
        if `"`lines'"'!="" {
            local prefoot `"prefoot(`macval(midrule)')"'
        }
        else if `"`gaps'"'!="" {
            local prefoot `"prefoot(`macval(midgap)')"'
        }
        if `"`cells'"'=="cells(none)" local prefoot
    }
// - compose postfoot()
    if `"`macval(postfoot)'"'=="" {
        if `"`lines'"'!="" {
            local closing `"`macval(bottomrule)' `macval(closing)'"'
        }
        else if `"`gaps'"'!="" {
            local closing `"`macval(bottomgap)' `macval(closing)'"'
        }
        SaveRetok `macval(closing)'
        local closing `"`macval(value)'"'
        if `"`macval(closing)'"'!="" {
            local postfoot postfoot(`macval(closing)')
        }
    }
// - varlabels
    if `"`macval(varlabels)'"'=="" {
        if `"`gaps'"'!="" {
            local varl `", end("" `macval(midgap)') nolast"'
        }
        if "`label'"!=""  {
            local varl `"_cons Constant`macval(varl)'"'
        }
        if `"`macval(coeflabels)'"'!="" {
            local varl `"`macval(coeflabels)' `macval(varl)'"'
        }
        if trim(`"`macval(varl)'"')!="" {
            local varlabels varlabels(`macval(varl)')
        }
    }
// - equation labels
    if ("`eqlines'"!="" | `"`gaps'"'!="") & "`unstack'"=="" {
        if trim(`"`eqlabels'"')!="none" {
            ParseEqLabels `macval(eqlabels)'
            if `eqlabelsok' {
                _parse comma eqllhs eqlrhs : eqlabels
                if `"`eqlrhs'"'=="" local eqlabelscomma ", "
                else                local eqlabelscomma " "
                if "`eqlines'"!=""{
                    local eqlabels `"`macval(eqlabels)'`eqlabelscomma'`macval(eqrule)' nofirst"'
                }
                else if `"`gaps'"'!="" {
                    local eqlabels `"`macval(eqlabels)'`eqlabelscomma'begin(`macval(midgap)' "") nofirst"'
                }
            }
        }
    }
    if `"`macval(eqlabels)'"'!="" {
        local eqlabels `"eqlabels(`macval(eqlabels)')"'
    }

// noconstant option
    if `"`drop'"'=="" {
        if "`noconstant'"!="" {
            local drop drop(_cons, relax)
        }
    }

// compute beta coefficients (run estadd to add e(beta))
    if "`beta'"!="" {
        local estnames `"`anything'"'
        if `"`estnames'"'=="" {
            capt est_expand $eststo
            if !_rc {
                local estnames `"$eststo"'
            }
        }
        version `caller': estadd beta, replace: `estnames'
    }

// use tempfile for new table
    if `"`appendfile'"'!="" {
        local using `"using `"`appendfile'"'"'
    }

// execute estout
    if `"`varwidth'"'!="" local varwidth `"varwidth(`varwidth')"'
    if `"`modelwidth'"'!="" local modelwidth `"modelwidth(`modelwidth')"'
    if `"`style'"'=="" local style "style(esttab)"
    CleanEstoutCmd `anything' `using' ,  ///
     `macval(cells)' `drop' `nomargin' `margin' `margin2' `noeform' `eform'       ///
     `nodiscrete' `macval(stats)' `stardetach' `macval(starlevels)'               ///
     `varwidth' `modelwidth' `noabbrev' `abbrev' `unstack' `macval(begin)'        ///
     `macval(delimiter)' `macval(end)' `macval(incelldelimiter)' `smcltags'       ///
     `macval(title)' `macval(prehead)' `macval(posthead)' `macval(prefoot)'       ///
     `macval(postfoot)' `label' `macval(varlabels)' `macval(mlabels)' `nonumbers' ///
     `numbers' `macval(collabels)' `macval(eqlabels)' `macval(mgroups)'           ///
     `macval(note)' `macval(labcol2)' `macval(substitute)' `macval(interaction)'  ///
     `append' `notype'`type' `outfilenoteoff2' level(`level') `style'             ///
     `macval(options)'
    if "`noisily'"!="" {
        gettoken chunk rest: cmd, parse(",")
        di as txt _asis `"`chunk'"' _c
        gettoken chunk rest: rest, bind
        while `"`macval(chunk)'"'!="" {
            di as txt _asis `" `macval(chunk)'"'
            gettoken chunk rest: rest, bind
        }
    }
    `macval(cmd)'

// insert new table into existing document (tex, html, rtf)
    if `"`appendfile'"'!="" {
        local enddoctex "\end{document}"
        local enddochtml "</body>"
        local enddocrtf "}"
        local enddoc "`enddoc`mode0''"
        tempname fh
        file open `fh' using `using0', read write
        file seek `fh' query
        local loc = r(loc)
        file read `fh' line
        while r(eof)==0 {
            if `"`line'"'=="`enddoc'" {
                if "`mode'"=="rtf" {
                    file seek `fh' query
                    local loc0 = r(loc)
                    file read `fh' line
                    if r(eof)==0 {
                        local loc = `loc0'
                        continue
                    }
                }
                continue, break
            }
            file seek `fh' query
            local loc = r(loc)
            file read `fh' line
        }
        file seek `fh' `loc'
        tempname new
        file open `new' `using', read
        file read `new' line
        while r(eof)==0 {
            file write `fh' `"`macval(line)'"' _n
            file read `new' line
        }
        file close `fh'
        file close `new'
        if "`outfilenoteoff'"=="" {
            di as txt `"(output written to {browse `using0'})"'
        }
    }
end

program _more_syntax
// using subroutine (rather than second syntax call) to preserve 'using'
    local theoptions ///
        NODEPvars DEPvars ///
        NOPArentheses PArentheses ///
        BRackets ///
        NONOTEs NOTEs /// without s in helpfile
        LONGtable ///
        ONEcell ///
        NOEQLInes ///
        NOOUTFILENOTEOFF outfilenoteoff
    syntax [, `theoptions' * ]
    foreach opt of local theoptions {
        local opt = lower("`opt'")
        c_local `opt' "``opt''"
    }
    c_local options     `"`macval(options)'"'
end

program _estout_options
    syntax [, ///
     Cells(passthru) ///
     Drop(passthru)  ///
 ///  Keep(string asis) ///
 ///  Order(string asis) ///
 ///  REName(passthru) ///
 ///  Indicate(string asis) ///
 ///  TRansform(string asis) ///
 ///  EQuations(passthru) ///
     NOEFORM eform ///EFORM2(string) ///
     NOMargin Margin Margin2(passthru) ///
     NODIscrete /// DIscrete(string asis) ///
 ///  MEQs(string) ///
 ///  NODROPPED dropped DROPPED2(string) ///
     level(numlist max=1 int >=10 <=99) ///
     Stats(passthru) ///
     STARLevels(passthru) ///
 ///  NOSTARDetach ///
     STARDetach ///
 ///  STARKeep(string asis) ///
 ///  STARDrop(string asis) ///
     VARwidth(str) ///
     MODELwidth(str) ///
     NOABbrev ABbrev ///
 ///  NOUNStack
     UNStack ///
     BEGin(passthru) ///
     DELimiter(passthru) ///
     INCELLdelimiter(passthru) ///
     end(passthru) ///
 ///  DMarker(string) ///
 ///  MSign(string) ///
 ///  NOLZ lz ///
     SUBstitute(passthru) ///
     INTERACTion(passthru) ///
     TItle(passthru) ///
     NOLEgend LEgend ///
     PREHead(passthru) ///
     POSTHead(passthru) ///
     PREFoot(passthru) ///
     POSTFoot(passthru) ///
 ///  HLinechar(string) ///
 ///  NOLabel
     Label ///
     VARLabels(passthru) ///
 ///  REFcat(string asis) ///
     MLabels(passthru) ///
     NONUMbers NUMbers ///NUMbers2(string asis) ///
     COLLabels(passthru) ///
     EQLabels(string asis) ///
     MGRoups(passthru) ///
     LABCOL2(passthru) ///
 ///  NOReplace Replace ///
 ///  NOAppend
     Append ///
     NOTYpe TYpe ///
 ///  NOSHOWTABS showtabs ///
 ///  TOPfile(string) ///
 ///  BOTtomfile(string) ///
     STYle(passthru) ///
 ///  DEFaults(string) ///
 ///  NOASIS asis ///
 ///  NOWRAP wrap ///
 ///  NOSMCLTAGS smcltags ///
 ///  NOSMCLRules SMCLRules ///
 ///  NOSMCLMIDRules SMCLMIDRules ///
 ///  NOSMCLEQRules SMCLEQRules ///
     note(passthru) ///
     * ]
    foreach opt in ///
     cells drop noeform eform nomargin margin margin2 nodiscrete ///
     level stats starlevels stardetach varwidth modelwidth unstack ///
     noabbrev abbrev begin delimiter incelldelimiter end substitute ///
     interaction title nolegend legend prehead posthead prefoot postfoot ///
     label varlabels mlabels labcol2 nonumbers numbers collabels eqlabels ///
     mgroups append notype type style note options {
        c_local `opt' `"`macval(`opt')'"'
    }
end

program MatrixMode
    capt syntax [, Matrix(str asis) e(str asis) r(str asis) rename(str asis) ]
    if _rc | `"`matrix'`e'`r'"'=="" {
        c_local matrixmode 0
        exit
    }
    c_local matrixmode 1
end

prog NotBothAllowed
    args opt1 opt2
    if `"`opt1'"'!="" {
        if `"`opt2'"'!="" {
            di as err `"options `opt1' and `opt2' not both allowed"'
            exit 198
        }
    }
end

prog SwitchOnIfEmpty
    args opt1 opt2
    if `"`opt2'"'=="" {
        c_local `opt1' `opt1'
    }
end

prog _getfilesuffix, rclass // based on official _getfilename.ado
    version 8
    gettoken filename rest : 0
    if `"`rest'"' != "" {
        exit 198
    }
    local hassuffix 0
    gettoken word rest : filename, parse(".")
    while `"`rest'"' != "" {
        local hassuffix 1
        gettoken word rest : rest, parse(".")
    }
    if `"`word'"'=="." {
        di as err `"incomplete filename; ends in ."'
        exit 198
    }
    if index(`"`word'"',"/") | index(`"`word'"',"\") local hassuffix 0
    if `hassuffix' return local suffix `".`word'"'
    else           return local suffix ""
end

prog FormatStarSym
    args mode list
    if inlist("`mode'","rtf","html","tex") {
        if "`mode'"=="rtf" {
            local prefix "{\super "
            local suffix "}"
        }
        else if "`mode'"=="html" {
            local prefix "<sup>"
            local suffix "</sup>"
        }
        else if "`mode'"=="tex" {
            local prefix "\sym{"
            local suffix "}"
        }
        local odd 1
        foreach l of local list {
            if `odd' {
                local l `"`"`prefix'`macval(l)'`suffix'"'"'
                local odd 0
            }
            else local odd 1
            local newlist `"`macval(newlist)'`space'`macval(l)'"'
            local space " "
        }
        c_local star2 `"`macval(newlist)'"'
    }
    //else do noting
end

prog CheckScalarOpt
    capt syntax [anything]
    if _rc error 198
end

prog MakeTeXColspec
    args wide not star detach aux
    if "`star'"!="" & "`detach'"!="" & "`aux'"=="" local value "r@{}l"
    else local value "c"
    if "`wide'"!="" & "`not'"=="" {
        if "`star'"!="" & "`detach'"!="" & "`aux'"!="" local value "`value'r@{}l"
        else local value "`value'c"
    }
    c_local value "`value'"
end

prog MakeTeXColspecAlt
    syntax, cells(string asis)
    local count 1
    while `count' {
        local cells: subinstr local cells " (" "(", all count(local count)
    }
    local count 1
    while `"`macval(cells)'"'!="" {
        gettoken row cells : cells, bind
        local size 0
        gettoken chunk row : row, bind
        while `"`macval(chunk)'"'!="" {
            local ++size
            gettoken chunk row : row, bind
        }
        local count = max(`count',`size')
    }
    c_local value: di _dup(`count') "c"
end

prog SaveRetok
    gettoken chunk 0: 0, q
    local value `"`macval(chunk)'"'
    gettoken chunk 0: 0, q
    while `"`macval(chunk)'"'!="" {
        local value `"`macval(value)' `macval(chunk)'"'
        gettoken chunk 0: 0, q
    }
    c_local value `"`macval(value)'"'
end

prog CleanEstoutCmd
    syntax [anything] [using] [ , * ]
    local cmd estout
    if `"`macval(anything)'"'!="" {
        local cmd `"`macval(cmd)' `macval(anything)'"'
    }
    if `"`macval(using)'"'!="" {
        local cmd `"`macval(cmd)' `macval(using)'"'
    }
    if `"`macval(options)'"'!="" {
        local cmd `"`macval(cmd)', `macval(options)'"'
    }
    c_local cmd `"`macval(cmd)'"'
end

prog ParseEqLabels
    syntax [anything] [, Begin(passthru) NOReplace Replace NOFirst First * ]
    c_local eqlabelsok = `"`begin'`noreplace'`replace'`nofirst'`first'"'==""
end
