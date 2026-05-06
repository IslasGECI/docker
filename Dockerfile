FROM rocker/tidyverse:latest
COPY src /install_scripts
USER root
WORKDIR /workdir

# Define variables de entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/lib/shellspec:$PATH"
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PYTHONIOENCODING=utf-8
ENV QT_QPA_PLATFORM=offscreen
ENV TZ=US/Pacific

# Instala paquetes en el sistema operativo
RUN apt update && apt full-upgrade --yes && apt install --yes \
    curl \
    gettext-base \
    git \
    gnumeric \
    jq \
    libcurl4-openssl-dev \
    libssl-dev \
    libuv1 \
    libxml2-dev \
    make \
    neovim \
    openssl \
    python3 \
    python3-dev \
    python3-pip \
    texlive-full \
    xml2 \
        && \
    apt clean

# Usa `python3` como la versión _default_ de Python
RUN ln --symbolic /usr/bin/python3 /usr/bin/python

# Instala modulos con pip
RUN pip install \
    csvkit \
    git+https://github.com/IslasGECI/geci_cli.git@main \
    git+https://github.com/IslasGECI/pythontex_tools.git@main \
    goodtables \
    pygments

# Instala paquetes de R
RUN Rscript -e "install.packages(c('covr', 'lintr', 'styler', 'vdiffr'), repos='http://cran.rstudio.com')"

# Instala ShellSpec
RUN /install_scripts/install_shellspec.sh

# Instala repo de queries
RUN git clone https://github.com/IslasGECI/queries.git && \
    cd queries && \
    make install && \
    cd .. && \
    rm --recursive queries

# Inicia `bash` después de agregar permisos de escritura y ejecución para todos
CMD ["bash", "-c", "umask 000 && bash"]
