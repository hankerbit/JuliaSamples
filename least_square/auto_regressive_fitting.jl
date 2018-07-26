using PyPlot

function get_sin_training()

    x = [i for i in 0:20]

    y = sin.(x)*3.0 + x/5

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


function auto_regressive_fitting(tx, ty, x)

    M = 3

    N = length(tx)
    A = []
    for i in 1:N-M
        Ad = fill(0.0, N)
        for j in 0:M-1
            Ad[i+j] = ty[i+j]
        end

        if length(A) == 0
            A = Ad'
        else
            A = vcat(A, Ad')
        end
    end
    display(A)
    #  println(size(A))
    #  println(length(ty))

    # calc parameter vector
    #  pv = inv(A'*A)*A'*ty
    pv = pinv(A)*ty

    #  Ap = construct_polynomial_matrix(x, degree)

    #  y = Ap*pv 

    y = []
    
    return y
end


function main()

    tx, ty = get_sin_training()

    plot(tx, ty, "xb")

    x = [i for i in 0:0.1:10]
    y = auto_regressive_fitting(tx, ty, x)

    #  plot(x, y, "-r")

    axis("equal")

    show()

end


main()

