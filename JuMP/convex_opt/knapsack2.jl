using JuMP
using CPLEX

function main()
    println("JuMP knapsack")
    model = Model(solver=CplexSolver())

    size = [21, 11, 15, 9, 34, 25, 41, 52]
    weight = [22, 12, 16, 10, 35, 26, 42, 53]
    capacity = 100

    @variable(model, x[1:length(size)], Int)
    @constraint(model, x .>= 0)
    @objective(model, Max, dot(weight,x))
    @constraint(model, dot(size, x) <= capacity)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("Solution is:")
    for i = 1:length(size)
        println("x[$i] = ", getvalue(x[i]))
    end
end

main()
