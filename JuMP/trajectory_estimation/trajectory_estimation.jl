#
# 
#
# author: Atsushi Sakai
#

using PyPlot

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

	end

	return h_xTrue, h_x, h_z
end

function main()
    println(PROGRAM_FILE," start!!")

	SIMTIME = 50.0
	DT = 0.1
	ZDT = 4.0
	Q = [0.5,0.1] #input noise
	u = [1.0,0.1]# input v[m/s],omega[rad/s]
	R=[0.1] #observation noise

	h_xTrue, h_x, h_z = simulate(u, SIMTIME, DT, ZDT, Q, R)
	plot(h_xTrue[1,:], h_xTrue[2,:], ".b")
	plot(h_x[1,:], h_x[2,:], ".r")
	plot(h_z[1,:], h_z[2,:], "xg")
	axis("equal")

    println(PROGRAM_FILE," Done!!")
end

@time main()

