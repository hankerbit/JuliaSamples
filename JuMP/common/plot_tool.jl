#
# Plot tool in Julia
#
# author: Atsushi Sakai
#


module plot_tool

using PyCall

@pyimport matplotlib.pyplot as plt
@pyimport subprocess as subp

iframe = 0
frecord = false

const LENGTH = 12.6

function record_movie(flag)
    global frecord
    frecord = flag
end

function save_frame()
    #Save a frame for movie
    global iframe

    if frecord
        global frecord
        fname = string("recoder",@sprintf("%04d", iframe),".png")
        plt.savefig(fname)
        iframe += 1
    end
end


function save_movie(fname, d_pause)
    global frecord

    if frecord
        cmd = string("convert -monitor -delay " , Int(d_pause * 100) , " recoder*.png " , fname)
        subp.call(cmd, shell=true)
        cmd = "rm -f recoder*.png"
        subp.call(cmd, shell=true)
    end
end


function plot_arrow(x::Float64, y::Float64, yaw::Float64; length=5.0, width=1.0)
    plt.arrow(x, y, length * cos(yaw), length * sin(yaw),
              head_length=width, head_width=width)
end

function plot_circle(x, y, r)

    xl = []
    yl = []
    ndiv = 20
    for i = 0:ndiv
        push!(xl, x + r * cos(i * 2*pi/ ndiv) )
        push!(yl, y + r * sin(i * 2*pi/ ndiv) )
    end
    plt.plot(xl, yl, "-b")
end


function main()
    println(PROGRAM_FILE," start!!")

    println(PROGRAM_FILE," Done!!")
end

end #module

