#
# commadai q3
#
# author: Atsushi Sakai
#

using JuMP
using CPLEX
solver = CplexSolver(CPX_PARAM_SCRIND=0)


function main()
    println(PROGRAM_FILE," start!!")

    hint_ind = [[1,2,3,4,5],[4,5,6,7,8],[3,6,7,9,10],[1,2,8,4,10],[1,7,3,9,5]]
    hint_sum = [19,20,35,11,31]

    model = Model(solver=solver)
    @variable(model, x[1:10,1:10], Bin)
    @objective(model, Min, sum(x[1,:]))

    for i in 1:10
        @constraint(model, sum(x[:,i]) == 1)
        @constraint(model, sum(x[i,:]) == 1)
    end
    w = [i for i in 0:9]

    for i in 1:5
        @constraint(model, sum(w.*x[:,hint_ind[i]]) == hint_sum[i])
    end

    status = solve(model)
    mx = getvalue(x)

    println("omote")
    for i in 1:5
        println(sum(w.*mx[:,i]))
    end

    println("ura")
    for i in 6:10
        println(sum(w.*mx[:,i]))
    end

    println()
    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end

