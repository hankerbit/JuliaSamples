#
# Nonlinear vehicle control 
#
# author: Atsushi Sakai
#
# see: 	Boyd, Stephen, and Lieven Vandenberghe.
# 		Introduction to Applied Linear Algebra: Vectors, Matrices, and Least Squares.
#		Cambridge University Press, 2018. P429
#

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

	initx = zeros(nx, N)
    for k in 1:N-1
		# vehicle model
		@NLconstraint(model,  x[1,k+1] == x[1,k] + dt*u[1,k]*cos(x[3,k]))
        @NLconstraint(model,  x[2,k+1] == x[2,k] + dt*u[1,k]*sin(x[3,k]))
		@NLconstraint(model,  x[3,k+1] == x[3,k] + dt*u[1,k]/L*tan(u[2,k]))

		initx[:,k] = xfinal*k/N
	end
	initx[:,N] = xfinal
	setvalue(x,initx)# warm starting 

	# object function 
	obj = sum(sum(u[:, i].^2 for i=1:N))
	obj += gamma*sum(sum((u[:, i+1]-u[:, i]).^2 for i=1:N-1))

    @objective(model, Min, obj)

    status = solve(model)
	println(status)

	x_opt = getvalue(x)
    u_opt = getvalue(u)

	display(x_opt)
	# display(u_opt)

	return x_opt, u_opt
end


function main()
    println(PROGRAM_FILE," start!!")

	xfinal = [-1.0;1.0;deg2rad(90)]
	N = 50 # control steps
	gamma = 10.0 #weight for diff of input
	L = 0.1 # Wheel base
	dt = 0.1 # time tick

	x, u = solve_nonlinear_vehicle_control(xfinal, N, gamma, L, dt)

	plot(x[1,:], x[2,:], "-r")
	plot(xfinal[1], xfinal[2], "ob")
	axis("equal")
	show()

    println(PROGRAM_FILE," Done!!")
end

# @time main()

