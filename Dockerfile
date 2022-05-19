FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04

#RUN apt-get install ffmpeg libsm6 libxext6  -y
#RUN pip install coloredlogs

# install linux packages and python packages
RUN apt-get upgrade -y
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
#RUN DEBIAN_FRONTEND=noninteractive apt-get install python3.8 python3-pip nano ffmpeg libsm6 libxext6 libxrender-dev libgl1-mesa-glx libglib2.0-0 python3-tk -y
RUN apt-get install python3.8 python3-pip nano ffmpeg libsm6 libxext6 libxrender-dev libgl1-mesa-glx libglib2.0-0 python3-tk -y
RUN pip3 install -U pip
RUN pip3 install future -U
RUN apt install git nano wget htop -y
RUN pip3 install tensorflow pandas matplotlib numpy pillow opencv-python scikit-image numba tqdm cython fire easydict cityscapesscripts pyquaternion coloredlogs

# Install pytorch
#ARG CUDA_VER="110"
#ARG TORCH_VER="1.7.1"
#ARG VISION_VER="0.8.2"

#RUN pip3 install torch==${TORCH_VER} torchvision==${VISION_VER} -f https://download.pytorch.org/whl/cu${CUDA_VER}/torch_stable.html

RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

#-----------------------
# Copy working directory
#-----------------------
ARG WORKSPACE
COPY . ${WORKSPACE}
ENV PYTHONPATH "${PYTHONPATH}:${WORKSPACE}/visualDet3D/"
WORKDIR ${WORKSPACE}

# dependecies from the original repo
RUN ./make.sh
