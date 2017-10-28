#
# Linear Support Vector Machine sample with JuMP
#
# author: Atsushi Sakai
#

using PyCall
using Distributions

@pyimport matplotlib.pyplot as plt


function main()
    println(PROGRAM_FILE," start!!")

    d1 = rand(Normal(1, 2), 100, 2)
    d2 = rand(Normal(-2, 1), 100, 2)

    d = vcat(d1,d2)
    # println(size(d))

    lsvm(d)

    plt.plot(d1[:,1],d1[:,2],"or")
    plt.plot(d2[:,1],d2[:,2],"ob")
    plt.axis("equal")
    plt.grid(true)
    plt.show()

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end


