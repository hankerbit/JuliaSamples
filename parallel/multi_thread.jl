#
# Multi process samples in Julia
#
# Author: Atsushi Sakai
#

using Base.Threads

function test(x)
    sleep(1.0)
    return x * 2.0
end


function single_thread(nthreads)
	println("single_thread start:",nthreads)
    for i in 1:nthreads
        test(i)
    end
	println("single_thread done")
end

function multi_thread(nthreads)
	println("multi_thread start")
	
    @threads for i in 1:nthreads
		test(i)
		# println(i)
    end

	println("multi_thread done")
end

@time single_thread(nthreads())
@time multi_thread(nthreads())

println("Done")

