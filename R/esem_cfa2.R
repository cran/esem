#' Exploratory Structural Equiation Modeling ESEM (ESEM) with geominT rotation
#'
#' @param data is a raw data matrix.
#' @param nfactors is number of factors to extract
#' @param fm is factoring method to be used in factor estimation. The suggested methods are available in  \cite{psych::fa()}
#' @param rotate is the rotation method to be used. The suggested methods are available in  \cite{psych::fa()}
#' @param scores is the factor scores to be used in EFA estimation. The default scores are estimated using regression as set in "regression".
#' @param residuals is set to FALSE by default. In case the residual matrix is required in the output, this parameter should be set to TRUE
#' @param Target is the target rotation matrix to be used. In case no target matrix is provided, EFA proceeds with alternative approach. The list of target rotations are available from \cite{GPArotation}
#' @param missing is used with scores set to TRUE. The default is missing=TRUE which imputes missing values using either the median or the mean.
#' @param mimic allows to mimic the final output results (i.e. CFA stage) to MPLUS to allow the user to compare the output.
#' @param std.lv is set to TRUE by default to provide standardized latent variables.
#' @param ordered is set to TRUE by default to allow the use of categorical variables.
#'
#' @return An object of class \cite{lavaan::lavaan-class}, for which several methods are available, including a summary method.
#' @export
esem_cfa2<-function(
  data, nfactors, fm = 'ML',
  rotate="geominT",
  scores="regression",
  residuals=TRUE,
  Target=NULL,
  missing=TRUE,
  mimic =c("MPlus"),
  std.lv=TRUE,
  ordered = TRUE)

  {
    #EFA stage

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

    #model preparation for CFA

    esem_loadings <- tibble::as_tibble(matrix(round(esem_efa_results$loadings, esem_efa_results$factors),
                                      nrow = length(esem_efa_results$complexity), ncol = esem_efa_results$factors),
                               name_repair="minimal")

    names(esem_loadings) <- paste0("F", as.character(seq(1, esem_efa_results$factors, by=1)))

    esem_loadings$item<-names(esem_efa_results$complexity)

    esem_loadings<-esem_loadings%>%
      tidyr::pivot_longer(!item, names_to="latent", values_to="value")%>%
      dplyr::arrange(by=latent)

    syntax<-esem_loadings%>%
      dplyr::group_by(latent)%>%
      dplyr::mutate(max_per_factor = `item`[value == max(value)],
             is_anchor=dplyr::case_when(
               max_per_factor==item ~ TRUE,
               TRUE ~ FALSE
             )
      )%>%dplyr::ungroup()%>%
      dplyr::group_by(item)%>%
      dplyr::mutate(
        is_anchor_total=sum(is_anchor),
        syntax=dplyr::case_when(
          is_anchor_total!=0 ~ paste0(value,"*", item),
          TRUE ~ paste0("start(",value,")*", item)
        )
      )%>%
      dplyr::select(latent, syntax)

    esem_model<-syntax%>%
      dplyr::group_by(latent)%>%
      dplyr::mutate(syntax=paste0(latent, "=~", paste0(syntax, collapse="+\n")))%>%
      dplyr::distinct(latent, .keep_all = TRUE)%>%
      dplyr::ungroup()%>%
      dplyr::select(-latent)

    esem_model<-paste0(esem_model$syntax, "\n", collapse="\n")

    #CFA stage
  esem_cfa_results<-lavaan::cfa(model=esem_model,
                                data=data,
                                mimic=mimic,
                                std.lv=std.lv,
                                estimator = "WLSMV",
                                ordered=ordered)
  esem_cfa_results
}
