#
# Nonlinear vehicle control 
#
# author: Atsushi Sakai
#
# see: 	Boyd, Stephen, and Lieven Vandenberghe.
# 		Introduction to Applied Linear Algebra: Vectors, Matrices, and Least Squares.
#		Cambridge University Press, 2018. P429
#

# using Test
using JuMP
using Ipopt
using PyPlot

function solve_nonlinear_vehicle_control(xfinal, N, gamma, L, dt)

	solver=IpoptSolver(print_level=0)
    model = Model(solver=solver)

	nx = 3
	nu = 2

    @variable(model, x[k=1:nx,t=1:N])
    @variable(model, u[k=1:nu,t=1:N])

	# initial and terminal constraint 
	@constraint(model, x[:,1] .== [0.0; 0.0; 0.0])
	@constraint(model, x[:,N] .== xfinal)

    for k in 1:N-1
		@NLconstraint(model,  x[1,k+1] == x[1,k] + dt*u[1,k]*cos(x[3,k]))
        @NLconstraint(model,  x[2,k+1] == x[2,k] + dt*u[1,k]*sin(x[3,k]))
		@NLconstraint(model,  x[3,k+1] == x[3,k] + dt*u[1,k]/L*tan(u[2,k]))
	end

	# object function 
	# obj = sum(u[1, i]^2 for i=1:N)
	obj = sum(sum(u[:, i].^2 for i=1:N))
	obj += gamma*sum(sum((u[:, i+1]-u[:, i]).^2 for i=1:N-1))

    @objective(model, Min, obj)

    status = solve(model)
	println(status)

	xopt = getvalue(x)
    uopt = getvalue(u)

	display(xopt)
	display(uopt)
	
end

function main()
    println(PROGRAM_FILE," start!!")

	xfinal = [0.0;1.0;0.0]
	N = 50
	gamma = 10.0 
	L = 0.1
	dt = 0.1

	solve_nonlinear_vehicle_control(xfinal, N, gamma, L, dt)

    println(PROGRAM_FILE," Done!!")
end

@time main()

