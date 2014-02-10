set.seed(76983)
## block 1
rstats <- function(rerror, nobs, stat = mean, nsims = 150000) {
  replicate(nsims, stat(rerror(nobs)))
}
## end

## block 2
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
## end

## not displayed
pdf(file = "asymptotics/bootstrap_fig1.pdf", width=6, height=2.5)
par(mfrow = c(1,3))
nicehist(runif, 2)
nicehist(runif, 5)
nicehist(runif, 50)
dev.off()

pdf(file = "asymptotics/bootstrap_fig2.pdf", width=6, height=2.5)
par(mfrow = c(1,3))
nicehist(rexp, 2)
nicehist(rexp, 15)
nicehist(rexp, 50)
dev.off()

## block 3
Y <- rexp(40)
boots <- rstats(function(n) sample(Y, size = n, replace = TRUE), 40)
trues <- rstats(rexp, 40)
## end

boot2 <-
## block 4
var(replicate(1000, median(sample(Y, replace = TRUE))))
## end

boot3 <-
## block 5
var(replicate(1000, median(sample(Y, replace = TRUE))^(1.2)))
## end

boot4 <-
## block 6
replicate(1000, median(sample(Y - median(Y), replace = TRUE)))
## end

texcommand <- function(macro, tex, fmt = "%s")
  sprintf("\\newcommand{\\%s}{%s}\n", macro, sprintf(fmt, tex))

cat(file = "asymptotics/bootstrap_macros.tex",
    texcommand("bootquantiles",
               paste(sprintf("%.2f", quantile(boots, c(0.05, 0.95))),
                     collapse = " and ")),
    texcommand("bootleft",  mean(trues >= quantile(boots, 0.05)), "%.2f"),
    texcommand("bootright", mean(trues <= quantile(boots, 0.95)), "%.2f"),
    texcommand("medv", boot2, "%.4f"),
    texcommand("powv", boot3, "%.4f"),
    texcommand("ymedian", median(Y), "%.2f"),
    texcommand("bootinference", quantile(abs(boot4), 0.95), "%.2f"))
