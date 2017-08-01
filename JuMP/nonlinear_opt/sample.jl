using JuMP
using Ipopt
using NLopt

function main_ipopt()
    println("JuMP sample")
    model = Model(solver=IpoptSolver())

    @variable(model, z1, start= -0.3)
    @variable(model, z2, start= 0.5)
    @NLobjective(model, Min, 3.0*sin(-2*pi*z1)+2*z1+4+cos(2*pi*z2)+z2)
    @constraint(model, -1<=z1<=1)
    @constraint(model, -1<=z2<=1)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("z1:",getvalue(z1))
    println("z2:",getvalue(z2))
end

function main_nlopt()
    println("JuMP and NL opt sample")
    model = Model(solver=NLoptSolver(algorithm=:LD_MMA))

    @variable(model, z1, start= -0.3)
    @variable(model, z2, start= 0.0)
    @NLobjective(model, Min, 3.0*sin(-2*pi*z1)+2*z1+4+cos(2*pi*z2)+z2)
    @constraint(model, -1<=z1<=1)
    @constraint(model, -1<=z2<=1)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("z1:",getvalue(z1))
    println("z2:",getvalue(z2))
end

main_ipopt()
main_nlopt()
