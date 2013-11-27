source("asymptotics/bootstrap_setup.R"); set.seed(5743)

Y <- rexp(40)
boots <- rstats(function(n) sample(Y, size = n, replace = TRUE), 40)
trues <- rstats(rexp, 40)

texcommand <- function(macro, tex, fmt = "%s")
  sprintf("\\renewcommand{\\%s}{%s}\n", macro, sprintf(fmt, tex))

cat(file = "asymptotics/bootstrap_macros.tex",
    texcommand("bootquantiles",
               paste(sprintf("%.2f", quantile(boots, c(0.05, 0.95))),
                     collapse = " and ")),
    texcommand("bootleft",  mean(trues >= quantile(boots, 0.05)), "%.2f"),
    texcommand("bootright", mean(trues <= quantile(boots, 0.95)), "%.2f"))

boot2 <-
  var(replicate(1000, median(sample(Y, replace = TRUE))))
boot3 <-
  var(replicate(1000, median(sample(Y, replace = TRUE))^(1.2)))
cat(append = TRUE, file = "asymptotics/bootstrap_macros.tex",
    texcommand("medv", boot2, "%.4f"),
    texcommand("powv", boot3, "%.4f"))

boot4 <-
  replicate(1000, median(sample(Y - median(Y), replace = TRUE)))

cat(append = TRUE, file = "asymptotics/bootstrap_macros.tex",
    texcommand("ymedian", median(Y), "%.2f"),
    texcommand("bootinference", quantile(abs(boot4), 0.95), "%.2f"))
