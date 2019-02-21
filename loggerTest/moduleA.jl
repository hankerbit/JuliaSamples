"
 

 author: Atsushi Sakai
"

module moduleA

using Logging

function func1()
    @debug "this is func1 debug"
    @info "this is func1 info"
    @warn "this is func1 warn"
    @error "this is func1 error"
end

end




