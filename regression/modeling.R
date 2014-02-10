## block 1
mh <- function(x) {
  xbar <- mean(x)
  crit <- 1 / length(x)^0.25
  if (abs(xbar) > crit) {
    return(xbar)
  } else {
    return(0)
  }
}
## end

## block 2
relvariance <- function(mu, n, nsims = 2000) {
  variances <- apply(replicate(nsims, {
    x <- rnorm(n, mu)
    c(xbar = mean(x), mhat = mh(x))
  }), 1, var)
  return(variances[2] / variances[1])
}
## end

set.seed(647893)
exvar <-
## block 3
relvariance(1, 100)
## end

mcvars <-
## block 4
sapply(seq(-1, 1, 0.01), function(m) relvariance(m, 100))
## end
pdf(file = "regression/modeling_fig1.pdf", width=5, height=5)
plot(mcvars ~ seq(-1, 1, 0.01), type = "l")
lines(c(1,1) ~ c(-1,1), col = "light gray")
dev.off()

mcvars2 <-
## block 5
sapply(seq(-1, 1, 0.01), function(m) relvariance(m, 1000))
## end
pdf(file = "regression/modeling_fig2.pdf", width=5, height=5)
plot(mcvars2 ~ seq(-1, 1, 0.01), type = "l")
lines(c(1,1) ~ c(-1,1), col = "light gray")
dev.off()


texcommand <- function(macro, tex, fmt = "%s")
  sprintf("\\newcommand{\\%s}{%s}\n", macro, sprintf(fmt, tex))

cat(file = "regression/modeling_macros.tex",
    texcommand("exvar", exvar, "%.2f"))
