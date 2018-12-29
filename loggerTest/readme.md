

julia> ENV["JULIA_WARN"]="moduleA"
"moduleA"

julia> include("main.jl")
WARNING: replacing module moduleA.
WARNING: replacing module moduleB.

julia> main()
 start!!
┌ Debug: this is func1 debug
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:12
[ Info: this is func1 info
┌ Warning: this is func1 warn
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:14
┌ Error: this is func1 error
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:15
[ Info: this is func2 info
┌ Warning: this is func2 warn
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:14
┌ Error: this is func2 error
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:15
 Done!!

julia> ENV["JULIA_DEBUG"]="moduleB"
"moduleB"

julia> main()
 start!!
[ Info: this is func1 info
┌ Warning: this is func1 warn
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:14
┌ Error: this is func1 error
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:15
┌ Debug: this is func2 debug
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:12
[ Info: this is func2 info
┌ Warning: this is func2 warn
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:14
┌ Error: this is func2 error
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:15
 Done!!

julia> ENV["JULIA_DEBUG"]="moduleA,moduleB"
"moduleA,moduleB"

julia> main()
 start!!
┌ Debug: this is func1 debug
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:12
[ Info: this is func1 info
┌ Warning: this is func1 warn
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:14
┌ Error: this is func1 error
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:15
┌ Debug: this is func2 debug
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:12
[ Info: this is func2 info
┌ Warning: this is func2 warn
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:14
┌ Error: this is func2 error
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:15
 Done!!

julia> ENV["JULIA_DEBUG"]=""
""

julia> main()
 start!!
[ Info: this is func1 info
┌ Warning: this is func1 warn
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:14
┌ Error: this is func1 error
└ @ Main.moduleA ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleA.jl:15
[ Info: this is func2 info
┌ Warning: this is func2 warn
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:14
┌ Error: this is func2 error
└ @ Main.moduleB ~/Dropbox/Program/julia/JuliaSamples/loggerT
est/moduleB.jl:15
 Done!!

julia> ENV["JULIA_DEBUG"]=""
