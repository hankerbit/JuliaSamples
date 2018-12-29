using JuMP
using Ipopt

m = Model(solver=IpoptSolver())

A = [1.0 0.0;
	 0.0 2.0]
display(A)
q = [3.0,4.0]
println("")
display(q)
println("")

@variable(m, x[1:2])

@objective(m, Min, 0.5*x'*A*x+q'*x)

print(m)
status = solve(m)

println("Optimal Solutions:")
println("x = ", getvalue(x))

