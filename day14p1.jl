filename = "day14/input.txt"
w = 101
h = 103

# filename = "day14/test.txt"
# w = 11
# h = 7

struct Robot
    p::Tuple{Int,Int}
    v::Tuple{Int,Int}
end

function walk(r::Robot, w, h, time)
    x = (r.p[1] + time * r.v[1]) % w
    y = (r.p[2] + time * r.v[2]) % h
    x < 0 && (x += w)
    y < 0 && (y += h)
    (x, y)
end

function quadrant(pos, w, h)
    divw, divh = (w - 1) / 2, (h - 1) / 2
    pos[1] < divw && pos[2] < divh && return 1
    pos[1] > divw && pos[2] < divh && return 2
    pos[1] < divw && pos[2] > divh && return 3
    pos[1] > divw && pos[2] > divh && return 4
    return 0
end

robots = Robot[]
open(filename, "r") do f
    for line in eachline(f)
        px, py, vx, vy = match(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)", line).captures .|> x -> parse(Int, x)
        push!(robots, Robot((px, py), (vx, vy)))
    end
end

quadrants = [0, 0, 0, 0]
for r in robots
    newpos = walk(r, w, h, 100)
    q = quadrant(newpos, w, h)
    q == 0 && continue
    quadrants[q] += 1
end
prod(quadrants)
