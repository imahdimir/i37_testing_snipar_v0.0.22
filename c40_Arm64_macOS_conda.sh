# x86_64 on Anderson Microsoft Azure Resources

# Ubuntu 22.04.5
# SNIPAR 0.0.22 (also corresponding simulation exercise on snipar.readthedocs.io)
# Python 3.9 installed by pyenv==2.5.7
# venv created with pyenv with python3.9
# PLINK v1.9.0-b.7.7 64-bit (22 Oct 2024)

#######

conda create -n py3922 python=3.9.22 -c conda-forge
conda activate py3922
python --version
#> Python 3.9.22
pip --version
#> pip 25.1.1 from /opt/anaconda3/envs/py3922/lib/python3.9/site-packages/pip (python 3.9)

pip install snipar
# didn't work, there is a problem with numpy

# trying to install precompliled numpy using conda
conda install numpy
