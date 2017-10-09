module mystuff

using JuMP
using Mosek

function main()
    println("JuMP sample1")
    model = Model(solver=MosekSolver())
    m = 10
    n = 5
    A = [0.832268 0.540747 0.784667 0.355357 0.928707; 0.802036 0.504541 0.430144 0.411091 0.387708; 0.645349 0.0851049 0.71396 0.470207 0.593221; 0.0901346 0.438501 0.871861 0.909309 0.0145537; 0.38814 0.446732 0.0787192 0.411324 0.324244; 0.832039 0.716916 0.345928 0.612039 0.126577; 0.860024 0.302069 0.188148 0.204705 0.9435; 0.426323 0.48622 0.157624 0.737819 0.173054; 0.212276 0.323749 0.50823 0.242557 0.0126005; 0.70361 0.823343 0.116585 0.940804 0.767688]
    b=[0.976362; 0.0278185; 0.16024; 0.250936; 0.730025; 0.414424; 0.468235; 0.272898; 0.253627; 0.824444]
    println(A)
    println(b)

    @variable(model, 0.0<=x[1:size(A,2)]<=1.0)
    @objective(model, Min, sum((A*x-b).^2))

    println("The optimization problem to be solved is:")
    println(model) # Shows the model constructed in a human-readable form

    status = solve(model)
    println("Objective value: ", getobjectivevalue(model)) 
    println("x:",getvalue(x))

end

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    main()
    return 0
end

if contains(@__FILE__, PROGRAM_FILE)
    main()
end

end
