#
# Gram Schmidt algorithm
#
# author: Atsushi Sakai
#

function gram_schmidt(a; tol = 1e-10)
	q = []
	for i = 1:length(a)
		qtilde = a[i]
		for j = 1:i-1
			qtilde -= (q[j]'*a[i]) * q[j]
		end
		if norm(qtilde) < tol
			println("Vectors are linearly dependent.")
			return q
		end
		push!(q, qtilde/norm(qtilde))
	end

	return q
end


function main()
    println(PROGRAM_FILE," start!!")
	a = [ [-1, 1, -1, 1], [-1, 3, -1, 3], [1, 3, 5, 7] ]
	q = gram_schmidt(a)

	# test orthnormality
	println(norm(q[1]))
	println(q[1]'*q[2])
	println(q[1]'*q[3])

	println(norm(q[2]))
	println(q[2]'*q[3])
	println(norm(q[3]))

    println(PROGRAM_FILE," Done!!")
end


main()

