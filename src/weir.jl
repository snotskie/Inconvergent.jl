# cf MetaGraphs.jl, that might be overkill

mutable struct Weir{T<:Graph} # TODO
    graph::T
    verts::Array{Point4f0}
end

function Weir() # TODO
    graph = Graph()

    # modified: dim removed, just always working in 4d
    verts = Point4f0[]
    return Weir(graph, verts)
end

function edges(w::Weir)
    return LightGraphs.edges(w.graph)
end

function add_edge!(w::Weir, ind1::Integer, ind2::Integer)
    return LightGraphs.add_edge!(w.graph, ind1, ind2)
end

function get_vertex(w::Weir, ind::Integer)
    return w.verts[ind]
end

# modified: returns an (index, point) pair
# modified: combined iter-vert and iter-grp-vert
function get_vertices(w::Weir; on_edge::Bool=false)
    if on_edge
        return ((ind, w.verts[ind]) for ind in 1:nv(w.graph)
                if !isempty(neighbors(w.graph, ind)))
    else
        return ((ind, w.verts[ind]) for ind in 1:nv(w.graph))
    end
end

# modified: returns the vertex graph index, not the vert data
add_vertex!(w::Weir, vert::Point{2,T}) where {T<:Real} =
    add_vertex!(w, Point4f0(vert..., 0, 1))
add_vertex!(w::Weir, vert::Point{3,T}) where {T<:Real} =
    add_vertex!(w, Point4f0(vert..., 1))
function add_vertex!(w::Weir, vert::Point4f0)
    LightGraphs.add_vertex!(w.graph)
    push!(w.verts, vert)
    return nv(w.graph)
end

# modifed: split move-vert! into two versions, made them return
move_vertex_by!(w::Weir, ind::Integer, v::Point{2,T}) where {T<:Real} =
    move_vertex_by!(w, ind, Point4f0(v..., 0, 1))
move_vertex_by!(w::Weir, ind::Integer, v::Point{3,T}) where {T<:Real} =
    move_vertex_by!(w, ind, Point4f0(v..., 1))
function move_vertex_by!(w::Weir, ind::Integer, v::Point)
    w.verts[ind] += v
    return w.verts[ind]
end 

move_vertex_to!(w::Weir, ind::Integer, v::Point{2,T}) where {T<:Real} =
    move_vertex_to!(w, ind, Point4f0(v..., 0, 1))
move_vertex_to!(w::Weir, ind::Integer, v::Point{2,T}) where {T<:Real} =
    move_vertex_to!(w, ind, Point4f0(v..., 1))
function move_vertex_to!(w::Weir, ind::Integer, v::Point)
    w.verts[ind] = v
    return w.verts[ind]
end 