#' Get ggplot to visualize output from \code{\link{check_model.fit_model_spatial}}
#'
#' @description
#' \code{plot.check_model_spatial} returns ggplot to visualize outputs from \code{\link{check_model.fit_model_spatial}}
#'
#' @param x Output from \code{\link{check_model.fit_model_spatial}}
#' 
#' @param nb_parameters_per_plot number of parameter per plot to display
#'
#' @param ... further arguments passed to or from other methods
#'
#' @details
#' S3 method.
#' See example in the book: https://priviere.github.io/PPBstats_book/family-1.html#spatial-analysis
#' 
#' @return 
#' \itemize{
#'  \item residuals
#'  \itemize{
#'   \item histogram : histogram with the distribution of the residuals
#'   \item qqplot
#'   }
#'  \item variability_repartition : pie with repartition of SumSq for each factor
#'  }
#' 
#' @author Pierre Riviere
#' 
#' @seealso \code{\link{check_model.fit_model_spatial}}
#' 
#' @export
#' 
#' @import ggplot2
#' 
plot.check_model_spatial <- function(
  x,
  nb_parameters_per_plot = 8, ...
){
  r = y = percentage_Sum_sq = NULL  # to avoid no visible binding for global variable
  
  # Get data ----------
  
  variable = x$spatial$info$variable
  
  data_ggplot = x$data_ggplot
  
  data_ggplot_normality = data_ggplot$data_ggplot_residuals$data_ggplot_normality
  data_ggplot_skewness_test = data_ggplot$data_ggplot_residuals$data_ggplot_skewness_test
  data_ggplot_kurtosis_test = data_ggplot$data_ggplot_residuals$data_ggplot_kurtosis_test
  data_ggplot_qqplot = data_ggplot$data_ggplot_residuals$data_ggplot_qqplot
  data_ggplot_variability_repartition_pie = data_ggplot$data_ggplot_variability_repartition_pie
  data_ggplot_var_intra = data_ggplot$data_ggplot_var_intra
  
  
  # 1. Normality ----------
  # 1.1. Histogram ----------
  p = ggplot(data_ggplot_normality, aes(x = r), binwidth = 2)
  p = p + geom_histogram() + geom_vline(xintercept = 0)
  p = p + ggtitle("Test for normality", paste("Skewness:", signif(data_ggplot_skewness_test, 3), "; Kurtosis:", signif(data_ggplot_kurtosis_test, 3)))
  p1.1 = p + theme(plot.title=element_text(hjust=0.5))
  
  # 1.2. Standardized residuals vs theoretical quantiles ----------
  p = ggplot(data_ggplot_qqplot, aes(x = x, y = y)) + geom_point() + geom_line() 
  p = p + geom_abline(slope = 1, intercept = 0, color = "red")
  p = p + xlab("Theoretical Quantiles") + ylab("Standardized residuals")
  p1.2 = p + ggtitle("QQplot") + theme(plot.title=element_text(hjust=0.5))
  
  # 2. repartition of variability among factors ----------
  p = ggplot(data_ggplot_variability_repartition_pie, aes(x = "", y = percentage_Sum_sq, fill = factor)) 
  p = p + ggtitle(paste("Total variance distribution for", variable))
  p = p + geom_bar(width = 1, stat = "identity") + coord_polar("y", start = 0)
  #pie = pie + geom_text(data=DFtemp, aes(y = value/3 + c(0, cumsum(value)[-length(value)]), label = paste("  ",round(valuep*100), "%")))
  p2 = p + ylab("") + xlab("") + theme(plot.title=element_text(hjust=0.5))
  

  # 3. return results ----------
  out = list(
    "residuals" = list(
      "histogram" = p1.1,
      "qqplot" = p1.2),
    "variability_repartition" = p2
  )
  
  return(out)
}
