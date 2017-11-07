#
#
#
# author: Atsushi Sakai
#

using PyCall
using VoronoiCells
using GeometricalPredicates
@pyimport scipy.spatial as ss
@pyimport matplotlib.pyplot as plt

function calc_voronoi_points(x, y)

    pts = [IndexablePoint2D(x[n], y[n], n) for n in 1:length(x)]
    C = voronoicells(pts)
    vx, vy = [], []

    for i in 1:length(x)
        for ii in 1:length(C[i])
            push!(vx, getx(C[i][ii]))
            push!(vy, gety(C[i][ii]))
        end
    end

    return vx, vy

end


function main()
    println(PROGRAM_FILE," start!!")

    x = [1+rand() for n in 1:10]
    y = [1+rand() for n in 1:10]

    plt.plot(x,y, ".r")

    vx, vy = calc_voronoi_points(x,y)
    plt.plot(vx, vy, ".b")

    bxy = hcat(x,y)
    vor = ss.Voronoi(bxy)
    vx = [ix for (ix, iy) in vor["vertices"]]
    vy = [iy for (ix, iy) in vor["vertices"]]
    plt.plot(vx, vy, "xk")

    plt.show()

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end


