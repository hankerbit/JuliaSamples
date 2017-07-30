using JuMP
using Mosek

function main()
    println("JuMP sample2")
    model = Model(solver=MosekSolver())

    @variable(model, 2.5 <= z1 <= 5.0)
    @variable(model, -1.0 <= z2 <= 1.0)
    @NLobjective(model, Min, abs(z1+5.0) + abs(z2-3.0))

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("z1:",getvalue(z1))
    println("z2:",getvalue(z2))
end

main()
