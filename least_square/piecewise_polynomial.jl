#
# Piecewise Polynomial with constrainded least squares problem
#
# author: Atsushi Sakai
#

const __MAIN__ = length(PROGRAM_FILE)!=0 && contains(@__FILE__, PROGRAM_FILE)

using PyPlot

"""
	calc vandermonde matrix for polynomial calculation

	t: elements
	n: degree
"""
function calc_vandermonde_matrix(t,n)
    m = length(t)
    V = zeros(m,n)
	for i = 1:m, j = 1:n
		V[i,j] = t[i]^(j-1)
	end
	return V
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


function main()
    println(PROGRAM_FILE," start!!")

	M = 70 # number of data point of one class
	N = 2*M # total number of data
	n = 4 # polynomial degree 
	Npl = 200 # number of polynomial samples

	xleft = rand(M) .- 1
	xright = rand(M)
	x = [xleft; xright]
	y = x.^3 - x +0.4./(1.+25*x.^2)

	# set up matrix for constrained least square 
	A = [ calc_vandermonde_matrix(xleft,n)  zeros(M,n);
          zeros(M,n) calc_vandermonde_matrix(xright,n)]
	# display(A)
	b = y
	# println(b)

	C = [1  zeros(1,n-1) -1  zeros(1,n-1);
         0  1  zeros(1,n-2)  0 -1  zeros(1,n-2)];
	# println(C)

	d = zeros(2);
	# println(d)

	theta = solve_constrained_least_squares(A,b,C,d)

	xpl_left = linspace(-1, 0, Npl)
	ypl_left = calc_vandermonde_matrix(xpl_left, 4)*theta[1:n]
	xpl_right = linspace(0, 1, Npl)
	ypl_right = calc_vandermonde_matrix(xpl_right, 4)*theta[n+1:end]

	plot(x, y, ".k")
	plot(xpl_left, ypl_left, "-g")
	plot(xpl_right, ypl_right, "-r")
	axis("equal")
	show()

    println(PROGRAM_FILE," Done!!")
end


if __MAIN__
	main()
end

