#
# Struct sample on Julia
#
# author: Atsushi Sakai
#

using PyCall

@pyimport matplotlib.pyplot as plt

# 以前は struct = imutable だった
struct Struct1
    x::Float64
    y::Float64
    yaw::Float64
end

# 以前は mutable struct = type だった
mutable struct Struct2
    x::Float64
    y::Float64
    z::Float64
end


mutable struct Struct3
    x::Float64
    y::Float64
    z::Float64

    Struct3() = new(1.0,1.0,1.0)
    Struct3(x) = new(x,1.0,1.0)
    Struct3(x,z) = new(x,1.0,z)
end

function main()
    println(PROGRAM_FILE," start!!")

    st1 = Struct1(0.0, 0.0, 0.0)
    println(st1)
    st2 = Struct2(0.0, 0.0, 0.0)
    println(st2)

    # st1.x = 1.0 # Error
    println(st1)

    st2.x = 2.0
    println(st2)

    st3 = Struct3()
    println(st3)
    st4 = Struct3(2.0)
    println(st4)
    st5 = Struct3(2.0, 5.0)
    println(st5)

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end


