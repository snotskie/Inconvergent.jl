# Inconvergent.jl

A port from lisp to Julia of Ander Hoff's [weir](https://github.com/inconvergent/weir/tree/master/src) for creating generative art.

## Installation

```
] add https://github.com/snotskie/Inconvergent.jl
```

## Examples

```julia
using Inconvergent

lines_example()
```

## Contents

Most of the original weir already existed in the Julia ecosystem, so what Inconvergent.jl adds is:

- Sandpaint, a class and set of methods for doing [sand painting](https://inconvergent.net/2017/grains-of-sand/), a gritty visual effect
- Weir ("wire"), a class and set of methods for representing undirected graphs with 4D point data associated with each vertex, and a set of methods for making generative ["mistakes"](https://inconvergent.net/2017/a-propensity-for-mistakes/) on those structures
- Bindings from those to the Julia ecosystem. For example, `display(sand)` on a `Sandpaint` object will display the drawing in your Julia plots window.

## TODO

- [x] Refactor random.jl to return 4d points and accept any-d points: DONE
- [x] Adjust Sandpaint so you can specify which projection to use
- [x] Refactor sandpaint.jl to accept any-d points: SKIP can just do this by having a project function that accepts any-d points, and use that within the exported draw functions to then move down to 2d points for the low-level `__` functions
- [ ] Finish implementing examples, with images for each result
- [ ] Finish implementing Sandpaint drawing methods
- [ ] Finish implementing Weir alteration methods
- [ ] Finish testing Makie as a replacement for weir's svg