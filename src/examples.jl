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



# (defun -dot-split (wer e xp plane-point plane-vec g)
#   (weir:ldel-edge! wer e :g g)
#   (destructuring-bind (a b) e
#     (if (> (vec:3dot plane-vec (vec:3sub (weir:3get-vert wer a) plane-point)) 0d0)
#       (progn (weir:add-edge! wer (weir:3add-vert! wer xp) b :g g)
#              (weir:add-edge! wer (weir:3add-vert! wer xp) a :g g))
#       (progn (weir:add-edge! wer (weir:3add-vert! wer xp) a :g g)
#              (weir:add-edge! wer (weir:3add-vert! wer xp) b :g g)))))


# (defun plane-intersect (wer &key plane-point plane-vec (a 0d0) (dst 0d0) dot-split g)
#   (let* ((rv (hset:make))
#          (do-split (if dot-split
#                        (lambda (e xp)
#                          (-dot-split wer e xp plane-point plane-vec g))
#                        (lambda (e xp)
#                          (list (weir:3lsplit-edge! wer e :xy xp))))))
#     (weir:itr-grp-verts (wer v :g g)
#       (when (> (vec:3dot plane-vec (vec:3sub (weir:3get-vert wer v)
#                                              plane-point))
#                0d0)
#             (hset:add rv v)))

#     (weir:itr-edges (wer e :g g)
#       (multiple-value-bind (x d xp) (vec:3planex plane-vec plane-point
#                                                  (weir:3get-verts wer e))
#         (when (and x (< 0d0 d 1d0))
#           (hset:add* rv  (funcall do-split e xp)))))

#     (weir:3transform! wer (hset:to-list rv)
#       (lambda (vv) (vec:3ladd* (vec:3lrot* vv plane-vec a :xy plane-point)
#                                (vec:3smult plane-vec dst))))))



# (defun get-width (d)
#   (* 4d0 (expt (- 1d0 (max 0d0 (min (/ d 1500d0) 1d0))) 2d0)))


# (defun dst-draw (wer proj psvg)
#   (loop with lr = (line-remove:make :cnt 8 :rs 2d0 :is 1.5d0)
#         for e in (weir:get-edges wer)
#         do (let* ((point-dst (ortho:project* proj (weir:3get-verts wer e)))
#                   (dsts (math:lpos point-dst :fx #'second)))
#              (loop for path across
#                      (line-remove:path-split lr
#                        (list (cpath:cpath (weir-utils:to-vector (math:lpos point-dst))
#                                           (loop for d in dsts collect (get-width d))
#                                           (ceiling (* 2.2d0 (get-width (apply #'max dsts)))))))
#                    do (draw-svg:path psvg path :sw 0.8d0 :so 0.9d0 :stroke "black")))
#         finally (print (line-remove:stats lr))))


# (defun init-cube (n m s)
#   (let* ((dots (weir-utils:to-vector (rnd:3nin-cube m s)))
#          (dt (kdtree:make (weir-utils:to-list dots)))
#          (res (weir-utils:make-adjustable-vector)))

#     (loop for rad in (rnd:nrnd 3 500d0)
#           for mid in (math:nrep 3 (rnd:3on-sphere :rad 300d0))
#           do (loop for p in (math:nrep n (rnd:3on-sphere :rad rad :xy mid))
#                    if (> (vec:3dst p (aref dots (kdtree:nn dt p )))
#                          90d0)
#         do (weir-utils:vextend p res)))
#     (weir-utils:to-list res)))

function rel_neigh_example()
    size = 1000
    scene = Scene() # from Makie
    wer = Weir()
    mid = Point4f0(size/2)
    # st = Dict()
    # proj = 
    # HERE
end

# (defun main (size fn)
#   (let* ((psvg (draw-svg:make*))
#          (wer (weir:make :dim 3 :max-verts 200000))
#          (mid (vec:rep 500d0))
#          (st (state:make))
#          (proj (ortho:make :s 0.5d0
#                            :xy mid
#                            :cam (rnd:3on-sphere :rad 1000d0)
#                            :look vec:*3zero*)))

#      (loop repeat 2 do (plane-intersect wer
#                          :plane-point (rnd:3in-cube 500d0)
#                          :plane-vec (rnd:3on-sphere)
#                          :a (rnd:rnd 0.5d0) :dst 100d0
#                          :dot-split t))

#     (weir:3add-verts! wer (init-cube 7000 800 500d0))

#     (weir:3relative-neighborhood! wer 500d0)

#     (loop repeat 2 do (plane-intersect wer :plane-point (rnd:3in-cube 300d0)
#                                            :plane-vec (rnd:3on-sphere)
#                                            :a (rnd:rnd 0.3d0)
#                                            :dst 250d0
#                                            :dot-split t))

#     (dst-draw wer proj psvg)
#     (draw-svg:save psvg fn)))

# (time (main 1000 (second (weir-utils:cmd-args))))