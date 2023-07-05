#' Confirmatory factor anaysis (CFA) step for ESEM-with-CFA
#'
#' is a wrapper for lavaan::cfa() function
#'
#' @param model is a character vector with a lavaan syntax for the ESEM model.
#' @param data is a raw data matrix.
#' @param mimic allows to mimic the final output results (i.e. CFA stage) to MPLUS to allow the user to compare the output.
#' @param std.lv is set to TRUE by default to provide standardized latent variables.
#' @param ordered is set to TRUE by default to allow the use of categorical variables.
#'
#' @return An object of class \cite{lavaan::lavaan-class}, for which several methods are available, including a summary method.
#' @export


esem_cfa<-function(model,
         data,
         mimic =c("MPlus"),
         std.lv=TRUE,
         ordered = TRUE){

  esem_cfa_results<-lavaan::cfa(model=model,
                                data=data,
                                mimic=mimic,
                                std.lv=std.lv,
                                estimator = "WLSMV",
                                ordered=ordered)
  esem_cfa_results

}
