
sudo pacman -Sy \
git \
cmake \
libjpeg-turbo \
libtiff \
libgdiplus \
libfftw3-dev \
libx11 \
base-devel \
openblas \
lapack \
opencv \
libatlas-base-dev \
cairo \
curl \
openssl \
libxml2 \
libxt \
nvidia \
cuda \
cudnn \
cblas \
gcc-fortran\
r


cd /home/jaimerilian/Documents/
git clone --recursive https://github.com/apache/incubator-mxnet mxnet
cd /home/jaimerilian/Documents/mxnet/


make -j 8 \
	USE_OPENCV=0 \
	USE_BLAS=blas \
	USE_CPP_PACKAGE=0 \
	USE_CUDA=1 \
	USE_CUDA_PATH=/opt/cuda \
	USE_CUDNN=1 \
	USE_LAPACK=1 \
	USE_GPERFTOOLS=0 \
	USE_JEMALLOC=0 \
	ADD_LDFLAGS+=-L/opt/cuda/lib64/stubs \
	ADD_LDFLAGS+=-lcblas


mkdir -p R-package/inst/libs

##cp src/io/image_recordio.h R-package/src
#rm R-package/src/im2rec.cc R-package/src/im2rec.h
## sed '2d' file.txt would delete second line
#sed '$(grep -n "im2rec" mxnet.cc | cut -fi -d)d'
## this removes the @export line, just above im2rec which semi disables the function
#sed '$(expr $(grep -n "im2rec" utils.R | cut -fi -d) - 1)d'


cp -rf lib/libmxnet.so R-package/inst/libs
if [ -e "lib/libmkldnn.so.0" ]; then
	cp -rf lib/libmkldnn.so.0 R-package/inst/libs;
	cp -rf lib/libiomp5.so R-package/inst/libs;
	cp -rf lib/libmklml_intel.so R-package/inst/libs;
fi
if [ -e "lib/libsparse_matrix.so" ]; then
	cp -rf lib/libsparse_matrix.so R-package/inst/libs;
fi

mkdir -p R-package/inst/include

cp -rl include/* R-package/inst/include
Rscript -e "install.packages('devtools', repo = 'https://cran.rstudio.com')"
Rscript -e " devtools::install_version('roxygen2',version='6.1.1',quiet=TRUE, repo = 'https://cran.rstudio.com')" && \
Rscript -e "library(devtools); library(methods); options(repos=c(CRAN='https://cran.rstudio.com')); install_deps(pkg='R-package', dependencies = TRUE, upgrade='always')"

cp R-package/dummy.NAMESPACE R-package/NAMESPACE
echo "import(Rcpp)" >> R-package/NAMESPACE
R CMD INSTALL R-package
Rscript -e "require(mxnet); mxnet:::mxnet.export('R-package'); warnings()"
rm R-package/NAMESPACE
Rscript -e "devtools::document('R-package');warnings()"
R CMD INSTALL --build --no-multiarch R-package
