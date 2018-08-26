#
# Linear quadratic state estimation
#
# author: Atsushi Sakai
#

using PyPlot

"""
	Get measurement
"""
function get_measurements(T)
	x = linspace(0,5,T)
	y = sin.(x).+rand(length(x))*0.5
	m = [x y]'
	return m
end

"""
	solve constraint least squares

	min ||Ax - b||^2
	s.t Cx = d

"""
function solve_constrained_least_squares(A,b,C,d)
	m, n = size(A)
    p, n = size(C)
    G = A'*A  # Gram matrix
    KKT = [	2*G 	C'; 
			C 	zeros(p,p)]  # KKT matrix
    xzhat = KKT \ [2*A'*b; d]
    return xzhat[1:n,:]
end


"""
	least square state estimation
"""
function least_square_state_estimation(A,B,C,y,T,lambda)
    n = size(A,1)
    m = size(B,2)
    p = size(C,1)
    Atil = [ kron(eye(T), C)  zeros(T*p, m*(T-1));
        zeros(m*(T-1), n*T)  sqrt(lambda)*eye(m*(T-1)) ]
    btil = [ vcat(y...) ; zeros((T-1)*m) ]
    Ctil = [ ([ kron(eye(T-1), A) zeros(n*(T-1), n) ] +
        [ zeros(n*(T-1), n) -eye(n*(T-1)) ])  kron(eye(T-1), B) ]
    dtil = zeros(n*(T-1))

    z = solve_constrained_least_squares(Atil, btil, Ctil, dtil)

    x = [ z[(i-1)*n+1:i*n] for i=1:T ]
    u = [ z[n*T+(i-1)*m+1 : n*T+i*m] for i=1:T-1 ]
    y = [ C*xt for xt in x ]

	# convert list to array
	x = hcat(x...)
	u = hcat(u...)
	y = hcat(y...)

    return x, u, y
end


function main()
    println(PROGRAM_FILE," start!!")

	T = 100
	lambda = 10^3
	A = [ eye(2)  eye(2);
   		zeros(2,2)  eye(2) ]
	B = [ zeros(2,2);
   	 	eye(2) ]
	C = [ eye(2) zeros(2,2) ]

	y = get_measurements(T)

	xest, uest, yest = least_square_state_estimation(A, B, C, y, T, lambda)

	plot(y[1,:],y[2,:],".k")
	plot(yest[1,:],yest[2,:],".-r")
	axis("equal")
	show()

    println(PROGRAM_FILE," Done!!")
end


main()

