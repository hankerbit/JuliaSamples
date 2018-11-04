#
# Trajectory Estimzation with nonlinear optimization
#
# Assume the robot can get dead-reckoning and GPS positioning data.
#
# author: Atsushi Sakai
#

using JuMP
using Ipopt
using PyPlot

function optimize_trajectory(h_x, h_z, h_u, dt, lamda)

	solver=IpoptSolver(print_level=0)
	model = Model(solver=solver)

	N = size(h_x)[2]
	nx = 3
	nu = 2

	@variable(model, x[k=1:nx,t=1:N])
	@variable(model, u[k=1:nu,t=1:N])

	# initial constraint 
	@constraint(model, x[:,1] .== [0.0; 0.0; 0.0])

	for k in 1:N-1
		# vehicle model
		@NLconstraint(model,  x[1,k+1] == x[1,k] + dt*u[1,k]*cos(x[3,k]))
		@NLconstraint(model,  x[2,k+1] == x[2,k] + dt*u[1,k]*sin(x[3,k]))
		@NLconstraint(model,  x[3,k+1] == x[3,k] + dt*u[2,k])
	end
	setvalue(x, h_x)# warm starting 
	setvalue(u, h_u)# warm starting 

	@NLobjective(model, Min, sum(
				   (x[1,k+1] - (x[1,k] + dt*h_u[1,k]*cos(x[3,k])))^2 
				 + (x[2,k+1] - (x[2,k] + dt*h_u[1,k]*sin(x[3,k])))^2 
				 + (x[3,k+1] - (x[3,k] + dt*h_u[2,k]))^2 
				   for k in 1:N-1)
				 +lamda*sum(
				 	(x[1,k] - h_z[1,k])^2 
				 +  (x[2,k] - h_z[2,k])^2 
				 for k in 1:N-1 if h_z[1,k] != 0.0
				 ))
	

	status = solve(model)
	println(status)

	x_opt = getvalue(x)
	u_opt = getvalue(u)

	display(x_opt)

	return x_opt, u_opt
end

function predict_motion(x, u, dt)
	x[1]=x[1]+u[1]*dt*cos(x[3])
    x[2]=x[2]+u[1]*dt*sin(x[3])
    x[3]=x[3]+u[2]*dt
	return x
end

function add_input_noize(u,Q)
    un=u[:]
	un[1]=un[1]+randn()*Q[1]
	un[2]=un[2]+randn()*Q[2]
    return un
end


function gps_observation(xTrue, time, zdt, R)
	z=[0.0, 0.0]

	if abs(time%zdt) > 0.01
		return z
	end

	z[1]=xTrue[1]+randn()*R[1]
    z[2]=xTrue[2]+randn()*R[1]

    return z
end


function simulate(u, SIMTIME, DT, ZDT, Q, R)

	h_xTrue = zeros(3,0)
	h_x = zeros(3,0)
	h_z = zeros(2,0)
	h_u = zeros(2,0)

	xTrue = [0.0, 0.0, 0.0]
	x = [0.0, 0.0, 0.0]
	for time=0.0:DT:SIMTIME
		xTrue = predict_motion(xTrue, u, DT)
		ud = add_input_noize(u, Q)
		x = predict_motion(x, ud, DT)
		z = gps_observation(xTrue, time, ZDT, R)

		# save history
		h_xTrue = hcat(h_xTrue, xTrue)
		h_x = hcat(h_x, x)
		h_z = hcat(h_z, z)
		h_u = hcat(h_u, u)
	end

	return h_xTrue, h_x, h_z, h_u
end

function main()
    println(PROGRAM_FILE," start!!")

	SIMTIME = 50.0
	DT = 0.1 # time tick for control
	ZDT = 4.0 # time tick to get observation
	Q = [0.5,0.1] #input noise
	u = [1.0,0.1]# input v[m/s],omega[rad/s]
	R=[0.1] #observation noise

	h_xTrue, h_x, h_z, h_u = simulate(u, SIMTIME, DT, ZDT, Q, R)

	lamda = 0.1 # weight for observation residual
	x_opt, u_opt = optimize_trajectory(h_x, h_z, h_u, DT, lamda)

	close()
	plot(h_xTrue[1,:], h_xTrue[2,:], ".b", label="Ground Truth")
	plot(h_x[1,:], h_x[2,:], ".g", label="Dead Recknoing")
	plot(h_z[1,:], h_z[2,:], "xg", label="GPS Observation")
	plot(x_opt[1,:], x_opt[2,:], "-r", label="Optimized trajectory")
	legend()
	axis("equal")

    println(PROGRAM_FILE," Done!!")
end

@time main()

