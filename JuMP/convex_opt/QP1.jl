using JuMP
using Ipopt

m = Model(solver=IpoptSolver())

A = [1 0;
	 0 2]
display(A)
q = [3,4]
println("")
display(q)
println("")

@variable(m, x[1:2])

@objective(m, Min, x'*A*x+q'*x)

print(m)
status = solve(m)

println("Optimal Solutions:")
println("x1 = ", getvalue(x))

