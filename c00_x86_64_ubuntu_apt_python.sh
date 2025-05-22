

#######

# installed python is 3.10 I need to install python3.9
# python install from Ubuntu repos to install python 3.9

sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# Install Python 3.9 and its development packages
sudo apt install -y python3.9
sudo apt install -y python3.9-dev
sudo apt install -y python3.9-venv
sudo apt install -y python3-pip


# verify python3.9 installation
python3.9 --version
#> Python 3.9.22

# create a virtual environment
python3.9 -m venv ~/env_python39
# activate the virtual environment
source ~/env_python39/bin/activate

python3.9 --version
#> Python 3.9.22

pip --version
#> pip 23.0.1 from /home/azureuser/env_python39/lib/python3.9/site-packages/pip (python 3.9)

# upgrade pip
pip install --upgrade pip

pip --version
#> pip 25.1.1 from /home/azureuser/env_python39/lib/python3.9/site-packages/pip (python 3.9)'

pip install snipar
#> Successfully installed snipar-0.0.22

python -m unittest snipar.tests
#> ran 23 tests in 100.259s
#>OK
#only 1 WARNING: WARNING preprocess_data - prepare_gts: with chromosomes ['1']: unphased genotypes has values out of 0-2 range

# simulation exercise
source ~/env_python39/bin/activate
mkdir sim
simulate.py 1000 0.5 sim/ --nfam 3000 --impute --n_am 20 --r_par 0.5 --save_par_gts
# ran OK

tail pedigree.txt
# saw the 21_2999_1 at the end of the pedigree file

gwas.py phenotype.txt --pedigree pedigree.txt --bed chr_@ --grm last_gen_rel.seg --out chr_@_sibdiff --cpus 1
# ran OK
#> Time used: 4.73s

# installing plink 1.9 - 20241022 version
cd ..
wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20241022.zip
sudo apt install unzip
unzip plink_linux_x86_64_20241022.zip
sudo mv plink /usr/local/bin/
# restarting bash
# to make sure the new plink is in the path
source ~/.bashrc
source ~/env_python39/bin/activate
plink --version
#> PLINK v1.9.0-b.7.7 64-bit (22 Oct 2024)

cd sim
plink --bfile chr_1 --bmerge chr_1_par --out chr_1_combined
#>Merged fileset written to chr_1_combined.bed + chr_1_combined.bim + chr_1_combined.fam 

gwas.py phenotype.txt --pedigree pedigree.txt --bed chr_@_combined --grm last_gen_rel.seg --out chr_@_trio
# ran OK
#> Time used: 5.14s

zless -S chr_1_trio.sumstats.gz
# saw the summary statistics was OK
# to quit press q

# Imputing missing parental genotypes
impute.py --ibd chr_@ --bed chr_@ --pedigree pedigree.txt --out chr_@ --threads 4
# ran OK
#> imputation time: 18.53980040550232

# Family-based GWAS with imputed parental genotypes
gwas.py phenotype.txt --bed chr_@ --imp chr_@ --grm last_gen_rel.seg --out chr_@_imp
# ran OK
#> Time used: 3.55s

gwas.py phenotype.txt --bed chr_@ --imp phased_impute_chr_@ --grm last_gen_rel.seg --out chr_@_phased
# ran OK
#> Time used: 3.64s

# Increasing power for family-GWAS by including singletons
plink --bfile chr_1 --remove <(head -n $(( $(wc -l < chr_1.fam) / 2 )) chr_1.fam | awk 'NR % 2 == 0 {print $1, $2}') --make-bed --out chr_1_singletons
# done

impute.py --ibd chr_@ --bed chr_@_singletons --pedigree pedigree.txt --out chr_@_singletons --threads 4
# ran OK
# imputation time: 17.25623106956482

gwas.py phenotype.txt --bed chr_@_singletons --imp chr_@_singletons --grm last_gen_rel.seg --impute_unrel --out chr_@_unified
# ran OK
#> Time used: 3.27s

