# 
# Sparse samples in Julia 
# 
# Author: Atsushi Sakai 
#

# ======Sparse vector======
a = sparsevec([123456, 123457], [1.0, -1.0], 10^6)
println(length(a))
println(nnz(a))

b = randn(10^6)

2*a # for jit complile

@time 2*b
@time 2*a # faster than dense matrix
@time b'*b
@time a'*b # faster than dense matrix


# sparse identity matrix
se = speye(10^6)
println(size(se))
println(nnz(se))

