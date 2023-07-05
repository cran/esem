## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(esem)

## ----eval=FALSE---------------------------------------------------------------
#  install.packages("tidyverse","psych","lavaan","semPlot")
#  remotes::install_github("maria-pro/esem", build_vignettes = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  
#  library(esem)
#  library(tidyverse)
#  library(lavaan)
#  library(semPlot)
#  library(psych)
#  
#  #the package with the dataset to be used
#  remotes::install_github("maria-pro/esem", build_vignettes = FALSE)
#  library(esem)

## ----eval=FALSE---------------------------------------------------------------
#  sdq_lsac<-sdq_lsac

## ----eval=FALSE---------------------------------------------------------------
#  dim(sdq_lsac)

## ----eval=FALSE---------------------------------------------------------------
#  describe(sdq_lsac)

## ----eval=FALSE---------------------------------------------------------------
#  main_loadings_list <- list(
#                            pp = c("s6_1", "s11_1R", "s14_1R", "s19_1", "s23_1"),
#                            cp = c("s5_1", "s7_1R", "s12_1", "s18_1", "s22_1"),
#                            es = c("s3_1", "s8_1", "s13_1", "s16_1", "s24_1"),
#                            ha = c("s2_1","s10_1","s15_1","s21_1R","s25_1R"),
#                            ps = c("s1_1","s4_1","s9_1","s17_1","s20_1")
#                            )

## ----eval=FALSE---------------------------------------------------------------
#  
#  esem_efa_results <- esem_efa(data=sdq_lsac,
#                        nfactors =5,
#                        fm = 'ML',
#                        rotate="geominT",
#                        scores="regression",
#                        residuals=TRUE,
#                        missing=TRUE)
#  

## ----eval=FALSE---------------------------------------------------------------
#  
#  main_loadings_list <- list(
#    pp = c("s6_1", "s11_1R", "s14_1R", "s19_1", "s23_1"),
#    cp = c("s5_1", "s7_1R", "s12_1", "s18_1", "s22_1"),
#    es = c("s3_1", "s8_1", "s13_1", "s16_1", "s24_1"),
#    ha = c("s2_1","s10_1","s15_1","s21_1R","s25_1R"),
#    ps = c("s1_1","s4_1","s9_1","s17_1","s20_1")
#  )
#  
#  target<-make_target(
#             data=sdq_lsac,
#             keys=main_loadings_list)
#  
#  esem_efa(
#       data=sdq_lsac,
#       nfactors = 5,
#       rotate="TargetQ",
#      Target= target)
#  

## ----eval=FALSE---------------------------------------------------------------
#  esem_model <- esem_syntax(esem_efa_results, referent_list)
#  
#  writeLines(esem_model)
#  

## ----eval=FALSE---------------------------------------------------------------
#  esem_fit <- esem_cfa(model=esem_model,
#                  data=sdq_lsac,
#                  std.lv=TRUE,
#                 ordered = TRUE)
#  summary(esem_fit, fit.measures = TRUE, standardized = TRUE, ci = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  semPaths(esem_fit,whatLabels = "std",layout = "tree")

