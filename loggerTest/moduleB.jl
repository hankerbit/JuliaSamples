"
 

 author: Atsushi Sakai
"

module moduleB

using Logging

function func2()
    @debug "this is func2 debug"
    @info "this is func2 info"
    @warn "this is func2 warn"
    @error "this is func2 error"
end

end




