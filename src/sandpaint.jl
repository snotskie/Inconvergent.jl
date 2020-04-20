mutable struct Sandpaint{T<:Integer, U<:TransparentColor, V<:Colorant, W<:Real}
    size::T

    # modified: a 2d array of colors instead of a flat array
    vals::Array{U,2}
    fg::V
    bg::V

    # modified: removed indfx
    
    # modified: added quat and quat_inv
    quat::Quaternions.Quaternion{W}
    quat_inv::Quaternions.Quaternion{W}
end

function Sandpaint(size::Integer=1000,
                   fg::Colorant=RGBA(0, 0, 0, 1),
                   bg::Colorant=RGBA(1, 1, 1, 1),
                   quat::Quaternions.Quaternion=Quaternions.Quaternion(1, 0, 0, 0))
    
    # modified: replacing the pigment:with
    if !hasproperty(fg, :alpha)
        fg = RGBA(fg, 1.0)
    end

    if !hasproperty(bg, :alpha)
        bg = RGBA(bg, 1.0)
    end

    # modified: a flat array into a 2d array of colors
    vals = [RGBA(bg) for i in 1:(size^2)]
    vals = reshape(vals, (size, size))

    # modified: added quat
    quat = Quaternions.Quaternion{Float64}(quat)

    return Sandpaint(size, vals, fg, bg, quat, quat^-1)
end

# modified: -inside-floor renamed, params simplified, +1 for julia, calls cb only when not oob
function __with_point_inside_floor(f::Function, pt::Point, sand::Sandpaint)
    x = trunc(Int, pt[1])
    y = trunc(Int, pt[2])
    if 0 <= x < sand.size
        if 0 <= y < sand.size
            return f(x+1, y+1)
        end
    end

    return nothing
end

# modified: -operator-over renamed, simplified parameters, returns the color
function __draw_point_over(sand::Sandpaint, i::Integer, j::Integer)
    weight = sand.fg.alpha
    prev = sand.vals[i, j]
    color = RGBA(weighted_color_mean(weight, sand.fg, prev))
    sand.vals[i, j] = color
    return color
end

function __draw_stroke(sand::Sandpaint, source::Point, dest::Point, grains::Integer)
    # modified: with-on-line macro became sample_points_from_line generator
    for rn in sample_points_from_line(grains, source, dest)

        # modified: do-syntax instead of using a macro
        # modified: projection
        __with_point_inside_floor(__project(sand, rn), sand) do i, j
            __draw_point_over(sand, i, j)
        end
    end
end

__project(sand::Sandpaint, p::Point{2,T}) where {T<:Real} =
    __project(sand, Quaternions.Quaternion(0,
        p[1]-sand.size/2,
        p[2]-sand.size/2,
        0))
__project(sand::Sandpaint, p::Point{3,T}) where {T<:Real} =
    __project(sand, Quaternions.Quaternion(0,
        p[1]-sand.size/2,
        p[2]-sand.size/2,
        p[3]))
__project(sand::Sandpaint, p::Point{4,T}) where {T<:Real} =
    __project(sand, Quaternions.Quaternion(0,
        p[1]-sand.size/2,
        p[2]-sand.size/2,
        p[3]))
function __project(sand::Sandpaint, p::Quaternions.Quaternion)
    t = sand.quat * p * sand.quat_inv
    return Point2f0(t.v1 + sand.size/2, t.v2 + sand.size/2)
end

# modified: replaced line param with two points
function stroke(sand::Sandpaint,
                source::Point,
                dest::Point,
                grains::Integer,
                overlap::Bool=false)

    if overlap
        __draw_stroke_overlap(sand, source, dest, grains) # TODO
    else
        __draw_stroke(sand, source, dest, grains)
    end
end

# modified: renamed from pix
function points(sand::Sandpaint, pts) # pts should be an interable of Point
    for pt::Point in pts
        __with_point_inside_floor(__project(sand, pt), sand) do i, j
            __draw_point_over(sand, i, j)
        end
    end
end

# modified: replacing save with Julia's built-in display
function Base.display(sand::Sandpaint)
    return display(map(RGB, sand.vals))
end