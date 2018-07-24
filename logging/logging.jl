
module logging

macro error(msg)
    return :(println(@sprintf("[Error] %s %s:%d",$msg,@__FILE__,@__LINE__)))
end


end
