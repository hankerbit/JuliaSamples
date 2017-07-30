using JuMP
using CPLEX

function main()
    println("JuMP knapsack")
    model = Model(solver=ECOSSolver())

    nitem = 30000
    capacity = 1000

    size = rand(1:50, nitem)
    weight = rand(1:50, nitem)

    @variable(model, x[1:length(size)], Bin)
    @objective(model, Max, dot(weight,x))
    @constraint(model, dot(size, x) <= capacity)

    @time status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
end

main()
