#
# Linear quadratic control
#
# author: Atsushi Sakai
#

using PyPlot

"""
   cls_solve(A, b, C, d)

Returns the solution of the constrained least squares problem with coefficient 
matrices `A` and `C`, and right-hand side vectors or matrices `b` and `d`.
"""
function cls_solve(A,b,C,d)
    m, n = size(A)
    p, n = size(C)
    Q, R = qr([A; C])
    Q = Matrix(Q)
    Q1 = Q[1:m,:]
    Q2 = Q[m+1:m+p,:]
    Qtil, Rtil = qr(Q2')
    Qtil = Matrix(Qtil)
    w = Rtil \ (2*Qtil'*Q1'*b - 2*(Rtil'\d))
    return R \ (Q1'*b - Q2'*w/2)
end

function lqc(A, B, C, x_init, x_des, T, rho)
	n = size(A,1)
    m = size(B,2)
    p = size(C,1)
    q = size(x_init,2)
    Atil = [ kron(eye(T), C)  zeros(p*T,m*(T-1)) ;
        zeros(m*(T-1), n*T)  sqrt(rho)*eye(m*(T-1)) ]
    btil = zeros(p*T + m*(T-1), q)
    # We’ll construct Ctilde bit by bit
    Ctil11 = [ kron(eye(T-1), A) zeros(n*(T-1),n) ]  -
        	 [ zeros(n*(T-1), n) eye(n*(T-1)) ]
	Ctil12 = kron(eye(T-1), B)
    Ctil21 = [eye(n) zeros(n,n*(T-1));  zeros(n,n*(T-1)) eye(n)]
    Ctil22 = zeros(2*n,m*(T-1))
    Ctil = [Ctil11 Ctil12; Ctil21 Ctil22]
    dtil = [zeros(n*(T-1), q); x_init; x_des]
    z = cls_solve(Atil,btil,Ctil,dtil)
    x = [z[(i-1)*n+1:i*n,:] for i=1:T]
    u = [z[n*T+(i-1)*m+1 : n*T+i*m, :] for i=1:T-1]
    y = [C*xt for xt in x]

    return x, u, y
end

function main()
    println(PROGRAM_FILE," start!!")
	A = [ 0.855  1.161  0.667;
          0.015  1.073  0.053;
         -0.084  0.059  1.022 ]
	B = [-0.076; -0.139; 0.342 ]
	C = [ 0.218  -3.597  -1.683 ]
	n = 3
   	p = 1
   	m = 1
	x_init = [0.496; -0.745; 1.394]
	x_des = zeros(n,1)

	# open loop control  u = 0
	T = 100
	yol = zeros(T,1)
	Xol = [ x_init  zeros(n, T-1) ]
	for k=1:T-1
    	Xol[:,k+1] = A*Xol[:,k];
    end
	yol = C*Xol

	# linear quadratic control
	rho = 0.2
	x, u, y = lqc(A,B,C,x_init,x_des,T,rho)

	plot(yol', label="Open loop")
	plot(vcat(y...), label="Linear quadratic control")
	legend()
	show()

    println(PROGRAM_FILE," Done!!")
end


@time main()

