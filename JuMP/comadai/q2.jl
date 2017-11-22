#
# commadai q2
#
# author: Atsushi Sakai
#

using JuMP
using Ipopt
solver=IpoptSolver(print_level=0)

function main()
    println(PROGRAM_FILE," start!!")

    w = [1 2 1;
         3 7 5;
         5 3 2;
         6 5 2;
         7 1 3]# x,y,人数
    println(w)

    model = Model(solver=solver)
    @variable(model, x[1:2])

    obj = []
    for i in 1:5
        push!(obj, ((w[i,1]-x[1])^2+(w[i,2]-x[2])^2)*w[i,3])
    end

    @objective(model, Min, sum(obj))

    status = solve(model)
    println(getvalue(x))

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end

