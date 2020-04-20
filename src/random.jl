sample_points_from_line(n::Integer,
                        source::Point{2,S},
                        dest::Point{2,T}) where {S<:Real,T<:Real} =
    sample_points_from_line(n, Point4f0(source..., 0, 1), Point4f0(dest..., 0, 1))
sample_points_from_line(n::Integer,
                        source::Point{2,S},
                        dest::Point{3,T}) where {S<:Real,T<:Real} =
    sample_points_from_line(n, Point4f0(source..., 0, 1), Point4f0(dest..., 1))
sample_points_from_line(n::Integer,
                        source::Point{3,S},
                        dest::Point{2,T}) where {S<:Real,T<:Real} =
    sample_points_from_line(n, Point4f0(source..., 1), Point4f0(dest..., 0, 1))
sample_points_from_line(n::Integer,
                        source::Point{3,S},
                        dest::Point{3,T}) where {S<:Real,T<:Real} =
    sample_points_from_line(n, Point4f0(source..., 1), Point4f0(dest..., 1))
function sample_points_from_line(n::Integer, source::Point, dest::Point)
    v = dest - source
    return (rand()*v + source for i in 1:n)
end

random_point_in_circle(radius::Real, xy::Point{2,T}) where {T<:Real} =
    random_point_in_circle(radius, Point4f0(xy..., 0, 1))
random_point_in_circle(radius::Real, xy::Point{3,T}) where {T<:Real} =
    random_point_in_circle(radius, Point4f0(xy..., 1))
function random_point_in_circle(radius::Real, xy::Point=Point4f0(0, 0, 0, 1))
    a = rand()
    b = rand()
    if a < b
        a, b = 2pi * a/b, b*radius
    else
        a, b = 2pi * b/a, a*radius
    end

    p = Point4f0(
        cos(a) * b + xy[1],
        sin(a) * b + xy[2],
        xy[3],
        xy[4])

    return p
end

normal_point_in_circle(radius::Real, sd::Real, xy::Point{2,T}) where {T<:Real} =
    normal_point_in_circle(radius, sd, Point4f0(xy..., 0, 1))
normal_point_in_circle(radius::Real, sd::Real, xy::Point{3,T}) where {T<:Real} =
    normal_point_in_circle(radius, sd, Point4f0(xy..., 1))
function normal_point_in_circle(radius::Real, sd::Real, xy::Point=Point4f0(0, 0, 0, 1))
    a = randn()*sd
    b = randn()*sd
    if a < b
        a, b = 2pi * a/b, b*radius
    else
        a, b = 2pi * b/a, a*radius
    end

    p = Point4f0(
        cos(a) * b + xy[1],
        sin(a) * b + xy[2],
        xy[3],
        xy[4])

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