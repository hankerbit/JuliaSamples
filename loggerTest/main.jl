"
 

 author: Atsushi Sakai
"

include("./moduleA.jl")
include("./moduleB.jl")

const __MAIN__ = length(PROGRAM_FILE)!=0 && occursin(PROGRAM_FILE, @__FILE__)

function main()
    println(PROGRAM_FILE," start!!")

    moduleA.func1()
    moduleB.func2()

    println(PROGRAM_FILE," Done!!")
end

if __MAIN__
    @time main()
end




