// Save a data signature calculated the old (pre-10) way
// in a file passed as the first and only command.


program save_signature
    version 9
    syntax anything [, *]

    // filename is trimmed first argument, no checking for anything.
    local filename = trim("`1'")

    // Stata's "version control" does not work, do it manually
    if c(stata_version) < 10 {
        qui datasignature
    }
    else {
        qui _datasignature
    }
    local sig_val = r(datasignature)

    // write signature to file
    qui file open sig_file using "`filename'", write replace
    file write sig_file "`sig_val'"
    file close sig_file

end
