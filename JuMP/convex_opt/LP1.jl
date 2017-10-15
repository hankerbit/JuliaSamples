using JuMP
using Clp

m = Model(solver=ClpSolver())

@variable(m, 0<= x1 <=10)
@variable(m, x2 >=0)
@variable(m, x3 >=0)

@objective(m, Max, x1 + 2*x2 + 5*x3)

@constraint(m, -x1 +  x2 + 3*x3 <= -5)
@constraint(m,  x1 + 3*x2 - 7*x3 <= 10)

print(m)
status = solve(m)

println("Optimal Solutions:")
println("x1 = ", getvalue(x1))
println("x2 = ", getvalue(x2))
println("x3 = ", getvalue(x3))

