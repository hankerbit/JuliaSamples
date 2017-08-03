using JuMP
using Mosek
using CPLEX

function main1()
    println("JuMP mix integer sample1")
    model = Model(solver=MosekSolver())

    @variable(model, z1, Int)
    @variable(model, z2, Int)
    @objective(model, Min, -6*z1-5*z2)
    @constraint(model, z1+4*z2<=16)
    @constraint(model, 6*z1+4*z2<=28)
    @constraint(model, 2*z1-5*z2<=6)
    @constraint(model, 0<=z1<=10)
    @constraint(model, 0<=z2<=10)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("z1:",getvalue(z1))
    println("z2:",getvalue(z2))
end

function main2()
    println("JuMP mix integer sample2")
    model = Model(solver=CplexSolver())

    @variable(model, z1>=0)
    @variable(model, z2>=0)
    @variable(model, z3, Bin)
    @objective(model, Min, -z1-2*z2)
    @constraint(model, 3*z1+4*z2-12<=4*z3)
    @constraint(model, 4*z1+3*z2-12<=4*(1-z3))

    println("The optimization problem to be solved is:")
    println(model)

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("z1:",getvalue(z1))
    println("z2:",getvalue(z2))
    println("z3:",getvalue(z3))
end

main1()
main2()
