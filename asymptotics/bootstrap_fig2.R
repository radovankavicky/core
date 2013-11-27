set.seed(76983)
source("asymptotics/bootstrap_setup.R")

pdf(file = "asymptotics/bootstrap_fig2.pdf", width=8, height=3)
par(mfrow = c(1,3))

nicehist(rexp, 2)
nicehist(rexp, 15)
nicehist(rexp, 50)
