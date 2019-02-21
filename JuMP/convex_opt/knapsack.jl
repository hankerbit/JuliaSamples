using JuMP
using CPLEX

println("JuMP knapsack")
model = Model(with_optimizer(CPLEX.Optimizer))

size = [21, 11, 15, 9, 34, 25, 41, 52]
weight = [22, 12, 16, 10, 35, 26, 42, 53]
capacity = 100

@variable(model, x[1:length(size)], Bin)
@objective(model, Max, weight'*x)
@constraint(model, size'*x <= capacity)

println("The optimization problem to be solved is:")
println(model) # Shows the model constructed in a human-readable form

optimize!(model)
println("Objective value: ", getobjectivevalue(model)) 
println("Solution is:")
for i = 1:length(size)
    println("x[$i] = ", value(x[i]))
end
