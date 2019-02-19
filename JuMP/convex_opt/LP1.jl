using JuMP
using Clp

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0<= x1 <=10)
@variable(m, x2 >=0)
@variable(m, x3 >=0)

@objective(m, Max, x1 + 2*x2 + 5*x3)

@constraint(m, -x1 +  x2 + 3*x3 <= -5)
@constraint(m,  x1 + 3*x2 - 7*x3 <= 10)

print(m)
optimize!(m)

println("Optimal Solutions:")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))

