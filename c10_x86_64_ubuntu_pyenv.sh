# x86_64 on Anderson Microsoft Azure Resources

# Ubuntu 22.04.5
# SNIPAR 0.0.22 (also corresponding simulation exercise on snipar.readthedocs.io)
# Python 3.9 installed by pyenv==2.5.7
# venv created with pyenv with python3.9
# PLINK v1.9.0-b.7.7 64-bit (22 Oct 2024)

#######

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
    build-essential \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    libgdbm-dev \
    libnss3-dev \
    liblzma-dev \
    uuid-dev

# installing pyenv
curl -fsSL https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc

exec "$SHELL"

pyenv --version
#> pyenv 2.5.7

# install latest version of python3.9 available through pyenv, see the list of available versions: pyen install --list
pyenv install 3.9.22

pyenv virtualenv 3.9.22 snipar
pyenv activate snipar

pip install --upgrade pip
pip --version
#> pip 25.1.1

pip install snipar