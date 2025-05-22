# x86_64 on Anderson Microsoft Azure Resources

# Ubuntu 22.04.5
# SNIPAR 0.0.22 (also corresponding simulation exercise on snipar.readthedocs.io)
# Python 3.9 installed by pyenv==2.5.7
# venv created with pyenv with python3.9
# PLINK v1.9.0-b.7.7 64-bit (22 Oct 2024)

#######

pyenv install 3.9.18
pyenv virtualenv 3.9.18 snipar
pyenv activate snipar
pip install --upgrade pip
pip --version
#> pip 25.1.1

# I could not install snipar using pyenv env and pip




