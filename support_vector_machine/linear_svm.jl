#
# Linear Support Vector Machine sample with JuMP
#
# author: Atsushi Sakai
#

using PyCall
using Distributions
using JuMP
using CPLEX

solver = CplexSolver(CPX_PARAM_SCRIND=0)
@pyimport matplotlib.pyplot as plt

const λ = 1.0

function lsvm(x, y)

    model = Model(solver=solver)
    @variable(model, w[1:length(x[1,:])])
    @variable(model, b)
    @variable(model, s[1:length(x[:,1])] >= 0.0)

    for i in 1:length(x[:,1])
        @constraint(model, (y[i]*(w'*x[i,:] - b)) -1 >= -s[i])
    end

    obj = w'*w + λ*sum(s)

    @objective(model, Min, obj)

    status = solve(model)
 
    w_vec = getvalue(w)
    b_vec = getvalue(b)

    println("w:",w_vec)
    println("b:",b_vec)

    return w_vec, b_vec
end


function main()
    println(PROGRAM_FILE," start!!")

    d1 = hcat(rand(Normal(-1, 2), 100), rand(Normal(5, 2), 100))
    d2 = hcat(rand(Normal(1, 2), 100), rand(Normal(2, 2), 100))
    d = vcat(d1,d2)
    c = vcat([1 for i in 1:100], [-1 for i in 1:100])

    w, b = lsvm(d, c)

    seq = [i for i in minimum(d[:,1]):0.1:maximum(d[:,1])]
    plt.plot(seq, -(w[1] * seq - b)/ w[2] , "-k")
    plt.plot(d1[:,1],d1[:,2],"or")
    plt.plot(d2[:,1],d2[:,2],"ob")
    plt.axis("equal")
    plt.grid(true)
    plt.show()

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end


