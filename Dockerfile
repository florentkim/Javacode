# Utilise l'image officielle Ubuntu 25.10
FROM ubuntu:25.10

# Met à jour le système et installe les dépendances
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl gnupg sudo bash git build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev

# Crée l'utilisateur "devuser" avec les droits sudo
RUN id -u devuser &>/dev/null || useradd -ms /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#RUN useradd -ms /bin/bash devuser && echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Définit l'utilisateur par défaut
USER devuser
WORKDIR /home/devuser

# Personnalise le prompt bash
RUN echo "export PS1='\u@\h:\w\$ '" >> ~/.bashrc && \
    echo "alias ll='ls -l --color=auto'" >> ~/.bashrc

# Installe Node.js LTS et npm via NodeSource
USER root
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    node -v && npm -v

# Installe pip et le module binance
RUN apt-get install -y python3-pip && \
    pip3 install python-binance

# Installe pyenv pour devuser
USER devuser
ENV PYENV_ROOT="/home/devuser/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Point d'entrée
CMD [ "bash" ]