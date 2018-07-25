using PyPlot

function get_sin_training()

    x = [i for i in 0:20]

    y = sin.(x) + x/5


    return x, y
end

function construct_polynomial_matrix(tx, degree)
    nteaching=length(tx)
    A = fill(1.0, (nteaching,1))
    for i in 1:degree
        At = tx.^i
        A = hcat(A, At)
    end
    #  display(A)

    return A
end



function seasonal_fitting(tx, ty, x)

    degree = 1

    nteaching=length(tx)
    A = fill(1.0, (nteaching,1))
    for i in 1:degree
        At = tx.^i
        A = hcat(A, At)
    end

    # calc parameter vector
    pv = inv(A'*A)*A'*ty

    Ap = construct_polynomial_matrix(x, degree)

    y = Ap*pv 
    
    return y
end




function main()

    tx, ty = get_sin_training()

    plot(tx, ty, "xb")

    x = [i for i in 0:0.1:10]
    y = seasonal_fitting(tx, ty, x)

    plot(x, y, "-r")

    axis("equal")

    show()

end


main()

