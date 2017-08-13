nprocess = 5
addprocs(nprocess)

@everywhere function test(x)
    sleep(1.0)
    return x * 2.0
end


function single_process()
    for i in 1:nworkers()
        test(i)
    end
end

function multi_process()
    responses = Vector{Any}(nworkers())

    for i in 1:nworkers()
        responses[i] = remotecall(test, i+1, i)
    end

    for res in responses
        wait(res)
    end
end

@time single_process()
@time multi_process()

println("Done")



 

