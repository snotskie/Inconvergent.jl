module Inconvergent

# porting https://github.com/inconvergent/weir/tree/master/src
# cf https://docs.julialang.org/en/v1/manual/performance-tips/

using LightGraphs
using GeometryTypes
using Colors
using Images
using Makie

include("./random.jl")
include("./sandpaint.jl")
include("./weir.jl")
include("./examples.jl") # HERE

print(@timed lines_example())

end # module