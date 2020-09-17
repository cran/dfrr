#' Get the basis functions from a dfrr-object
#'
#'Returns the basis functions employed in fitting a dfrr-object.
#'
#'@return
#'a basis object used in fitting the functional parameters.
#'The basis object is the one created by the functions \code{create.*.basis} of
#'the 'fda' package.
#'
#'@inheritParams fitted.dfrr
#'
#'@examples
#' set.seed(2000)
#' \donttest{N<-50;M<-24}
#' \dontshow{N<-30;M<-12}
#' X<-rnorm(N,mean=0)
#' time<-seq(0,1,length.out=M)
#' Y<-simulate_simple_dfrr(beta0=function(t){cos(pi*t+pi)},
#'                         beta1=function(t){2*t},
#'                         X=X,time=time)
#'
#' #The argument T_E indicates the number of EM algorithm.
#' #T_E is set to 1 for the demonstration purpose only.
#' #Remove this argument for the purpose of converging the EM algorithm.
#' dfrr_fit<-dfrr(Y~X,yind=time,T_E=1)
#' coefs<-coef(dfrr_fit,return.fourier.coefs=TRUE)
#'
#' basis<-basis(dfrr_fit)
#' evaluated_coefs<-coefs%*%t(fda::eval.basis(time,basis))
#'
#' #Plotting the regression coefficients
#' oldpar<-par(mfrow=c(1,2))
#'
#' plot(time,evaluated_coefs[1,],'l',main="Intercept")
#' plot(time,evaluated_coefs[2,],'l',main="X")
#'
#' par(oldpar)
#'
#' @export
basis <-
function(object){
  dfrr_fit<-object
  dfrr_fit$basis
}
