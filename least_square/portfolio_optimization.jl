using PyPlot

cum_value(r, iv) = iv * cumprod(1 .+ r)
T = 250; # One year's worth of trading days
# Generate random returns sequence with
# 10% annualized return, 5% annualized risk
mu = 0.10/T # 10%の利率は250後に与えられるとする。っ
sigma = 0.05/sqrt(T)
init_value = 1000

r = mu .+ sigma*randn(T);
v = cum_value(r, init_value);
# compare final value (compounded) and average return
println(v[T] , ",", v[1]*(1+sum(r)))
# plot(1:T, v)

function port_opt(R,rho)
	T, n = size(R)
	mu = sum(R, 1)'/T
	println(mu)
	KKT = [ 2*R'*R ones(n) mu; ones(n)' 0 0; mu' 0 0]
	wz1z2 = KKT \ [2*rho*T*mu; 1; rho]
	w = wz1z2[1:n]
	return w
end

avg(x) = sum(x) / length(x)
rms(x) = norm(x) / sqrt(length(x))
stdev(x) = rms(x .- avg(x))

include("./VMLS.jl/src/portfolio_data.jl")
R, RTest = portfolio_data()
T, n = size(R)
println(T,",", n)
rho = 0.10/250 # Ask for 10% annual return
w = port_opt(R,rho)
r = R*w; # Portfolio return time series
plot(1:T, cum_value(r, init_value), label= "10%")

rho = 0.5/250 # Ask for 10% annual return
w = port_opt(R,rho)
r = R*w; # Portfolio return time series
plot(1:T, cum_value(r, init_value), label= "5%")

rho = 0.01/250 # Ask for 10% annual return
w = port_opt(R,rho)
r = R*w; # Portfolio return time series
plot(1:T, cum_value(r, init_value), label= "1%")
legend()

show()
