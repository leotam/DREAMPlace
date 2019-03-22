FROM pytorch/pytorch:1.0.1-cuda10.0-cudnn7-devel

RUN conda install cmake boost

RUN apt-get update && apt-get install -y vim \
	tmux \
	locate \
	git \
	gfortran \
	libcairo2-dev \
	flex \
	bison 

ENV HOME=/home
WORKDIR $HOME

RUN git clone --recursive https://github.com/limbo018/DREAMPlace.git
WORKDIR $HOME/DREAMPlace
RUN pip install -r requirements.txt 

RUN mkdir $HOME/DREAMPlace/build
WORKDIR $HOME/DREAMPlace/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/home .. && make && make install

