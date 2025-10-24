# IBD-Colon Cancer Mendelian Randomisation Analysis

## Project Overview

[THIS IS A REPOST OF MY (GROUP) STUDENT PROJECT IN 2021] This project investigates the causal relationship between Inflammatory Bowel Disease (IBD) and colon cancer using Mendelian Randomisation (MR) analysis on UK Biobank data. The analysis uses genetic variants associated with IBD as instrumental variables to assess causal effects on colon cancer risk.

## Project Structure

The project follows a structured workflow with 6 main steps:

| Step | Script | Purpose | Key Functions |
|------|--------|---------|---------------|
| 1 | `1_SNP_List_Creation.R` | Extract and filter IBD-associated SNPs from GWAS summary statistics | • Extract UK Biobank SNPs from .bim files<br>• Filter IBD-significant SNPs (p < 5×10⁻⁸) present in UKB<br>• Perform LD clumping (r² = 0.01)<br>• Remove rare variants (MAF < 0.01)<br>• Create unified SNP list for IBD, CD, and UC |
| 2 | `2_Genetic_Data_Creation.R` | Extract genetic data and calculate Polygenic Risk Scores (PRS) | • Extract selected SNPs from UKB genotype data using PLINK<br>• Convert genotype data to numeric format<br>• Correct allele orientation between IBD GWAS and UKB data<br>• Calculate PRS for IBD, CD, and UC using parallel processing |
| 3 | `3_Outcome_Covariate_Data_Creation.R` | Extract phenotypic data from UK Biobank | • Extract biomarker data (29 biomarkers)<br>• Extract HES covariate data (diabetes, neoplasms, family history)<br>• Extract HES outcome data (depression, anxiety, IBD validation)<br>• Extract cancer outcomes (6 cancer types)<br>• Extract lifestyle covariates and medication data |
| 4 | `4_Final_Data_Creation.R` | Merge all datasets into a single analysis-ready dataset | • Merge UKB and HES data<br>• Handle missing data and variable conflicts<br>• Create final analysis dataset |
| 5 | `5_Analysis_and_Visualisation.R` + `5plus_Analysis_and_Visualisation.R` | Perform statistical analyses and create visualisations | • Create Table 1 (descriptive statistics)<br>• Perform logistic regression analyses<br>• Validate PRS performance (ROC curves, AUC)<br>• Perform variable selection (sPLS-DA, Random Forest, LASSO)<br>• Conduct attenuation analysis |
| 6 | `6.1_Sensitivity_Analysis.R` + `6.2_Sensitivity_Analysis.R` | Validate MR assumptions and perform sensitivity tests | • Prepare data for mini-GWAS<br>• Run phenoscanner analysis<br>• Perform MR sensitivity analyses (IVW, MR-Egger, Weighted Median)<br>• Create forest plots and scatter plots<br>• Test for pleiotropy and heterogeneity |

## Required Data

### UK Biobank Data
- Genotype data: `ukb_imp_chr*.bim`, `ukb_imp_chr*.bed`, `ukb_imp_chr*.fam`
- Phenotypic data: `ukb26390.csv`, `ukb27725.csv`
- HES data: `hesin_diag.txt`
- Participant withdrawal data: `w19266_20200204.csv`

### External Data
- IBD Genetics Consortium GWAS summary statistics:
  - `EUR.IBD.gwas_info03_filtered.assoc`
  - `EUR.CD.gwas_info03_filtered.assoc`
  - `EUR.UC.gwas_info03_filtered.assoc`
- Principal components: `GWAS_PCs.rds`
- Drug list: `ukb_drugs_list.txt`
- Field ID lists: `List_field_ids_to_extract.txt`, `List_field_ids_to_extract_biomarker.txt`


## Project Setup

