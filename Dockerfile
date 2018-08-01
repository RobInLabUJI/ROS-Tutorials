FROM ros:kinetic-ros-base

# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-tutorials=0.7.1-0xenial-20180516-160001-0800 \
    ros-kinetic-common-tutorials=0.1.10-0xenial-20180516-183933-0800\
    python-pip \
	python3-pip \
    xvfb=2:1.18.4-0ubuntu0.7 \
	x11-apps=7.7+5+nmu1ubuntu1 \
	netpbm=2:10.0-15.3\
    && rm -rf /var/lib/apt/lists/

RUN pip3 install jupyterlab==0.33.4

RUN pip install \
  ipykernel==4.8.2 \
  ipython==5.8.0 \
  matplotlib==2.2.2

RUN python -m ipykernel install

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

CMD ["jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]

# Install cling dependencies
USER root
RUN apt-get update && \
    apt-get install -yq --no-install-recommends git g++ debhelper devscripts gnupg \
    && rm -rf /var/lib/apt/lists/

# Create cling folder
RUN mkdir /cling
RUN chown -R $NB_USER:users /cling
WORKDIR /cling

# Download cling from https://root.cern.ch/download/cling/
USER $NB_USER
COPY download_cling.py download_cling.py
RUN python download_cling.py

# install cling kernel
USER root
WORKDIR /cling/share/cling/Jupyter/kernel
RUN pip3 install -e .
RUN jupyter-kernelspec install cling-cpp14
RUN rm -fr ${HOME}/.local/share

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}

RUN pip3 install bash_kernel
RUN python3 -m bash_kernel.install

USER ${NB_USER}
WORKDIR ${HOME}

ENV PATH="/cling/bin:${PATH}"
