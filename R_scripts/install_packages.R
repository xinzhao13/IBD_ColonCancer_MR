# R Package Installation Script
# Run this script to install all required packages for the IBD-Colon Cancer MR Analysis

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    install.packages(new_packages, dependencies = TRUE)
  }
}

# Function to install Bioconductor packages if not already installed
install_bioc_if_missing <- function(packages) {
  if (!require("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    BiocManager::install(new_packages, dependencies = TRUE)
  }
}

# CRAN packages
cran_packages <- c(
  "genio",
  "parallel",
  "data.table",
  "dplyr",
  "tictoc",
  "tidyverse",
  "openxlsx",
  "bit64",
  "gtsummary",
  "gt",
  "patchwork",
  "ggplot2",
  "plotROC",
  "rcompanion",
  "imputeMissings",
  "VennDiagram",
  "pheatmap",
  "ROSE",
  "gsubfn",
  "randomForest",
  "gridExtra",
  "regclass",
  "car",
  "oem",
  "matchmaker",
  "MendelianRandomization",
  "Hmisc"
)

# Bioconductor packages
bioc_packages <- c(
  "snpStats",
  "sgPLS"
)

# Install CRAN packages
cat("Installing CRAN packages...\n")
install_if_missing(cran_packages)

# Install Bioconductor packages
cat("Installing Bioconductor packages...\n")
install_bioc_if_missing(bioc_packages)

# Check if ieugwasr needs special installation
if (!require("ieugwasr", quietly = TRUE)) {
  cat("Installing ieugwasr from GitHub...\n")
  if (!require("devtools", quietly = TRUE)) {
    install.packages("devtools")
  }
  devtools::install_github("MRCIEU/ieugwasr")
}

# Verify installations
cat("\nVerifying package installations...\n")
all_packages <- c(cran_packages, bioc_packages, "ieugwasr")
missing_packages <- all_packages[!(all_packages %in% installed.packages()[,"Package"])]

if(length(missing_packages) == 0) {
  cat("✓ All packages successfully installed!\n")
} else {
  cat("✗ The following packages failed to install:\n")
  cat(paste(missing_packages, collapse = ", "), "\n")
}

# Load packages to test
cat("\nTesting package loading...\n")
test_packages <- c("data.table", "dplyr", "ggplot2", "tidyverse")
for(pkg in test_packages) {
  if(require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("✓", pkg, "loaded successfully\n")
  } else {
    cat("✗ Failed to load", pkg, "\n")
  }
}

cat("\nInstallation complete!\n")
cat("You can now run the IBD-Colon Cancer MR analysis scripts.\n")
