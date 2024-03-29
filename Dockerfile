from jenspetersen/hd-glio-auto:latest

ARG USERNAME="user"
ARG UID="1005"
ARG GID="1005"
ARG PASSWORD="password"
ARG APT_PACKAGES="sudo \
    rsync"
ARG PIP_PACKAGES="pytest \
    torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html \
    notebook \
    nipype \
    ax-platform \
    ray[cluster] \
    ray[tune] \
    setuptools \
    monai==0.7.0 \
    nibabel \
    matplotlib \
    scikit-learn \
    antspyx"

RUN cp /usr/bin/python3 /usr/bin/python && \
    useradd -m -u $UID -U -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME && \
    apt update -y && apt upgrade -y && \
    apt install $APT_PACKAGES -y && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade $PIP_PACKAGES

RUN pip3 install --upgrade tensorboard

COPY ./nrad_torch  /nrad_torch 
RUN cd /nrad_torch && \
    pip install --editable .

USER $USERNAME

ENTRYPOINT [ "/bin/bash" ]
