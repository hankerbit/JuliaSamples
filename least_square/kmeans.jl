#
# kmeans clustering simulaton
#
# author: Atsushi Sakai
#

using PyPlot

function kmeans(x, k; maxiters = 100, tol = 1e-5)

	N = length(x)
	n = length(x[1])
	distances = zeros(N) # will be used to store the distance of each

	# point to the nearest representative.
	reps = [zeros(n) for j=1:k] # will be used to store representatives.

	# 'assignment' is an array of N integers between 1 and k.
	# The initial assignment is chosen randomly.
	assignment = [ rand(1:k) for i in 1:N ]

	Jprevious = Inf # used in stopping condition
	for iter = 1:maxiters
		# Representative of cluster j is average of points in cluster j.
		for j = 1:k
			group = [i for i=1:N if assignment[i] == j]
			reps[j] = mean(x[group])
		end

		# For each x[i], find distance to the nearest representative
		# and its group index.
		for i = 1:N
			(distances[i], assignment[i]) = findmin([norm(x[i] - reps[j]) for j = 1:k])
		end

		# Compute clustering objective.
		J = norm(distances)^2 / N

		# Show progress and terminate if J stopped decreasing.
		println("Iteration ", iter, ": Jclust = ", J)
		if iter > 1 && abs(J - Jprevious) < tol * J
			return assignment, reps
		end
		Jprevious = J
	end

	println("Does not finish")
end

function main()
    println(PROGRAM_FILE," start!!")

	# generate input data 
	input = vcat( [ 0.3*randn(2) for i = 1:100 ],
				[ [1,1] + 0.3*randn(2) for i = 1:100 ],
				[ [1,-1] + 0.3*randn(2) for i = 1:100 ] )

	# k-means clustering
	ncluster = 3
	assignment, reps = kmeans(input, ncluster)

	# raw data
	plot([i[1] for i in input],[i[2] for i in input],"xk")

	# clustering result
	plot([i[1] for i in input[assignment.==1]],[i[2] for i in input[assignment.==1]],".r")
	plot([i[1] for i in input[assignment.==2]],[i[2] for i in input[assignment.==2]],".g")
	plot([i[1] for i in input[assignment.==3]],[i[2] for i in input[assignment.==3]],".b")

	# center of cluster
	for i in 1:ncluster
		plot(reps[i][1], reps[i][2], "oc")
	end

	axis("equal")
	show()

    println(PROGRAM_FILE," Done!!")

end

main()

