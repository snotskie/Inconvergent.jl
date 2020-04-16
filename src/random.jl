# TODO 4d
function sample_points_from_line(n::Integer, source::Point, dest::Point)
    v = dest - source
    return (rand()*v + source for i in 1:n)
end

# TODO 4d
function random_point_in_circle(radius::Real, xy::Point=Point2f0(0))
    a = rand()
    b = rand()
    if a < b
        a, b = 2pi * a/b, b*radius
    else
        a, b = 2pi * b/a, a*radius
    end

    if length(xy) > 2
        xy = Point2f0(xy)
    end

    p = Point2f0(cos(a) * b + xy[1], sin(a) * b + xy[2])
    return p
end

# new: a normal distribution version
# TODO 4d
function normal_point_in_circle(radius::Real, sd::Real, xy::Point=Point2f0(0))
    a = randn()*sd
    b = randn()*sd
    if a < b
        a, b = 2pi * a/b, b*radius
    else
        a, b = 2pi * b/a, a*radius
    end

    if length(xy) > 2
        xy = Point2f0(xy)
    end

    p = Point2f0(cos(a) * b + xy[1], sin(a) * b + xy[2])
    return p
end

random_point_on_sphere(rad::Real, xy::Point{2,T}) where {T<:Real} =
    random_point_on_sphere(rad, Point4f0(xy..., 0, 1))
random_point_on_sphere(rad::Real, xy::Point{3,T}) where {T<:Real} = 
    random_point_on_sphere(rad, Point4f0(xy..., 1))
function random_point_on_sphere(rad::Real=1, xy::Point=Point4f0(0, 0, 0, 1))
    a = randn()
    b = randn()
    c = randn()
    d = rad / sqrt(a^2 + b^2 + c^2)
    p = xy + Point4f0(a*d, b*d, c*d, 0)
    return p
end

random_point_in_cube(size::Real, xy::Point{2,T}) where {T<:Real} =
    random_point_in_cube(size, Point4f0(xy..., 0, 1))
random_point_in_cube(size::Real, xy::Point{3,T}) where {T<:Real} = 
    random_point_in_cube(size, Point4f0(xy..., 1))
function random_point_in_cube(size::Real, xy::Point=Point4f0(0, 0, 0, 1))
    a = rand()
    b = rand()
    c = rand()
    d = size
    p = xy + Point4f0(a*d, b*d, c*d, 0)
    return p
end