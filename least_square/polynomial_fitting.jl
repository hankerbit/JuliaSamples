using PyPlot


function get_sin_training()

    x = [i for i in 0:0.5:10]
    y = sin.(x)*3.0 + x

    return x, y
end


function construct_polynomial_matrix(tx, degree)
    nteaching=length(tx)
    A = fill(1.0, (nteaching,1))
    for i in 1:degree
        At = tx.^i
        A = hcat(A, At)
    end

    return A
end


function polynomial_fitting(tx, ty, degree, x)

    A = construct_polynomial_matrix(tx, degree)

    # calc parameter vector
    pv = inv(A'*A)*A'*ty

    Ap = construct_polynomial_matrix(x, degree)

    y = Ap*pv 
    
    return y
end


function main()

    tx, ty = get_sin_training()

    x = [i for i in 0:0.1:10]
    plot(tx, ty, "xb")

    for d in 1:5
        y = polynomial_fitting(tx, ty, d, x)
        plot(x, y, label=string(d))
    end

    axis("equal")
    legend()
    show()

end


main()

