module Inconvergent

using LightGraphs
using GeometryTypes
using Colors
using Images
using Makie

include("./random.jl")
include("./sandpaint.jl")
include("./weir.jl")
include("./examples.jl")

export sample_points_from_line, random_point_in_circle, normal_point_in_circle
export Sandpaint, stroke, points, display
export Weir, edges, add_edge!, get_vertex, get_vertices, add_vertex!, move_vertex_by!, move_vertex_to!
export lines_example

end # module