### Folder Structure
Create the following directory structure:
```
TDS_Project/
├── data/                          # Input data directory
│   ├── ukb_imp_chr*.bim          # UK Biobank genotype files
│   ├── ukb_imp_chr*.bed          # UK Biobank genotype files
│   ├── ukb_imp_chr*.fam          # UK Biobank genotype files
│   ├── ukb26390.csv              # UK Biobank phenotypic data
│   ├── ukb27725.csv              # UK Biobank biomarker data
│   ├── hesin_diag.txt            # Hospital Episode Statistics
│   ├── w19266_20200204.csv       # Participant withdrawal data
│   ├── EUR.IBD.gwas_info03_filtered.assoc
│   ├── EUR.CD.gwas_info03_filtered.assoc
│   ├── EUR.UC.gwas_info03_filtered.assoc
│   ├── GWAS_PCs.rds              # Principal components
│   ├── ukb_drugs_list.txt        # Drug list
│   ├── List_field_ids_to_extract.txt
│   └── List_field_ids_to_extract_biomarker.txt
├── analysis/                      # Output directory (created automatically)
├── R_scripts/                     # R analysis scripts
│   ├── 1_SNP_List_Creation.R
│   ├── 2_Genetic_Data_Creation.R
│   ├── 3_Outcome_Covariate_Data_Creation.R
│   ├── 4_Final_Data_Creation.R
│   ├── 5_Analysis_and_Visualisation.R
│   ├── 5plus_Analysis_and_Visualisation.R
│   ├── 6.1_Sensitivity_Analysis.R
│   └── 6.2_Sensitivity_Analysis.R
├── job_scripts/                   # PBS job submission scripts
│   ├── Job_Submission_DataCreation.sh
│   ├── Job_Submission_Step1Only.sh
│   ├── Job_Submission_Step2Only.sh
│   ├── Job_Submission_Step3Only.sh
│   ├── Job_Submission_Step4Only.sh
│   ├── Job_Submission_Step5Only.sh
│   ├── Job_Submission_Step5plusOnly.sh
│   └── Job_Submission_Step6plusOnly.sh
├── install_packages.R
├── requirements.txt
├── environment.yml
└── README.md
```

### Input File Placement

#### UK Biobank Data
Place the following files in the `data/` directory:
- **Genotype data**: `ukb_imp_chr*.bim`, `ukb_imp_chr*.bed`, `ukb_imp_chr*.fam` (chromosomes 1-22)
- **Phenotypic data**: `ukb26390.csv` (main UK Biobank dataset)
- **Biomarker data**: `ukb27725.csv` (UK Biobank biomarker measurements)
- **HES data**: `hesin_diag.txt` (Hospital Episode Statistics diagnoses)
- **Withdrawal data**: `w19266_20200204.csv` (participants who withdrew consent)

#### External Data
Place the following files in the `data/` directory:
- **GWAS summary statistics**:
  - `EUR.IBD.gwas_info03_filtered.assoc`
  - `EUR.CD.gwas_info03_filtered.assoc`
  - `EUR.UC.gwas_info03_filtered.assoc`
- **Principal components**: `GWAS_PCs.rds`
- **Drug list**: `ukb_drugs_list.txt`
- **Field ID lists**:
  - `List_field_ids_to_extract.txt`
  - `List_field_ids_to_extract_biomarker.txt`

### Directory Setup Commands
```bash
# Create main project directory
mkdir TDS_Project
cd TDS_Project

# Create subdirectories
mkdir data analysis R_scripts job_scripts

# Move R scripts to R_scripts directory
mv *.R R_scripts/

# Move job scripts to job_scripts directory
mv Job_Submission_*.sh job_scripts/

# Set permissions for job scripts
chmod +x job_scripts/*.sh
```

### File Permissions
Ensure all job submission scripts are executable:
```bash
chmod +x job_scripts/*.sh
```

## Installation

### Prerequisites
- UK Biobank data access
- HPC cluster with PBS job scheduler
- R environment with required packages (see `R_scripts/install_packages.R`)
- PLINK software

### Package Installation

#### Option 1: Automated Setup
```bash
Rscript R_scripts/install_packages.R
```
Automatically installs all required R packages.

#### Option 2: R Script Only
```bash
# Create virtual environment
python3 -m venv ibd_mr_env
source ibd_mr_env/bin/activate  

# Install R and packages
Rscript R_scripts/install_packages.R
```

#### Option 3: Conda Environment
```bash
conda env create -f environment.yml
conda activate ibd-colon-cancer-mr
Rscript R_scripts/install_packages.R
```

