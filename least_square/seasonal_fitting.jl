using PyPlot

function get_sin_training()

    x = [i for i in 0:18]

    y = sin.(x) * 5.0 + x / 5


    return x, y
end



function construct_polynomial_matrix(tx, degree)
    nteaching = length(tx)
    A = fill(1.0, (nteaching, 1))
    for i in 1:degree
        At = tx.^i
        A = hcat(A, At)
    end
    #  display(A)

    return A
end

function plot_arrow(x::Float64, y::Float64,
                    yaw::Float64;
                    length = 5.0, width = 1.0)
    plt.arrow(x, y, length * cos(yaw), length * sin(yaw),
              head_length = width, head_width = width)
end

function seasonal_fitting(tx::Array{Float64},
                          ty::Array{Float64},
                          cycle)

    nteaching = length(tx)

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
    pv = inv(A' * A) * A' * ty

    y = A * pv 
    
    return y
end



function main()
tx, ty = get_sin_training()

    plot(tx, ty, "xb", label = "data")

    cycle = 6
    y = seasonal_fitting(tx, ty, cycle)

    plot(tx, y, "-r", label = "fitting")

    axis("equal")
    legend()

    show()
end


main()

