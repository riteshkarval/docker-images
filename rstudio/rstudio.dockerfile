FROM ocdr/rstudio-verse

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libzmq3-dev \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \ 
        zlib1g-dev \
        libxml2-dev \
        libcurl4-gnutls-dev \
        libgit2-dev \
        rsync \
        software-properties-common \
        unzip \
        nano \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip3 --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
       scipy \
        && \
    python3 -m ipykernel.kernelspec

RUN pip3 install virtualenv

RUN install2.r --error \
    devtools
    
RUN R -e "devtools::install_github('rstudio/tensorflow')"

RUN R -e "library(tensorflow); install_tensorflow(version='1.14')"

RUN R -e "devtools::install_github('rstudio/keras')"

RUN R -e "library(keras); install_keras()"

RUN R -e "install.packages('reticulate')"

RUN R -e "tensorflow::install_tensorflow(extra_packages = 'tensorflow-probability')"

RUN git clone https://github.com/riteshkarval/tensorboard-logger.git && \
    /bin/bash -c "source ~/.virtualenvs/r-reticulate/bin/activate && pip uninstall tensorflow -y && pip install tensorflow==1.14 tensorboard-logger/ && deactivate"

USER dkube

RUN R -e "library(reticulate); py_install(list('scipy','numpy','scikit-learn','pandas','opencv-python','pillow'))"

RUN /bin/bash -c "source ~/.virtualenvs/r-reticulate/bin/activate && pip uninstall tensorflow -y && pip install tensorflow==1.14 tensorboard-logger/ && deactivate"

WORKDIR /home/dkube/

LABEL heritage="dkube"

USER root

RUN rm -rf tensorboard-logger/