#### Option 4: Manual Installation 
```bash
# Create virtual environment
python3 -m venv ibd_mr_env
source ibd_mr_env/bin/activate  # On Windows: ibd_mr_env\Scripts\activate

# Install R packages manually
R
```
```r
# Install CRAN packages
install.packages(c("genio", "parallel", "data.table", "dplyr", "tictoc", "tidyverse", "openxlsx", "bit64", "gtsummary", "gt", "patchwork", "ggplot2", "plotROC", "rcompanion", "imputeMissings", "VennDiagram", "pheatmap", "ROSE", "gsubfn", "randomForest", "gridExtra", "regclass", "car", "oem", "matchmaker", "MendelianRandomization", "Hmisc"))

# Install Bioconductor packages
BiocManager::install(c("snpStats", "sgPLS"))

# Install GitHub packages
devtools::install_github("MRCIEU/ieugwasr")
```

## How to Run

### Quick Start
```bash
# Complete pipeline
qsub job_scripts/Job_Submission_DataCreation.sh

# Individual steps
qsub job_scripts/Job_Submission_Step1Only.sh  # SNP List Creation
qsub job_scripts/Job_Submission_Step2Only.sh  # Genetic Data Creation
qsub job_scripts/Job_Submission_Step3Only.sh  # Outcome & Covariate Data
qsub job_scripts/Job_Submission_Step4Only.sh   # Final Data Creation
qsub job_scripts/Job_Submission_Step5Only.sh  # Analysis & Visualisation
qsub job_scripts/Job_Submission_Step5plusOnly.sh  # Extended Analysis
qsub job_scripts/Job_Submission_Step6plusOnly.sh  # Sensitivity Analysis
```

## Output Files

### Data Files
- `snps_imp_list_all.txt`: Unified SNP list
- `PRS_all.rds`: Polygenic risk scores
- `ukb_hes_everything.rds`: Final merged dataset
- `imputed_everything.rds`: Imputed dataset
- `matrixLasso.rds`: Standardized matrix for LASSO

### Analysis Results
- `MR_logistic_regressions_results.txt`: Logistic regression results
- `PRSvalidation_logistic_regressions_results.txt`: PRS validation results
- `Attenuation_logistic_regressions_results.txt`: Attenuation analysis results
- `1-1-mr_all_stats.txt`: MR sensitivity analysis results
- `1-2-phenoscanner_output.csv`: Phenoscanner results
- `0-4-cc_gwas_v4.csv`: Consolidated GWAS results

### Visual Results
- `table1.png`: Descriptive statistics table
- `MR_plot.jpg`: MR scatter and density plots
- `PRS_validation_plot.jpg`: PRS validation plots
- `Vennspls.pdf`: Venn diagram of selected variables
- `results; forest+scatter.jpg`: MR forest and scatter plots
- `appendix; forest.jpg`: Detailed forest plot
- `appendix; scatter.jpg`: Detailed scatter plot

## Key Parameters

### Genetic Analysis
- Significance threshold: p < 5×10⁻⁸
- LD clumping: r² = 0.01
- MAF threshold: 0.01
- PRS calculation: Requires ≥50% SNP coverage

### Statistical Analysis
- Cross-validation folds: 5
- Random Forest trees: 100
- LASSO iterations: 1000
- Downsampling: 7000 (colon cancer), 14000 (IBD)

## Computational Requirements

### Memory Requirements
- Step 1: 30GB
- Step 2: 80GB
- Steps 3-6: 20GB each

### CPU Requirements
- Most steps: 24 cores
- Analysis steps: 1 core

## Troubleshooting

### Common Issues
1. **Memory errors**: Increase memory allocation in PBS scripts
2. **Missing data**: Check file paths and data availability
3. **Package errors**: Ensure all R packages are installed
4. **PLINK errors**: Verify PLINK installation and file permissions

### Data Quality Checks
- Verify SNP overlap between GWAS and UKB
- Check allele orientation consistency
- Validate PRS calculation accuracy
- Monitor missing data patterns

## License

This project is for academic research purposes. Please ensure compliance with UK Biobank data access agreements.
