#Make a target matrix to be used for target rotation in the EFA stage of ESEM
#It is a wrapper function around make.keys() function from the psych package

#' Title
#'
#' @param data is a dataset to be used in EFA
#' @param keys is a key matrix with the primary factor items. It can be made with the make.keys() function.
#' The primary factor items in the matrix are  used as referent items.
#' @return a list with target matrix
#' @export
#' @example
#'
#' # loading list from SDQ LSAC
#' main_loadings_list <- list(
#' pp = c("s6_1", "s11_1R", "s14_1R", "s19_1", "s23_1"),
#' cp = c("s5_1", "s7_1R", "s12_1", "s18_1", "s22_1"),
#' es = c("s3_1", "s8_1", "s13_1", "s16_1", "s24_1"),
#' ha = c("s2_1","s10_1","s15_1","s21_1R","s25_1R"),
#' ps = c("s1_1","s4_1","s9_1","s17_1","s20_1")
#' )
#'
#' # make the target matrix to be used in the EFA stage
#' target<-make_target(
#' data=sdq_lsac,
#' keys=main_loadings_list)
#'
#' # conduct EFA
#' esem_efa(
#' data=sdq_lsac,
#' nfactors = 5,
#' rotate="TargetQ",
#' Target= target)
#'
make_target<-function(data, keys){
  if (is.null(data)) {
    rlang::abort("bad argument", message = "Please provide the dataset")
  }
  if (is.null(keys)) {
    rlang::abort("bad argument", message = "Please provide the list of scoring keys")
  }
target <- psych::make.keys(data, keys)
target<-psych::scrub(target, isvalue=1)
target<-list(target)
}


