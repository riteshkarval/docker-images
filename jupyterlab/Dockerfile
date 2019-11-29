FROM tensorflow/tensorflow:1.14.0-py3-jupyter

RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        git \
        apt-utils \
        python3-pip \
        python3-dev \
        libsm6 \
        libxext6 \
        nodejs \
        npm 

RUN export DEBIAN_FRONTEND=noninteractive

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN apt install git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn -y

RUN dpkg-reconfigure --frontend noninteractive tzdata


#PROCESSING
RUN pip3 install scoop && \
    pip3 install multiprocessing_generator


#GRAPHING
RUN pip3 install plotly && \
#    pip install python-igraph && \
    pip3 install seaborn && \
    pip3 install altair && \
    pip3 install git+https://github.com/jakevdp/JSAnimation.git && \
    pip3 install bokeh

#TEXT PROCESSING
RUN pip3 install textblob && \
    pip3 install git+git://github.com/amueller/word_cloud.git && \
    pip3 install toolz cytoolz && \
    pip3 install gensim && \
    pip3 install bs4


#DATA
RUN pip3 install h5py && \
    pip3 install pyexcel-ods && \
    pip3 install pandas-profiling

#IMAGE
RUN apt-get install --no-install-recommends -y  \
    ffmpeg \
    imagemagick

RUN pip3 install pydicom && \
    pip3 install scikit-image && \
    pip3 install opencv-python && \
    pip3 install ImageHash

#LEARNING
RUN apt-get install pandoc --no-install-recommends -y && \
    pip3 install pypandoc && pip3 install deap && pip3 install scikit-learn && \
    pip3 install git+https://github.com/tflearn/tflearn.git

RUN cd /usr/local/src && mkdir keras && cd keras && \
    #keras
    git clone --depth 1 https://github.com/fchollet/keras.git && \
    cd keras && python setup.py install && \
    #keras-rl
    cd /usr/local/src && mkdir keras-rl && cd keras-rl && \
    git clone --depth 1 https://github.com/matthiasplappert/keras-rl.git && \
    cd keras-rl && python setup.py install && \
    # Keras likes to add a config file in a custom directory when it's first imported. This doesn't work with our read-only filesystem, so we have it done now
    python -c "from keras.models import Sequential"  && \
    # Switch to TF backend
    sed -i 's/theano/tensorflow/' /root/.keras/keras.json  && \
    # Re-run it to flush any more disk writes
    python -c "from keras.models import Sequential; from keras import backend;" && \
    # Keras reverts to /tmp from ~ when it detects a read-only file system
    mkdir -p /tmp/.keras && cp /root/.keras/keras.json /tmp/.keras &&\
    cd /usr/local/src/keras/keras/ && python3 setup.py install && \
    cd /usr/local/src/keras-rl/keras-rl/ && python3 setup.py install && \
    rm -rf /usr/local/src/*

#MISC
RUN pip3 install tensorflow_hub==0.3.0 &&\
    pip3 install Cython &&\
    pip3 install tensornets &&\
    pip3 install requests

#AUDIO
RUN apt-get install -y --no-install-recommends libsndfile1 && \
    pip3 install librosa

#Object detection
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata unzip && \
    apt-get -y install --no-install-recommends  python3-tk wget && \
    pip3 install absl-py && \
    pip3 install matplotlib && \
    pip3 install pillow && \
    pip3 install pycocotools && \
    cd /usr/local/src && mkdir obj-det && cd obj-det && \
    git clone https://github.com/tensorflow/models.git && \
    cd /usr/local/src/obj-det/models/research/ && \
    wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip && \
    unzip protobuf.zip && \
    ./bin/protoc object_detection/protos/*.proto --python_out=. && \
    cd /usr/local/src/obj-det/models/research/object_detection && \
    rm -rf test_ckpt test_data test_images dockerocjupyterlabfiles g3doc data && \
    cd /usr/local/src/obj-det/models/research/ && \
    cp -r object_detection /usr/local/lib/python3.6/dist-packages/ && \
    cp -r slim/nets /usr/local/lib/python3.6/dist-packages/ && \
    rm -rf /usr/local/src/*

# Installing jupyterlab
RUN pip3 install jupyterlab && \
    pip3 install jupyterlab[extras] && \
    pip3 install jupyterlab-github && \
    pip3 install jupyterlab_github 

# Installing git extension for jupyterlab
RUN cd /usr/local/src && mkdir jupyterlab_git && cd jupyterlab_git && \
    git clone https://github.com/riteshkarvaloc/jupyterlab-git.git && \
    pip3 install jupyterlab-git/ && \
    jupyter lab build

RUN cd /usr/local/src && mkdir tensorboard_logger && cd tensorboard_logger && \
    git clone https://github.com/riteshkarval/tensorboard-logger.git && \
    pip3 install tensorboard-logger/
    
RUN jupyter labextension install @jupyterlab/github
RUN jupyter labextension install @jupyterlab/google-drive

RUN jupyter serverextension enable --py jupyterlab_git --system

RUN jupyter serverextension enable --py jupyterlab_github --system


#CLEANUP
RUN rm -rf /root/.cache/pip/* && \
    rm -rf /root/.cache/pip3/* && \
    apt-get autoremove -y && \
    apt-get clean

#RUN apt-get -y install --no-install-recommends ipython3
RUN pip3 install ipykernel
RUN useradd -m dkube && echo "dkube:dkube" | chpasswd && adduser dkube sudo
RUN usermod -aG sudo dkube
RUN echo 'dkube ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dkube

WORKDIR /home/dkube/
LABEL heritage="dkube"
RUN python3 -m ipykernel install --user
RUN mkdir /home/dkube/.jupyter/
COPY bashrc .bashrc
RUN jupyter notebook --generate-config
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root"]
