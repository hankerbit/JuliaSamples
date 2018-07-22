
using PyPlot

function draw_heatmap(data, minx, maxx, miny, maxy, xyreso)
    u = [i for i in (minx-xyreso/2.0):xyreso:(maxx+xyreso/2.0)-xyreso]
    v = [i for i in (miny-xyreso/2.0):xyreso:(maxy+xyreso/2.0)-xyreso]

    x   = [ u1+xyreso for u1 in u, v1 in v]
    y   = [ v1+xyreso for u1 in u, v1 in v]

    maxvalue = 0.0
    for i in data
        if i == Inf
            continue
        elseif i > maxvalue 
            maxvalue = i
        end
    end
    axis("equal")

    pcolor(x, y, data, vmax=maxvalue)
end

function create_matrix(np, n, lights)
    A = []

    for i in 1:np
        Ai = Float64[]
        for ix in 1:n
            for iy in 1:n
                d = hypot(ix-lights[i,1], iy-lights[i,2]) 
                push!(Ai, d^-1)
            end
        end

        if length(A) == 0
            A = Ai
        else
            A = hcat(A, Ai)
        end
    end

    return A
end


function main()
    nmap = 20 # size of grid map
    nlight = 30 # size of grid map

    lights = rand((nlight,2)).*(nmap-1).+1.0

    A = create_matrix(nlight, nmap, lights)

    # w/o optimization    
    p = fill(0.5, nlight)
    data = A * p
    data = reshape(data, (nmap,nmap))'
    draw_heatmap(data, 0, nmap, 0, nmap, 1.0)
    plot(lights[:,1], lights[:,2], "xr")
    show()

    # w/ optimization    
    l = fill(1.0, nmap*nmap)
    p_hat = inv(A'*A)*(A'*l)
    println(p_hat)
    data = A * p_hat
    data = reshape(data, (nmap,nmap))'
    draw_heatmap(data, 0, nmap, 0, nmap, 1.0)
    plot(lights[:,1], lights[:,2], "xr")
    show()
end



main()


