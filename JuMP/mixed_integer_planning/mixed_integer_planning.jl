#
#
#
# author: Atsushi Sakai
#

using PyCall
using JuMP
using CPLEX


solver = CplexSolver()

@pyimport matplotlib.pyplot as plt

const A = [1.0 0.0;
        0.0 1.0]
const B = [1.0 0.0;
        0.0 1.0]
const q = [1.0; 1.0]
const r = [1.0; 1.0]

const u_max = 0.1

function control(is, iu)

    T = 100

    model = Model(solver=solver)
    @variable(model, w[1:2,t=1:T])
    @variable(model, v[1:2,t=1:T])
    @variable(model, s[1:2,t=1:T])
    @variable(model, -u_max <= u[1:2,t=1:T] <= u_max)

    @constraint(model, s[:,1] .== is)

    obj = []
    for i in 1:T
        @constraint(model, s[:,i] .<= w[:,i])
        @constraint(model, -s[:,i] .<= w[:,i])
        @constraint(model, u[:,i] .<= v[:,i])
        @constraint(model, -u[:,i] .<= v[:,i])
        push!(obj, q'*w[1:end,i]+r'*v[1:2,i])
    end

    for i in 1:T-1
        @constraint(model, s[:,i+1] .== A*s[:,i]+B*u[:,i])
    end

    @objective(model, Min, sum(obj))

    status = solve(model)

    u_vec = getvalue(u)
    s_vec = getvalue(s)
    # println(u_vec)
    # println(s_vec)

    return s_vec, u_vec
end

function main()
    println(PROGRAM_FILE," start!!")

    s = [10.0, 5.0]
    u = [0.1, 0.2]

    for i=1:100

        s_p, u_p = control(s, u)

        s = A*s+B*u_p[:,1]

        plt.plot(s_p[1,:],s_p[2,:],"-b")
        plt.plot(s[1],s[2],"or")
        plt.axis("equal")
        plt.grid(true)
        plt.pause(0.0001)
    end



    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end

