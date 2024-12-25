using SparseArrays

struct Robot
    p::Tuple{Int,Int}
    v::Tuple{Int,Int}
end

function day14p2(filename, w, h)
    robots = Vector{Robot}()
    for line in readlines(filename)
        px, py, vx, vy = match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", line).captures .|> x -> parse(Int, x)
        push!(robots, Robot((px, py), (vx, vy)))
    end

    image = fill(false, (w, h))
    for t = 1:w*h
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
end

function walk(r::Robot, w, h, time)
    x = (r.p[1] + time * r.v[1]) % w
    y = (r.p[2] + time * r.v[2]) % h
    x < 0 && (x += w)
    y < 0 && (y += h)
    (x, y)
end

filename = "day14/input.txt"
w = 101
h = 103

day14p2(filename, w, h)
