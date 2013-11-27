set.seed(58722543)
source("asymptotics/bootstrap_setup.R")

pdf(file = "asymptotics/bootstrap_fig1.pdf", width=8, height=3)
par(mfrow = c(1,3))

nicehist(runif, 2)
nicehist(runif, 5)
nicehist(runif, 50)
dev.off()
