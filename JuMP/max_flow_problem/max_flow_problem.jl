#
# max flow problem optimization
#
# author: Atsushi Sakai
#

using JuMP
using Clp
solver = ClpSolver()


function main()
    println(PROGRAM_FILE," start!!")

    model = Model(solver=solver)
    @variable(model, 0<=x01<=16)
    @variable(model, 0<=x02<=13)
    @variable(model, 0<=x12<=10)
    @variable(model, 0<=x21<=4)
    @variable(model, 0<=x13<=12)
    @variable(model, 0<=x32<=9)
    @variable(model, 0<=x24<=14)
    @variable(model, 0<=x43<=7)
    @variable(model, 0<=x35<=20)
    @variable(model, 0<=x45<=4)


    @constraint(model, x01 + x21 == x12 + x13 )
    @constraint(model, x02 + x32 + x12 == x21 + x24)
    @constraint(model, x13 + x43 == x32 + x35)
    @constraint(model, x24 == x43 + x45)

    @objective(model, Max, sum(x35+x45))
    status = solve(model)

    println("x01:",getvalue(x01))
    println("x02:",getvalue(x02))
    println("x12:",getvalue(x12))
    println("x21:",getvalue(x21))
    println("x13:",getvalue(x13))
    println("x32:",getvalue(x32))
    println("x24:",getvalue(x24))
    println("x43:",getvalue(x43))
    println("x35:",getvalue(x35))
    println("x45:",getvalue(x45))
    println("final flow:",getvalue(x45)+getvalue(x35))

end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end


