#' Exploratory factor analysis (EFA) for ESEM
#is a wrapper function for psych::fa()
#' @param data is a raw data matrix.
#' @param nfactors is number of factors to extract
#' @param rotate is the rotation method to be used. The suggested methods are available in  \cite{psych::fa()}
#' @param scores is the factor scores to be used in EFA estimation. The default scores are estimated using regression as set in "regression".
#' @param Target is the target rotation matrix to be used. In case no target matrix is provided, EFA proceeds with alternative approach. The list of target rotations are available from \cite{GPArotation}
#' @param missing is used with scores set to TRUE. The default is missing=TRUE which imputes missing values using either the median or the mean.
#' @param residuals is set to FALSE by default. In case the residual matrix is required in the output, this parameter should be set to TRUE
#' @param fm is the factoring method.
#' @return Eigen values of the common factor solution and reporting results for EFA stage
#' @export
#' @examples
#' sdq_lsac<-sdq_lsac
#' esem_efa(data=sdq_lsac,
#' nfactors=5,
#' fm = 'ML',
#' rotate="geominT",
#' scores="regression",
#' residuals=TRUE,
#' missing=TRUE)
#' @import GPArotation


esem_efa<-function(data, nfactors, fm = 'ML',
                   rotate="geominT",
                   scores="regression",
                   residuals=TRUE,
                   Target=NULL,
                   missing=TRUE){

  if(is.null(Target)) {esem_efa_results<-psych::fa(data, nfactors =nfactors,
                               fm = fm,
                               rotate=rotate,
                               scores=scores,
                               residuals=residuals,
                               missing=missing)}
  else {esem_efa_results<-psych::fa(data, nfactors =nfactors,
                              fm = fm,
                              rotate=rotate,
                              scores=scores,
                              Target=Target,
                              residuals=residuals,
                              missing=missing)
  }
  esem_efa_results
}
