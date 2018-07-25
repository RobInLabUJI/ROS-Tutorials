FROM ros:kinetic-ros-base

# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-tutorials=0.7.1-0xenial-20180516-160001-0800 \
    ros-kinetic-common-tutorials=0.1.10-0xenial-20180516-183933-0800\
    python-pip \
    xvfb=2:1.18.4-0ubuntu0.7 \
    && rm -rf /var/lib/apt/lists/

RUN pip install --upgrade pip
RUN pip install \
  notebook==5.6.0 \
  ipywidgets==7.3.0 \
  ipykernel==4.8.2 \
  matplotlib==2.2.2 \
  scipy

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}
