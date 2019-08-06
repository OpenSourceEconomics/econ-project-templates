*! version 1.0.4  09nov2007  Ben Jann

program define _eststo, byable(onecall)
    local caller : di _caller()
    version 8.2
    if "`_byvars'"!="" local by "by `_byvars'`_byrc0' : "
    if inlist(`"`1'"',"clear","dir","drop") {
        version `caller': `by'eststo `0'
    }
    else {
        capt _on_colon_parse `0'
        if !_rc {
            local command `"`s(after)'"'
            if `"`command'"'!="" {
                local command `":`command'"'
            }
            local 0 `"`s(before)'"'
        }
        syntax [anything] [, Esample * ]
        if `"`esample'"'=="" {
            local options `"noesample `options'"'
        }
        if `"`options'"'!="" {
            local options `", `options'"'
        }
        version `caller': `by'eststo `anything'`options' `command'
    }
end
