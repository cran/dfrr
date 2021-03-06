% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.dfrr.R
\name{predict.dfrr}
\alias{predict.dfrr}
\title{Prediction for dichotomized function-on-scalar regression}
\usage{
\method{predict}{dfrr}(
  object,
  newdata,
  newydata = NULL,
  standardized = NULL,
  unstandardized = !standardized,
  return.fourier.coefs = NULL,
  return.evaluations = !return.fourier.coefs,
  time_to_evaluate = NULL,
  ...
)
}
\arguments{
\item{object}{a fitted \code{dfrr}-object obtained from invoking the function \code{\link{dfrr}}.}

\item{newdata}{a \code{data.frame} containing the values of all of the
model covariates at which the latent functional response is going  to be
 predicted.}

\item{newydata}{(optional) a \code{ydata}-like \code{data.frame} containing
the values of dichotomized response sparsly observed in the domain of function.}

\item{standardized, unstandardized}{a \code{boolean} indicating whether stanadrdized/unstandardized predictions are reported.
Defaults to \code{standardized=TRUE}.}

\item{return.fourier.coefs, return.evaluations}{a \code{boolean} indicating whether the Fourier coefficients of predictions are returned
(\code{return.fourier.coefs=TRUE}), or evaluations of the predictions (\code{return.evaluations=TRUE}).
Defaults to \code{return.evaluations=TRUE}.}

\item{time_to_evaluate}{a numeric vector indicating the set of time points for evaluating the predictions, for the case of \code{return.evaluations=TRUE}.}

\item{...}{dot argument, just for consistency with the generic function}
}
\value{
This function returns a \code{matrix} of dimension NxM or NxJ, depending
the argument 'return.evaluations'. If \code{return.evaluations=FALSE},
the returned matrix is NxJ, where N denotes the sample size (the number of rows of the argument 'newData'),
and J denotes the number of basis functions. Then, the NxJ matrix is
the fourier coefficients of the predicted curves.
If \code{return.evaluations=TRUE},
the returned matrix is NxM, where M is the length of the argument \code{time_to_evaluate}.
Then, the NxM matrix is the predicted curves
 evaluated at time points given in \code{time_to_evaluate}.
}
\description{
Takes a \code{dfrr}-object created by \code{\link{dfrr}()} and returns predictions
given a new set of values for a model covariates and an optional \code{ydata}-like
\code{data.frame} of observations for the dichotomized response.
}
\details{
This function will return either the Fourier coefficients or the evaluation of
predictions. Fourier coefficients which are reported are
based on the a set of basis which can be determined by \code{\link{basis}(dfrr_fit)}.
Thus the evaluation of predictions on the set of time points specified by vector \code{time},
equals to \code{fitted(dfrr_fit,return.fourier.coefs=T)\%*\%t(\link[fda]{eval.basis}(time,\link{basis}(dfrr_fit)))}.
}
\examples{
set.seed(2000)
\donttest{N<-50;M<-24}
\dontshow{N<-30;M<-12}
X<-rnorm(N,mean=0)
time<-seq(0,1,length.out=M)
Y<-simulate_simple_dfrr(beta0=function(t){cos(pi*t+pi)},
                        beta1=function(t){2*t},
                        X=X,time=time)

#The argument T_E indicates the number of EM algorithm.
#T_E is set to 1 for the demonstration purpose only.
#Remove this argument for the purpose of converging the EM algorithm.
dfrr_fit<-dfrr(Y~X,yind=time,T_E=1)

newdata<-data.frame(X=c(1,0))
  preds<-predict(dfrr_fit,newdata=newdata)
  plot(preds)

newdata<-data.frame(X=c(1,0))
newydata<-data.frame(.obs=rep(1,5),.index=c(0.0,0.1,0.2,0.3,0.7),.value=c(1,1,1,0,0))
preds<-predict(dfrr_fit,newdata=newdata,newydata = newydata)
plot(preds)

}
\seealso{
\code{\link{plot.predict.dfrr}}
}
