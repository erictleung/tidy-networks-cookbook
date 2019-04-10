# Install stringr for regular expressions
if(!require("stringr")) {
    install.packages("stringr", repos="http://cran.rstudio.com")
}

template <- readLines("networkscience.ctv")
template <- str_replace_all(template,"<li>" , "<li> \n")
pattern <- "pkg>[[:alnum:]]+[[:alnum:].]*[[:alnum:]]+"
out <- paste0(template, collapse = " ")
pkgs <- stringr::str_extract_all(out, pattern)[[1]]
pkgs <- unique(gsub("^pkg>", "", pkgs))
prPkg <- stringr::str_extract_all(out, "core\">[[:alnum:]]+[[:alnum:].]*[[:alnum:]]+")[[1]]
priority <- unique(gsub("^core\">", "", prPkg))

pkgs <- pkgs[ !pkgs %in% priority] # Remove priority packages
pkgs <- lapply(as.list(sort(pkgs)), function(x) list(package=x))

# Create output
output <- 
    c(paste0('<CRANTaskView>
    <name>NetworkScience</name>
    <topic>Hydrological Data and Modeling</topic>
    <maintainer email="erictleung@outlook.com">Eric Leung</maintainer>
    <version>',Sys.Date(),'</version>'),
    '  <info>',
    paste0("    ",template), 
    '  </info>',
    '  <packagelist>',

    # list priority packages explicitly
    paste0('    <pkg priority="core">', priority, '</pkg>', collapse = "\n"),

    # Add all other packages from `pkgs`
    paste0('    <pkg>', unlist(unname(pkgs)), '</pkg>', collapse = "\n"),

    '  </packagelist>',
    '  <links>',
    '     <view>Spatial</view>',
    '     <view>ReproducibleResearch</view>',
    '     <view>Environmetrics</view>',
    '     <view>ExtremeValue</view>',
    '  </links>',
    '</CRANTaskView>')

writeLines(output, "networkscience.ctv")
