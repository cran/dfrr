% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.residuals.dfrr.R
\name{plot.residuals.dfrr}
\alias{plot.residuals.dfrr}
\alias{qq.dfrr}
\title{QQ-plot for dfrr residuals}
\usage{
\method{plot}{residuals.dfrr}(x, ...)

\method{qq}{dfrr}(x, ...)
}
\arguments{
\item{x}{a \code{residuals.dfrr}-object.}

\item{...}{graphical parameters passed to \code{car::\link[car]{qqPlot}}}
}
\value{
This function generates the QQ-plot of residuals.
}
\description{
The output gives the qq-plot of estimated measurment error.
}
\examples{
\donttest{
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
resid<-residuals(dfrr_fit)
\donttest{plot(resid)}
# We can also use the qq function to draw the QQ-plot.
}
}
