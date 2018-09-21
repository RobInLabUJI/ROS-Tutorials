FROM ros:kinetic-ros-base

# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-tutorials \
    ros-kinetic-common-tutorials \
    python-pip \
    xvfb=2:1.18.4-0ubuntu0.7 \
	x11-apps=7.7+5+nmu1ubuntu1 \
	netpbm=2:10.0-15.3\
    && rm -rf /var/lib/apt/lists/

RUN pip install --upgrade pip==18.0
RUN pip install \
  notebook==5.6.0 \
  ipywidgets==7.3.0 \
  ipykernel==4.8.2 \
  matplotlib==2.2.2 \
  jupyterlab==0.33.4

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

CMD ["jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
