#' Obtain model matrix for a dfrr fit
#'
#' Obtain model matrix for a dfrr fit
#'
#''@return
#' This function returns the model matrix.
#'
#' @inheritParams summary.dfrr
#'
#' @method model.matrix dfrr
#'
#' @export

model.matrix.dfrr<-function(object,...){
  dfrr_fit<-object
    dfrr_fit$modelMatrix
}
