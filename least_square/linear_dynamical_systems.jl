
using PyPlot

x0 = [1.0, 0.0, -1.0]
n = length(x0)
T = 50

A = [0.97 0.10 -0.05;
	 -0.3 0.99 0.05;
	 0.01 -0.04 0.96]

traj = [x0 zeros(n, T-1)]

for t=1:T-1
	traj[:,t+1] = A*traj[:,t]
end

plot(traj')
show()

