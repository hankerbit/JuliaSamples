using PyPlot

function get_sin_training()

    x = [i for i in 0:20]

	y = sin.(x)*1.0 + x/5

    for i in 1:length(y)
		y[i]+=rand()
    end

    return x, y
end


function auto_regressive_fitting(tx, ty, M)

    N = length(tx)
    A = []
    for i in 1:N-M
		Ad = ty[i:i+M-1]

		if length(A) == 0
			A = Ad'
		else
			A = vcat(A, Ad')
		end
    end
	# display(A)
	# println("")

    # calc parameter vector
	pv = inv(A'*A)*A'*ty[M+1:end]

    y = A*pv 
    
    return y
end


function main()

    tx, ty = get_sin_training()
    plot(tx, ty, "xb")

    M = 4
    y = auto_regressive_fitting(tx, ty, M)

    #  println(length(tx))
    #  println(length(y))

    plot(tx[M+1:end], y, "-r")

    axis("equal")

    show()

end


main()

