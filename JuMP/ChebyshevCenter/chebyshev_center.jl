#
# Chebyshev center optimization
#
# author: Atsushi Sakai
#
# Ref:
#   http://www.mechatronics3d.com/post/2014-convex-optimization/

using PyPlot
using JuMP
using ECOS
solver = ECOSSolver()

function find_chebyshev_center(a, b)
    model = Model(solver=solver)
    @variable(model, r >= 0.0)
    @variable(model, xc[1:2])
    @objective(model, Min, -r)
    for i in 1:length(a[:,1])
        @constraint(model, a[i,:]'*xc+norm(a[i,:])*r<=b[i])
    end

    status = solve(model)

    fr = getvalue(r)
    # println(fr)

    fx = getvalue(xc)
    # println(fx)

    return fx, fr

end

function main()
    println(PROGRAM_FILE," start!!")

    a = [-1.0 -1.0;
        -0.5 1.0;
       2.0 -1.0]

    b = [1 2 4]

    fx, fr = find_chebyshev_center(a, b)

    xs = [i for i in -3.0:5.0]

    # plot constraints
    for i in 1:length(a[:,1])
        plot(xs, -xs*a[i,1]/a[i,2]+b[i]/a[i,2])
    end

    plot(fx[1], fx[2],"^r")

    cx, cy = Float64[], Float64[] 
    for i in 0:pi/10:pi*2.0
        push!(cx, fx[1]+fr*cos(i))
        push!(cy, fx[2]+fr*sin(i))
    end
    plot(cx, cy,"-r")

    axis("equal")
    # xlim(-3,5)
    # ylim(-3,5)
    grid(true)
    show()

    println(PROGRAM_FILE," Done!!")
end

@time main()

