sudo apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    atlas-base-dev \
    libcurl4-openssl-dev \
    libjemalloc-dev \
    liblapack-dev u
    libopenblas-dev \
    libopencv-dev \
    libzmq3-dev \
    ninja-build \
    python-dev \
    python3-dev \
    software-properties-common \
    sudo \
    unzip \
    virtualenv \
    wget

wget -nv https://bootstrap.pypa.io/get-pip.py
echo "Installing for Python 3..."
sudo python3 get-pip.py
pip3 install --user -r requirements.txt
echo "Installing for Python 2..."
sudo python2 get-pip.py
pip2 install --user -r requirements.txt

cd ../../

echo "Checking for GPUs..."
gpu_install=$(which nvidia-smi | wc -l)
if [ "$gpu_install" = "0" ]; then
    make_params="USE_OPENCV=1 USE_BLAS=openblas USE_CPP_PACKAGE=1"
    echo "nvidia-smi not found. Installing in CPU-only mode with these build flags: $make_params"
else
    make_params="USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1"
    echo "nvidia-smi found! Installing with CUDA and cuDNN support with these build flags: $make_params"
fi

echo "Building MXNet core. This can take few minutes..."
make -j $(nproc) $make_params
