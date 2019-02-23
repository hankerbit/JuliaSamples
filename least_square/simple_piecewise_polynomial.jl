using PyPlot
# generate random data
m = 100;
x = -2 .+ 4*rand(m,1);
y = 1 .+ 2*(x.-1) - 3*max.(x.+1,0) + 4*max.(x.-1,0) + 0.3*randn(m,1);

# least squares fitting
theta = [ ones(m) x max.(x.+1,0) max.(x.-1,0) ] \ y;
# plot result
t = [-2.1, -1, 1, 2.1];
yhat = theta[1] .+ theta[2]*t + theta[3]*max.(t.+1,0) + theta[4]*max.(t.-1,0);
plot(x, y, ".b")

plot(t, yhat, "-r")
show()
