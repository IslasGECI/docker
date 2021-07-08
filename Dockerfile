FROM rocker/tidyverse:4.1.0
USER root
WORKDIR /workdir

# Define variables de entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8
ENV QT_QPA_PLATFORM=offscreen
ENV TZ=US/Pacific

# Instala paquetes en el sistema operativo
RUN apt-get update && apt-get install --yes --no-install-recommends apt-utils
RUN apt-get update && apt-get install --yes --no-install-recommends \
    curl \
    docker.io \
    gettext-base \
    git \
    gnumeric \
    jq \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    make \
    openssl \
    python3 \
    python3-dev \
    python3-pip \
    texlive-full \
    vim \
    xml2 \
        && \
    apt clean

# Usa `python3` como la versión _default_ de Python
RUN ln --symbolic /usr/bin/python3 /usr/bin/python && \
    ln --symbolic /usr/bin/pip3 /usr/bin/pip

# Instala modulos con pip
RUN pip install \
    csvkit \
    git+https://github.com/IslasGECI/bootstrapping_tools.git \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.2.1 \
    git+https://github.com/IslasGECI/geci_cli.git@v0.1.0 \
    git+https://github.com/IslasGECI/geci_plots.git \
    goodtables \
    matplotlib \
    numpy \
    pandas \
    pygments \
    scipy

# Instala repo de bats
RUN git clone https://github.com/bats-core/bats-core.git && \
    cd bats-core && \
    ./install.sh /usr/local

# Instala repo de queries
RUN git clone https://github.com/IslasGECI/queries.git && \
    cd queries && \
    make install && \
    cd .. && \
    rm --recursive queries

# Inicia `bash` después de agregar permisos de escritura y ejecución para todos
CMD ["bash", "-c", "umask 000 && bash"]
