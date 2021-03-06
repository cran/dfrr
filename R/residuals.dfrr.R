#'Obtain residuals for a dfrr model
#'
#'Returns the residuals of a fitted \code{dfrr} model.
#'A \code{dfrr} model is of the form:
#'\deqn{Y_{i}(t)=I(W_{i}(t)>0),}
#'in which   \eqn{I(.)} is the indicator function and \eqn{W_{i}(t)=Z_{i}(t)+\epsilon_{i}(t)\times\sigma^2}, where \eqn{Z_{i}(t)} is the functional part of the model and \eqn{epsilon_{i}(t)\times\sigma^2} is the measurement error.
#' The functional part of the model, consisting a location and a residual function of the form:
#'\deqn{Z_{i}(t)=\sum_{j=1}^{q}\beta_{j}(t)*x_{ji}+\varepsilon_{i}(t),}
#' and \eqn{\epsilon_{i}(t)} are iid standard normal for each \eqn{i} and \eqn{t}.
#' The residuals reported in the output of this functions is the estimation of the
#'  measurement error of the model i.e. \eqn{\epsilon_{i}(t)\times\sigma^2}, which is estimated by:
#'  \deqn{E(W_{i}(t)-Z_{i}(t)\mid Y_{i}(t)).}
#'
#'@return
#'This function returns either a \code{matrix} or  a \code{data.frame}.
#'If the argument ydata is specified, the return value is 'ydata' with
#'a column added, namely 'residual'. Otherwise, the return value
#'is a matrix of residuals of dimension NxM where N is the number of sample curves,
#' and  M is the length of argument 'yind' passed to the function \code{dfrr}.
#'
#'
#'
#'@inheritParams fitted.dfrr
#'@param standardized,unstandardized a \code{boolean} indicating whether stanadrdized/unstandardized residuals are reported.
#'  Defaults to \code{standardized=TRUE}.
#'
#'@seealso \code{\link{plot.residuals.dfrr}}, \code{\link{qq.dfrr}}
#'
#'@examples
#'set.seed(2000)
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
#' resid<-residuals(dfrr_fit)
#'
#'
#' \donttest{plot(resid)}
#' # We can also use the qq function to draw the QQ-plot.
#'
#'@export
#'
#'
residuals.dfrr <-
function(object,standardized=NULL,unstandardized=!standardized,...){
  dfrr_fit<-object
  standardized<-paired.args.check(standardized,
                                  ifelse(missing(unstandardized),NA,unstandardized),
                                  "Please specify 'standardized' or 'unstandardizedd' coefficients must be reported",
                                  TRUE)

  timeT<-sort(unique(unlist(dfrr_fit$data$time)),decreasing = FALSE)
  basis<-basis(dfrr_fit)
  E<-t(fda::eval.basis(timeT,basis))
  ktt<-diag(t(E)%*%dfrr_fit$sigma_theta%*%E)^-0.5

  if(!standardized)
    ktt<-rep(1,length(timeT))


    if("ydata" %in% names(dfrr_fit)){
      ydata<-dfrr_fit$ydata
      ydata$residual<-NA
      for(i in 1:length(dfrr_fit$ids))
      {
        id<-dfrr_fit$ids[i]
        time<-dfrr_fit$data$time[[i]]
        for(j in 1:length(time)){
          t<-time[j]

          kttt<-ktt[which(timeT==t)]
          ydata$residual[ydata$.obs==id & ydata$.index==t]<-dfrr_fit$resids[[i]][j]*kttt
        }
      }
      class(ydata)<-c("residuals.dfrr",class(ydata))
      attr(ydata,"dfrr_fit")<-dfrr_fit
      attr(ydata,"standardized")<-standardized
      return(ydata)
    }

  y_matrix<-dfrr_fit$y_matrix*NA
  yind<-dfrr_fit$yind

  ids_rows<-dfrr_fit$ids_rows

  for(i in 1:length(dfrr_fit$ids))
  {
    id<-dfrr_fit$ids[i]
    row_ind<-which(ids_rows==id)
    time<-dfrr_fit$data$time[[i]]
    for(j in 1:length(time)){
      t<-time[j]
      kttt<-ktt[which(timeT==t)]

      col_ind<-which(yind==t)
      y_matrix[row_ind,col_ind]<-dfrr_fit$resids[[i]][j]*kttt
    }
  }

 class(y_matrix)<-c("residuals.dfrr",class(y_matrix))
 attr(y_matrix,"dfrr_fit")<-dfrr_fit
 attr(y_matrix,"standardized")<-standardized

  return(y_matrix)
}
