using Gadfly
using Distributions

## block 1
function μh(x)
    xbar = mean(x)
    if abs(xbar) > 1 / length(x)^0.25
        return xbar
    else
        return 0
    end
end
## end

## block 2
function relativevariance(μ, n; nsims = 2000)
    xbar = Array(Real,nsims)
    μhat = Array(Real,nsims)
    for i = 1:nsims
        x = rand(Normal(μ), n)
        xbar[i] = mean(x)
        μhat[i] = μh(x)
    end
    var(μhat) / var(xbar)
end
## end

## block 3
exampleratio = relativevariance(.1, 100)
## end

mcvars =
## block 4
[relativevariance(μ, 100) for μ in -1:0.01:1]
## end

mcvars2 =
## block 5
[relativevariance(μ, 1000) for μ in -1:0.01:1]
## end

function saveplot(id, x, y)
    draw(PDF("analysis/modeling_$id.pdf", 5inch, 3inch),
         plot(x = x, y = y, Geom.line,
              Guide.xlabel("μ"), Guide.ylabel("Relative SD"),
              Theme(default_color = color("black"),
                    panel_fill = color("white"),
                    grid_color = color("white"),
                    minor_label_font = "Bitstream Charter",
                    major_label_font = "Bitstream Charter")))
end

saveplot("fig1", -1:0.01:1, mcvars)
saveplot("fig2", -1:0.01:1, mcvars2)

outfile = open("analysis/modeling_macros.tex", "w")
@printf(outfile, "\\newcommand{\\exampleratio}{%.3f}\n", exampleratio)
close(outfile)
