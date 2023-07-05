#' Title
#' @param loadings is an output of EFA stage
#' @return A character vector with the syntax of the model tp be used at the CFA stage.
#' @export
#' @import dplyr tidyr
#'
esem_cfa_syntax<-function(loadings){

  esem_loadings <- tibble::as_tibble(matrix(round(loadings$loadings,
                                          loadings$factors),
                                    nrow = length(loadings$complexity), ncol = loadings$factors),
                             name_repair="minimal")

  names(esem_loadings) <- paste0("F", as.character(seq(1, loadings$factors, by=1)))

  esem_loadings$item<-names(loadings$complexity)

  esem_loadings<-esem_loadings|>
    tidyr::pivot_longer(!item, names_to="latent", values_to="value")|>
    dplyr::arrange(by=latent)


  syntax<-esem_loadings|>
    dplyr::group_by(latent)|>
    dplyr::mutate(max_per_factor = `item`[value == max(value)],
           is_anchor=dplyr::case_when(
             max_per_factor==item ~ TRUE,
             TRUE ~ FALSE
           )
    )|> dplyr::ungroup()|>
    dplyr::group_by(item)|>
    dplyr::mutate(
      is_anchor_total=sum(is_anchor),
      syntax=dplyr::case_when(
        is_anchor_total!=0 ~ paste0(value,"*", item),
        TRUE ~ paste0("start(",value,")*", item)
      )
    )|>
    dplyr::select(latent, syntax)

  esem_model<-syntax|>
    dplyr::group_by(latent)|>
    dplyr::mutate(syntax=paste0(latent, "=~", paste0(syntax, collapse="+\n")))|>
    dplyr::distinct(latent, .keep_all = TRUE)|>
    dplyr::ungroup()|>
    dplyr::select(-latent)

  esem_model<-paste0(esem_model$syntax, "\n", collapse="\n")
  return (esem_model)



}
