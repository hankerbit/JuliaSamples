using JuMP
using Ipopt

m = Model(with_optimizer(Ipopt.Optimizer))

A = [1.0 0.0;
	 0.0 2.0]
q = [3.0,4.0]

@variable(m, x[1:2])

@objective(m, Min, 0.5*x'*A*x+q'*x)

print(m)
optimize!(m)

println("Optimal Solutions:")
println("x = ", value.(x))

