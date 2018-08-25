#
# Multi process samples in Julia
#
# Author: Atsushi Sakai
#
# using Distributed

nprocess = 5
addprocs(nprocess)

@everywhere function test(x)
    sleep(1.0)
    return x * 2.0
end


function single_process()
	println("single_process start")
    for i in 1:nworkers()
        test(i)
    end
	println("single_process done")
end

function multi_process()
	println("multi_process start")
	responses = Vector{Any}(nworkers())
	# responses = fill(nothing, nworkers())

    for i in 1:nworkers()
        responses[i] = remotecall(test, i+1, i)
    end

    for res in responses
        wait(res)
    end

	println("multi_process done")
end

@time single_process()
@time multi_process()

println("Done")

