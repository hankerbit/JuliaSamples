
using PyPlot

const __MAIN__ =  length(PROGRAM_FILE)!=0 && occursin(PROGRAM_FILE, @__FILE__)

struct State2D
    x::Float64
    y::Float64
    yaw::Float64
end

function main()
    state = State2D(0.0, 0.0, 0.0)

    x = [state.x]
    y = [state.y]

    push!(x, 10.0)
    push!(y, 0.0)

    plot(x, y)
    axis("equal")
    show()
end


if __MAIN__
    println("Start!!")
    @time main()
    println("Done!!")
end


