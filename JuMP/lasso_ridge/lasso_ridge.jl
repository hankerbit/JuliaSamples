using JuMP
using Ipopt
using PyCall
solver = IpoptSolver()

@pyimport matplotlib.pyplot as plt


function main1()
    println("JuMP lasso sample1")

    x = [i for i in 0:0.2:5]
    y = sin.(x) + (rand(length(x)) - 0.5) * 1.5
    ty = sin.(x)

    plt.plot(x,ty, "-k", label="True")
    plt.plot(x,y, ".r", label="raw")
    plt.plot(x,normal_least_square(x, y), "-b", label="normal_least_square")
    plt.plot(x,lasso_least_square(x, y), "-g", label="lasso")
    plt.plot(x,ridge_least_square(x, y), "-c", label="ridge")
    plt.legend()
    plt.show()
end

function lasso_least_square(x, y)
    nd = 5
    lamda = 5.0
    model = Model(solver=solver)
    @variable(model, z[i=1:nd])
    @variable(model, ys[i=1:length(x)])
    @NLobjective(model, Min, sum( (ys[i] - y[i])^2 for i = 1:length(x) ) + sum( z[i]^2 * lamda for i = 1:nd ))
    for i = 1:length(x)
        @NLconstraint(model,  ys[i] == z[1] * x[i]^4 + z[2] * x[i]^3 + z[3] * x[i]^2 + z[4]* x[i] + z[5] )
    end
    status = solve(model)
    return getvalue(ys)
end

function ridge_least_square(x, y)
    nd = 5
    lamda = 2.0
    model = Model(solver=solver)
    @variable(model, z[i=1:nd])
    @variable(model, ys[i=1:length(x)])
    @NLobjective(model, Min, sum( (ys[i] - y[i])^2 for i = 1:length(x) ) + sum( abs(z[i])*lamda for i = 1:nd ))
    for i = 1:length(x)
        @NLconstraint(model,  ys[i] == z[1] * x[i]^4 + z[2] * x[i]^3 + z[3] * x[i]^2 + z[4]* x[i] + z[5] )
    end
    status = solve(model)
    return getvalue(ys)
end


function normal_least_square(x, y)
    nd = 5
    model = Model(solver=solver)
    @variable(model, z[i=1:nd])
    @variable(model, ys[i=1:length(x)])
    @NLobjective(model, Min, sum( (ys[i] - y[i])^2 for i = 1:length(x) ))
    for i = 1:length(x)
        @NLconstraint(model,  ys[i] == z[1] * x[i]^4 + z[2] * x[i]^3 + z[3] * x[i]^2 + z[4]* x[i] + z[5] )
    end
    status = solve(model)
    return getvalue(ys)
end

main1()

