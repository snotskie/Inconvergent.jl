function sample_points_from_line(n::Integer, source::Point, dest::Point)
    v = dest - source
    return (rand()*v + source for i in 1:n)
end

function random_point_in_circle(radius::Real, xy::Point=Point2f0(0, 0))
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
function normal_point_in_circle(radius::Real, sd::Real, xy::Point=Point2f0(0, 0))
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