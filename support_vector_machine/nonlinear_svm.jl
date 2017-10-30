#
# Non linear Support Vector Machine with JuMP
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

function kernel(x1, x2)
    y1 = x1^2
    y2 = sqrt(2)*x1*x2
    y3 = x2^2

    return [y1,y2,y3]
end

function fit(x, w, b)
    if (w'*x - b) -1 >= 0
        return true
    else
        return true
    end
end

function nsvm(x, y)

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

    nd = nothing
    for i in 1:length(d[:,1])

        if nd == nothing
            nd = kernel(d[i,1], d[i,2])
        else
            nd = hcat(nd, kernel(d[i,1], d[i,2]))
        end
    end
    nd = nd'
    println(size(d))
    println(size(nd))

    w, b = nsvm(nd, c)

    seqx = [i for i in minimum(d[:,1]):1.0:maximum(d[:,1])]
    seqy = [i for i in minimum(d[:,2]):1.0:maximum(d[:,2])]

    for ix in seqx
        for iy in seqy
            if fit(kernel(ix, iy), w, b)
                plt.plot(ix, iy , "xk")
            else
                println("-")
            end
        end
    end

    # plt.plot(seq, -(w[1] * seq - b)/ w[2] , "-k")
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


