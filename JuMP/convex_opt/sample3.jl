using JuMP
using Mosek

function main()
    println("JuMP sample3")
    model = Model(solver=MosekSolver())

    @variable(model, z1>=0.0)
    @variable(model, z2>=0.0)
    @objective(model, Min, 3.0*z1 + 2.0*z2)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("z1:",getvalue(z1))
    println("z2:",getvalue(z2))
end

main()
