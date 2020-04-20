function lines_example()
    size = 1000
    repeat = 15
    grains = 3
    itt = 1000
    itt2 = 100 # modified: split from itt, set smaller
    sand = Sandpaint(size,
                     RGBA(colorant"black", 0.01),
                     colorant"white",
                     Quaternions.Quaternion(cos(pi/6), 0, sin(pi/6), sin(pi/6))) # modified: added quat
    
    # modified: removed the outermost loop
    p1 = Point4f0(100, 500, 0, 1)
    p2 = Point4f0(900, 500, 0, 1)
    for j in LinRange(0, 15, repeat+1)
        wer = Weir()

        pa = Point4f0(0, 0, 0, 1)
        for s in LinRange(0, 1, itt)
            p3 = s*(p2 - p1) + p1
            p4 = p3 + pa
            pa = random_point_in_circle(0.7 * j, pa)

            # modified: grabbing the ind values
            ind1 = add_vertex!(wer, p3)
            ind2 = add_vertex!(wer, p4)
            add_edge!(wer, ind1, ind2)
        end

        # modified: restructured, pulled this out a nest,
        # so that above we create the edges, and below we
        # draw the sand strokes.
        pb = Point4f0(0, 0, 0, 1)
        for k in 1:itt2
            pb = random_point_in_circle(0.001 * j, pb)
            for e in edges(wer)
                source = get_vertex(wer, e.src)
                dest = get_vertex(wer, e.dst)
                move_vertex_by!(wer, e.src, random_point_in_circle(0.1, pb))
                move_vertex_by!(wer, e.dst, random_point_in_circle(0.1, pb))
                stroke(sand, source, dest, grains)
            end

            # modified: skip edge check, since I know they all are
            points(sand, pt for (ind, pt) in get_vertices(wer)) 
        end
    end

    display(sand)
end

function rel_neigh_example() # IN PROGRESS
    scene = Scene()
    wer = Weir()

    # modified: not using a kdtree to optimize the if statement
    function __init_cube(n, m, size)
        dots = (random_point_in_cube(size) for i in 1:m)
        Z = Point4f0[]
        for rad in (rand()*500 for i in 1:3)
            for mid in (random_point_on_sphere(300) for j in 1:3)
                for p in (random_point_on_sphere(rad, mid) for k in 1:n)
                    if 90 < minimum(sqrt(sum((p .- q) .^ 2)) for q in dots)
                        push!(Z, p)
                    end
                end
            end
        end

        return Z
    end

    for pt in __init_cube(100, 800, 500) # TEMP 10 was 7000
        add_vertex!(wer, pt)
    end

    add_relative_neighboorhood_edges!(wer, 500)

    vs = [v for (ind, v) in get_vertices(wer)]
    xs = [v[1] for v in vs]
    ys = [v[2] for v in vs]
    zs = [v[3] for v in vs]
    scatter!(scene, xs, ys, zs, markersize=10)

    println(length(edges(wer))) # TEMP
    cutoff = 1000 # TEMP
    for e in edges(wer)
        a = get_vertex(wer, e.src)
        b = get_vertex(wer, e.dst)
        xs = [a[1], b[1]]
        ys = [a[2], b[2]]
        zs = [a[3], b[3]]
        lines!(scene, xs, ys, zs)
        cutoff -= 1 # TEMP
        if cutoff == 0 # TEMP
            break
        end
    end

    # TODO finish this and do something better with the scene

    # function __dot_split(e, xp, planept, planevec, g)
    #     a = e.src
    #     b = e.dst
    #     if rem_edge!(wer, a, b)
    #         ind = add_vertex!(wer, xp)
    #         add_edge!(wer, ind, b)
    #         add_edge!(wer, ind, a)
    #     end
    #     # graphpt = get_vertex(wer, a)
    #     # if 0 < sum(planevec .* (graphpt - planept))
    #     # else
    #     # end
    # end

    # function __plane_intersect(planept, planevec)
    #     rv = Integer[]
    #     for e in edges(wer)
    #         a = e.src
    #         graphpt = get_vertex(wer, a)
    #         if 0 < sum(planevec .* (graphpt - planept))
    #             push!(rv, a)
    #         end
    #     end

    #     # TODO
    # end

    display(scene)
end