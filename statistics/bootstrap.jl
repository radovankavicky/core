using Gadfly
using Distributions

## block 2
function rmeans(dist, nobs; nsims = 5000)
    means = Array(FloatingPoint, nsims)
    for i in 1:nsims
        means[i] = mean(rand(dist, nobs))
    end
    means
end
## end
function savehist(id, simdata)
    draw(PDF("statistics/bootstrap_$id.pdf", 2.5inch, 1.5inch),
         plot(x = simdata, Geom.histogram(bincount = 40),
              Guide.xlabel(""), Guide.ylabel(""),
              Theme(default_color = color("gray"),
                    panel_fill = color("white"),
                    grid_color = color("white"),
                    minor_label_font = "Bitstream Charter",
                    major_label_font = "Bitstream Charter")))
end
                        
savehist("u1", rmeans(Uniform(), 2))
savehist("u2", rmeans(Uniform(), 5))
savehist("u3", rmeans(Uniform(), 50))
savehist("ex1", rmeans(Exponential(), 2))
savehist("ex2", rmeans(Exponential(), 5))
savehist("ex3", rmeans(Exponential(), 50))

## block 1
function rboot(data, statistic; nboot = 799)
    n = length(data)
    bootstats = Array(typeof(statistic(data)), nboot)
    for i in 1:nboot
        bootstats[i] = statistic(data[rand(1:n, n)])
    end
    return bootstats
end
## end

## block 3
Y = rand(Exponential(), 40)
boots = rboot(Y, mean)
## end
## This needs to be calculated differently.
trues = rmeans(Exponential(), 40)

boot2 =
## block 4
var(rboot(Y, median))
## end

boot3 =
## block 5
var(rboot(Y, x->median(x)^(1.2)))
## end

boot4 =
## block 6
rboot(Y - median(Y), median)
## end

outfile = open("statistics/bootstrap_macros.tex", "w")

function texmacro(name, value; fmt = "%s")
    fullfmt = "\\newcommand{\\%s}{$fmt}\n"
    @eval f(file, name, value) = @printf(outfile, $fullfmt, name, value)
    f(outfile, name, value)
end

texmacro("bootquantiles",
         @sprintf("%.2f and %.2f",
                  quantile(boots, 0.05), quantile(boots, 0.95)))
texmacro("bootleft",  mean(trues .>= quantile(boots, 0.05)), fmt = "%.2f")
texmacro("bootright", mean(trues .<= quantile(boots, 0.95)), fmt = "%.2f")
texmacro("medv", boot2, fmt = "%.4f")
texmacro("powv", boot3, fmt = "%.4f")
texmacro("ymedian", median(Y), fmt = "%.2f")
texmacro("bootinference",
         quantile([abs(boot4[i]) for i in 1:length(boot4)], 0.95), fmt = "%.2f")

close(outfile)