# the output did say the following:

#> 3000 individuals with phenotype observations and complete observed/imputed genotype observations.
# 3000 individuals with imputed but no observed parental genotypes.
# 0 individuals with one imputed and one observed parental genotypes.
# 0 individuals with both parents observed.
# 1500 samples without imputed or observed parental genotypes will be included through linear imputation.

gwas.py phenotype.txt --bed chr_@_singletons --imp chr_@_singletons --grm last_gen_rel.seg --out chr_@_no_singletons
# ran OK
#> Time used: 2.34s


# Polygenic score analyses
pgs.py direct --bed chr_@ --imp chr_@ --weights causal_effects.txt --beta_col direct
# ran OK
#> ...Adjuting imputed PGSs for assortative mating
#> Writing PGS to direct.pgs.txt

pgs.py direct --pgs direct.pgs.txt --phenofile phenotype.txt --grm last_gen_rel.seg
# ran OK
#> ...
#>Fitting 2 generation model (proband and observed/imputed parents)
#> Sample size: 6000
#> Optimizing linear mixed model
#> Variance components (after projecting out PGS and covariates):
#> GRM variance component: 0.000
#> Variance explained by GRM: 0.0%
#> Sibling variance component: 0.000
#> Variance explained by sibling component: 0.0%
#> Total variance: 0.508
#> Implied sibling correlation: 0.000
#> Saving effect estimates to direct.2.effects.txt
#> Saving sampling variance-covariance matrix to direct.2.vcov.txt

less -S direct.1.effects.txt
#> intercept       -1.0826458100250524     0.009200146280286132
#> proband 0.9953456128304172      0.010809958586039961

less -S direct.2.effects.txt
#> intercept       -1.0826975288415486     0.00920004660945247
#> proband 1.019069372953269       0.023566229968882395
#> parental        -0.018050892288985508   0.01593340392288689

pgs.py direct_v1 --bed chr_@ --imp chr_@ --weights causal_effects.txt --beta_col direct_v1
#> Estimated correlation between maternal and paternal PGSs: 0.1613 S.E.=0.0209
#> Adjuting imputed PGSs for assortative mating
#> Writing PGS to direct_v1.pgs.txt

pgs.py direct_v1 --pgs direct_v1.pgs.txt --phenofile phenotype.txt --grm last_gen_rel.seg
#> Fitting 2 generation model (proband and observed/imputed parents)
#> Sample size: 6000
#> Optimizing linear mixed model
#> Variance components (after projecting out PGS and covariates):
#> GRM variance component: 0.304
#> Variance explained by GRM: 39.3%
#> Sibling variance component: 0.000
#> Variance explained by sibling component: 0.0%
#> Total variance: 0.774
#> Implied sibling correlation: 0.197
#> Saving effect estimates to direct_v1.2.effects.txt
#> Saving sampling variance-covariance matrix to direct_v1.2.vcov.txt

less -S direct_v1.2.effects.txt
# saw statistically significant average parental NTC (in direct_v1.2.effects.txt)
#> intercept       -1.0828149766786588     0.013404176709888001
#> proband 0.5456069215318381      0.019252535670991184
#> parental        0.06635018198590023     0.015123480430922879

pgs.py direct_v1_obs --bed chr_@_combined --weights causal_effects.txt --beta_col direct_v1 --pedigree pedigree.txt
# ran OK
#> Writing PGS to direct_v1_obs.pgs.txt

pgs.py direct_v1_obs --pgs direct_v1_obs.pgs.txt --phenofile phenotype.txt --h2f 0.42,0
#> rk: 0.1877 (0.0125)
#> k: 0.5116 (0.0318)
#> r: 0.3111 (0.0245)
#> h2_eq: 0.6097 (0.0217)
#> rho: 0.848 (0.0203)
#> alpha_delta: -0.0003 (0.0198)
#> v_eta_delta: -0.0005 (0.0316)


## END