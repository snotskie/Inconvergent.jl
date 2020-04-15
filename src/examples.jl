function lines_example()
    size = 1000
    repeat = 15
    grains = 3
    itt = 1000
    itt2 = 100 # modified: split from itt, set smaller
    sand = Sandpaint(size,
                     RGBA(colorant"black", 0.01),
                     colorant"white")
    
    # modified: removed the outermost loop
    p1 = Point2f0(100, 500)
    p2 = Point2f0(900, 500)
    for j in LinRange(0, 15, repeat+1)
        wer = Weir()

        va = Point2f0(0, 0)
        for s in LinRange(0, 1, itt)
            v1 = s*(p2 - p1) + p1
            v2 = v1 + va
            va = random_point_in_circle(0.7 * j, va)

            # modified: grabbing the ind values
            ind1 = add_vertex!(wer, v1)
            ind2 = add_vertex!(wer, v2)
            add_edge!(wer, ind1, ind2)
        end

        # modified: restructured, pulled this out a nest,
        # so that above we create the edges, and below we
        # draw the sand strokes.
        vb = Point2f0(0, 0)
        for k in 1:itt2
            vb = random_point_in_circle(0.001 * j, vb)
            for e in edges(wer)
                source = get_vertex(wer, e.src)
                dest = get_vertex(wer, e.dst)
                move_vertex_by!(wer, e.src, random_point_in_circle(0.1, vb))
                move_vertex_by!(wer, e.dst, random_point_in_circle(0.1, vb))
                stroke(sand, source, dest, grains)
            end

            # modified: skip edge check, since I know they all are
            points(sand, pt for (ind, pt) in get_vertices(wer)) 
        end
    end

    display(sand)
end