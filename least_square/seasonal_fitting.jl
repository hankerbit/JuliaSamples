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



function seasonal_fitting(tx, ty, cycle)

    nteaching=length(tx)

    A = []

    ind = 1
    while ind <= nteaching
        for j in 1:cycle
            t = fill(0.0, cycle)
            t[j] = 1.0
            Ar = vcat([ind], t)
            ind += 1

            if length(A) == 0
                A = Ar'
            else
                A = vcat(A, Ar')
            end

            if ind >= nteaching
                break
            end
        end
    end

    # calc parameter vector
    pv = inv(A'*A)*A'*ty

    y = A*pv 
    
    return y
end



function main()
    tx, ty = get_sin_training()

    plot(tx, ty, "xb")

    cycle = 6
    y = seasonal_fitting(tx, ty, cycle)

    plot(tx, y, "-r")

    axis("equal")

    show()
end


main()

