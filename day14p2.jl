using SparseArrays

filename = "day14/input.txt"
w = 101
h = 103

struct Robot
    p::Tuple{Int64,Int64}
    v::Tuple{Int64,Int64}
end

function walk(r::Robot, w, h, time)
    x = (r.p[1] + time * r.v[1]) % w
    y = (r.p[2] + time * r.v[2]) % h
    x < 0 && (x += w)
    y < 0 && (y += h)
    (x, y)
end

robots = Robot[]
open(filename, "r") do f
    for line in eachline(f)
        px, py, vx, vy = match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", line).captures .|> x -> parse(Int64, x)
        push!(robots, Robot((px, py), (vx, vy)))
    end
end

image = fill(false, (w, h))
for t = 1:10000
    fill!(image, false)
    for r in robots
        newpos = walk(r, w, h, t)
        image[newpos[1]+1, newpos[2]+1] = true
    end
    sp = sparse(image)
    if nnz(sp) > 499
        println("t = $t")
        display(sp)
    end
end
