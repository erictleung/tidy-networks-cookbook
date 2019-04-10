all : README.md

NetworkScience.ctv : NetworkScience.md buildxml.R
	pandoc -w html --wrap=none -o NetworkScience.ctv NetworkScience.md
	R -e 'source("buildxml.R")'

NetworkScience.html : NetworkScience.ctv
	R -e 'if(!require("ctv")) install.packages("ctv", repos = "http://cran.rstudio.com/"); ctv::ctv2html("NetworkScience.ctv")'

README.md : NetworkScience.html
	pandoc -w gfm --wrap=none -o README.md NetworkScience.html
	sed -i.tmp -e 's|( \[|(\[|g' README.md
	sed -i.tmp -e 's| : |: |g' README.md
	sed -i.tmp -e 's|../packages/|http://cran.rstudio.com/web/packages/|g' README.md
	rm *.tmp])])'

check :
	R -e 'if(!require("ctv")) install.packages("ctv", repos = "http://cran.rstudio.com/"); print(ctv::check_ctv_packages("NetworkScience.ctv", repos = "http://cran.rstudio.com/"))'

checkurls :
	R -e 'source("checkurls.R")'

README.html : README.md
	pandoc --from=gfm -o README.html README.md

.PHONY = check all
