rstats <- function(rerror, nobs, stat = mean, nsims = 150000) {
  replicate(nsims, stat(rerror(nobs)))
}

nicehist <- function(rerror, nobs,...) {
  stats <- rstats(rerror, nobs,...)
  statMean <- mean(stats)
  statSD <- sd(stats)
  
  xlim <- c(min(min(stats), qnorm(0.001, statMean, statSD)),
            max(max(stats), qnorm(0.999, statMean, statSD)))

  hist(stats, 50, col = "alice blue", freq = FALSE, xlab = "",
       main = paste(nobs, "observations"), xlim = xlim)
  curve(dnorm(x, mean = statMean, sd = statSD),
        from = xlim[1], to = xlim[2], lwd = 2, add = TRUE)
}
