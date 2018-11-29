# Based on guidance from 
# https://towardsdatascience.com/a-working-environment-for-geospatial-analysis-with-docker-python-and-postgresql-670c2be58e0a
FROM ubuntu:18.04

LABEL maintainer="Cord Thomas <cord.thomas@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing
RUN apt-get install -y wget \
	bzip2 \
	ca-certificates \
	build-essential \
	curl \
	git-core \
	pkg-config \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python3-virtualenv \
        vim \
        mlocate \
	unzip \
	software-properties-common \
	llvm \
        libspatialindex-c4v5

RUN apt install -y gdal-bin python-gdal python3-gdal

## Install packages to Python3
RUN pip3 install --upgrade pip
RUN pip3 install numpy==1.15.4 scipy pandas geopandas psycopg2 sqlalchemy osmnx 
RUN pip3 install --no-binary shapely==1.6.4.post2, fiona shapely==1.6.4.post2 fiona

## Setup File System
RUN mkdir /ds
ENV HOME=/ds
ENV SHELL=/bin/bash
VOLUME /ds
WORKDIR /ds

RUN mkdir /ds/src
RUN mkdir /ds/Data

# Now we install the python3 graph-tool
# From https://towardsdatascience.com/a-working-environment-for-geospatial-analysis-with-docker-python-and-postgresql-670c2be58e0a
# Create the file docker.list
RUN touch /etc/apt/sources.list.d/docker.list

# Populate the file with the to links to the graph-tool server
RUN echo "deb http://downloads.skewed.de/apt/bionic bionic universe" >> /etc/apt/sources.list.d/docker.list
RUN echo "deb-src http://downloads.skewed.de/apt/bionic bionic universe" >> /etc/apt/sources.list.d/docker.list

# Verify the package and update
RUN apt-key adv --keyserver pgp.skewed.de --recv-key 612DEFB798507F25
RUN apt-key list
RUN apt-get update

# Install the package
RUN apt-get install -y python3-graph-tool

# Update the file index - i use a lot
RUN updatedb

CMD ["/bin/bash"]


