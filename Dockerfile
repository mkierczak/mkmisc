FROM rstudio/r-base:4.0.2-xenial AS builder
MAINTAINER Marcin Kierczak <marcin.kierczak_ANTISPAM_scilifelab.se>
ENV RENV_VERSION 0.12.0

RUN apt update -y && apt install -y \
  libssl-dev \
  libxml2-dev

RUN mkdir project
RUN mkdir project/scripts

WORKDIR project/
COPY renv.lock renv.lock

RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e 'renv::restore()'

WORKDIR project/scripts/
COPY to_docker/* .
