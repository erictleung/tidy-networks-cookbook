# Source code modified from
# https://github.com/ropensci/Hydrology/blob/master/buildxml.R

# Install stringr for regular expressions
if(!require("stringr")) {
    install.packages("stringr", repos="http://cran.rstudio.com")
}

template <- readLines("NetworkScience.ctv")
template <- str_replace_all(template,"<li>" , "<li> \n")

# Search for all package names surrounded by pkg tags
pattern <- "pkg>[[:alnum:]]+[[:alnum:].]*[[:alnum:]]+"
out <- paste0(template, collapse = " ")
pkgs <- stringr::str_extract_all(out, pattern)[[1]]
pkgs <- unique(gsub("^pkg>", "", pkgs))
prPkg <- stringr::str_extract_all(
    out,
    "core\">[[:alnum:]]+[[:alnum:].]*[[:alnum:]]+")[[1]]
priority <- unique(gsub("^core\">", "", prPkg))

pkgs <- pkgs[ !pkgs %in% priority] # Remove priority packages
pkgs <- lapply(as.list(sort(pkgs)), function(x) list(package=x))

# Create output
output <-
    c(paste0('<CRANTaskView>
    <name>NetworkScience</name>
    <topic>Network Data and Modeling</topic>
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
    '     <view>ReproducibleResearch</view>',
    '     <view>Environmetrics</view>',
    '     <a href="http://snap.stanford.edu/data/index.html">Stanford Large Network Dataset Collection</a>',
    '     <a href="http://networkdata.ics.uci.edu/index.php">UCI Network Data Repository</a>',
    '     <a href="networkrepository.com">Network Repository</a>',
    '     <a href="http://socialcomputing.asu.edu/pages/datasets">Arizona State University Social Computing Data Repository</a>',
    '     <a href="http://cnets.indiana.edu/resources/data-repository/">Indiana University CNetS Data Repository</a>',
    '     <a href="http://konect.uni-koblenz.de/">The Koblenz Network Collection</a>',
    '     <a href="http://www.sociopatterns.org/datasets/">SocioPatterns Datasets</a>',
    '     <a href="https://sites.google.com/site/ucinetsoftware/datasets">UCINET Formatted Data Repository</a>',
    '     <a href="http://vlado.fmf.uni-lj.si/pub/networks/data/">Pajek Network Datasets</a>',
    '  </links>',
    '</CRANTaskView>')

writeLines(output, "NetworkScience.ctv")
