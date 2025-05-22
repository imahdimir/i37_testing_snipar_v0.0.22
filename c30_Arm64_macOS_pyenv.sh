# snipar==0.0.22
# Python 3.9 installed by pyenv
# venv created with pyenv with python3.9

#######

pyenv install 3.9.18
pyenv virtualenv 3.9.18 snipar
pyenv activate snipar
pip install --upgrade pip
pip --version
#> pip 25.1.1

pip install snipar
# I could not install snipar using pyenv env and pip
#       ERROR: Failed to build installable wheels for some pyproject.toml based projects (numpy)
#       [end of output]
  
#   note: This error originates from a subprocess, and is likely not a problem with pip.
# error: subprocess-exited-with-error

# × pip subprocess to install build dependencies did not run successfully.
# │ exit code: 1
# ╰─> See above for output.
pip install numpy --no-build-isolation
