FROM ros:kinetic-ros-base

# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-tutorials \
    ros-kinetic-common-tutorials \
    python-pip \
    && rm -rf /var/lib/apt/lists/

RUN pip install --upgrade pip
RUN pip install jupyter

EXPOSE 8888
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

SHELL ["/bin/bash", "-c"]

CMD ["./launch_jupyter.bash"]
