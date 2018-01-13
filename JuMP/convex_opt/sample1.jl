using JuMP
# using Mosek
using Gurobi

function main()
    println("JuMP sample1")
    # model = Model(solver=MosekSolver())
    model = Model(solver=GurobiSolver())
    m = 10
    n = 5
    A = rand(m, n)
    b = rand(m, 1)
    println(A)
    println(b)

    @variable(model, 0.0<=x[1:size(A,2)]<=1.0)
    @objective(model, Min, sum((A*x-b).^2))

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("x:",getvalue(x))
end

main()
