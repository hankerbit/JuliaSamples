using JuMP
using Ipopt

function main_ipopt()
    println("JuMP sample")
    model = Model(with_optimizer(Ipopt.Optimizer))

    @variable(model, z1, start= -0.3)
    @variable(model, z2, start= 0.5)
    @NLobjective(model, Min, 3.0*sin(-2*pi*z1)+2*z1+4+cos(2*pi*z2)+z2)
    @constraint(model, -1<=z1<=1)
    @constraint(model, -1<=z2<=1)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    optimize!(model)
    println("Objective value: ", objective_value(model)) 
    println("z1:",value(z1))
    println("z2:",value(z2))
end

function main_ipopt2()
    println("JuMP sample")
    model = Model(with_optimizer(Ipopt.Optimizer))

    @variable(model, z1)
    @variable(model, z2)
    @NLobjective(model, Min, log(1+z1^2)-z2)
    @NLconstraint(model, -(1+z1^2)^2+z2^2==4)

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    optimize!(model)
    println("Objective value: ", objective_value(model)) 
    println("z1:",value(z1))
    println("z2:",value(z2))
end


main_ipopt()
main_ipopt2()
