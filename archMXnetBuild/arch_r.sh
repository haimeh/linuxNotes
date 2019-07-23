sudo pacman -S r
#Rscript -e "install.packages('devtools', repo = 'https://cran.rstudio.com')"
#cd ..
#Rscript -e "install.packages('devtools', repo = 'https://cran.rstudio.com')"
#cd ..

Rscript -e "install.packages('devtools',lib = '/usr/local/lib/R/site-library', repo = 'https://cran.rstudio.com')"

cd mxnet && mkdir -p R-package/inst/libs
cp src/io/image_recordio.h R-package/src
cp -rf lib/libmxnet.so R-package/inst/libs
if [ -e "lib/libmkldnn.so.0" ]; then
	cp -rf lib/libmkldnn.so.0 R-package/inst/libs;
	cp -rf lib/libiomp5.so R-package/inst/libs;
	cp -rf lib/libmklml_intel.so R-package/inst/libs;
fi
if [ -e "lib/libsparse_matrix.so" ]; then
	cp -rf lib/libsparse_matrix.so R-package/inst/libs;
fi

cd mxnet && mkdir -p R-package/inst/include
cp -rl include/* R-package/inst/include
#Rscript -e "install.packages('devtools',lib = '/usr/local/lib/R/site-library', repo = 'https://cran.rstudio.com')"
#Rscript -e " devtools::install_version('roxygen2',version='6.1.1',quiet=TRUE,lib = '/usr/local/lib/R/site-library', repo = 'https://cran.rstudio.com')" && \
Rscript -e "library(devtools); library(methods); options(repos=c(CRAN='https://cran.rstudio.com')); install_deps(pkg='R-package', dependencies = TRUE, upgrade='always')"

# dont forget to remove all referene to recordio and im2rec (including src/mxnet.cc)

cd mxnet && \
cp R-package/dummy.NAMESPACE R-package/NAMESPACE
echo "import(Rcpp)" >> R-package/NAMESPACE
R CMD INSTALL R-package
Rscript -e "require(mxnet); mxnet:::mxnet.export('R-package'); warnings()"
rm R-package/NAMESPACE
Rscript -e "devtools::document('R-package');warnings()"
R CMD INSTALL --build --no-multiarch R-package
