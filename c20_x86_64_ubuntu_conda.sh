# x86_64 on Anderson Microsoft Azure Resources

# Ubuntu 22.04.5
# SNIPAR 0.0.22 (also corresponding simulation exercise on snipar.readthedocs.io)
# Python 3.9 installed by pyenv==2.5.7
# venv created with pyenv with python3.9
# PLINK v1.9.0-b.7.7 64-bit (22 Oct 2024)

#######

sudo apt update
sudo apt upgrade -y
sudo apt install build-essential


# install Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh

# verify the installer
sha256sum Anaconda3-2024.10-1-Linux-x86_64.sh

bash Anaconda3-2024.10-1-Linux-x86_64.sh
# going through the installation process

# create a conda environment with python 3.9.22
conda create -n py3922 python=3.9.22 -c conda-forge
conda activate py3922

python --version
#> Python 3.9.22
pip --version
#> pip 25.1.1

pip install snipar
# installed successfully

python -m unittest snipar.tests
#> Ran 23 tests in 202.459s

#> OK
