# Instruction for Dockerfile to create a new image on top of the base image of nvidia/cuda
# pytorch and tensorflow are installed in the conda env, i.e., base

# change BASE accordingly. From https://hub.docker.com/r/nvidia/cuda
ARG BASE=nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04
FROM $BASE

# change BASE accordingly
ARG USER=sjtu
ARG PASSWORD=sjtu123456
ARG UID=1000
ARG GID=1000

# Setup timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# necessary update
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC && \
    apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates git openssh-server sudo vim curl libpam-cracklib tzdata dumb-init screen && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

#-------- add a new user --------
RUN addgroup --gid ${GID} ${USER} && \
    adduser --uid ${UID} --gid ${GID} --gecos "" --disabled-password ${USER} && \
    usermod -G root,sudo ${USER} && \
    echo "${USER}:${PASSWORD}" | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# switch user
ENV PATH "/home/$USER/.local/bin:$PATH"
USER ${USER}
WORKDIR /home/${USER}
ENV PATH=/home/${USER}/.conda/bin:$PATH \
    HOME=/home/${USER}

# for ssh connection
RUN mkdir -p /home/${USER}/.local/my_sshd && \
    ssh-keygen -f /home/${USER}/.local/my_sshd/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /home/${USER}/.local/my_sshd/ssh_host_dsa_key -N '' -t dsa && \
    echo "Port 22" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "HostKey /home/${USER}/.local/my_sshd/ssh_host_rsa_key" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "HostKey /home/${USER}/.local/my_sshd/ssh_host_dsa_key" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "AuthorizedKeysFile  .ssh/authorized_keys" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "ChallengeResponseAuthentication no" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "UsePAM yes" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "Subsystem   sftp    /usr/lib/sftp-server" >> /home/${USER}/.local/my_sshd/sshd_config && \
    echo "PidFile /home/${USER}/.local/my_sshd/sshd.pi" >> /home/${USER}/.local/my_sshd/sshd_config

# Install miniconda (python)
# See https://docs.conda.io/projects/miniconda/en/latest/miniconda-other-installer-links.html
RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py310_23.5.2-0-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    /bin/bash ./miniconda.sh -b -p /home/${USER}/.conda && \
    rm ~/miniconda.sh && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    pip config set global.index-url https://pypi.mirrors.ustc.edu.cn/simple && \
    pip install --upgrade pip

# # install ipykernel, pytorch
RUN --mount=type=cache,mode=0777,target=/home/${USER}/.cache,uid=${UID},gid=${GID} \
    pip install ipykernel && \
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128 && \
    pip install transformers scipy SentencePiece accelerate bitsandbytes && \
    conda init

# allow utf-8 characters in terminal
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install frequently used packages
RUN --mount=type=cache,mode=0777,target=/home/${USER}/.cache,uid=${UID},gid=${GID} \
    pip install pandas scikit-learn tqdm 

EXPOSE 22 1000 1001 1002

COPY ./entrypoint.sh ${HOME}/.entrypoint.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--"] 
CMD bash ${HOME}/.entrypoint.sh
