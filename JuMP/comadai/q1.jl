#
# commadai q1
#
# author: Atsushi Sakai
#

using JuMP
using CPLEX
solver = CplexSolver(CPX_PARAM_SCRIND=0)

function main()
    println(PROGRAM_FILE," start!!")

    w = [6 5 6 5 6;
         8 7 6 8 7;
         4 5 4 4 5;
         6 7 6 4 7;
         10 8 10 7 10]
    # println(w)

    model = Model(solver=solver)
    @variable(model, x[1:5,1:5], Bin)
    @objective(model, Min, sum(w.*x))

    for i in 1:5
        @constraint(model, sum(x[:,i]) == 1)
        @constraint(model, sum(x[i,:]) == 1)
    end

    status = solve(model)
    range =  [i for i in 1:5]
    mx = getvalue(x)
    name = ["A","B","C","D","E"]
    posi = ["1塁","2塁","3塁","SS","外野"]

    for i in 1:5
        println(name[i], ",", posi[Int(sum(mx[i,:].*range))])
    end

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end

