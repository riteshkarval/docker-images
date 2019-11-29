FROM ocdr/rstudio-base

RUN apt-get update

RUN apt-get update -qq && apt-get -y install \
  libxml2-dev \
  libcairo2-dev \
  libsqlite3-dev \
  libmariadbd-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev 

#RUN wget http://ftp.us.debian.org/debian/pool/main/m/mariadb-client-lgpl/libmariadb-client-lgpl-dev_2.0.0-1_amd64.deb && \
#    mv libmariadb-client-lgpl-dev_2.0.0-1_amd64.deb /var/cache/apt/archives/libmariadb-client-lgpl-dev_2.0.0-1_amd64.deb && \
#    apt install libmariadb-client-lgpl-dev_2.0.0-1_amd64.deb -y

RUN install2.r --error \
    --deps TRUE \
    tidyverse \
    dplyr \
    devtools \
    formatR \
    remotes \
    selectr \
    caTools \
    BiocManager

#RUN apt install libmariadb-client-lgpl-dev -y
