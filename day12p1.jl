filename = "day12/input.txt"
# filename = "day12/test.txt"

open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

struct Border
    y::Int64
    x1::Int64
    x2::Int64
    normal::Int64
end
Base.hash(b::Border, h::UInt) = hash(b.y, hash(b.x1, hash(b.x2, hash(:Border, h))))
Base.isequal(b1::Border, b2::Border) = Base.isequal(hash(b1), hash(b2))

struct Region
    type::Char
    pos::Vector{Tuple{Int64,Int64}}
    borderh::Vector{Border}
    borderv::Vector{Border}
end
Region(type::Char, pos::Tuple{Int64,Int64}) = Region(type, [pos],
    [Border(pos[2], pos[1], pos[1] + 1, -1), Border(pos[2] + 1, pos[1], pos[1] + 1, 1)],
    [Border(pos[1], pos[2], pos[2] + 1, -1), Border(pos[1] + 1, pos[2], pos[2] + 1, 1)])

area(r::Region) = length(r.pos)
perimeter(r::Region) = length(r.borderh) + length(r.borderv)

function touching(pos::Tuple{Int64,Int64}, region::Region)
    pos .+ (-1, 0) in region.pos && return true
    pos .+ (0, -1) in region.pos && return true
    pos .+ (1, 0) in region.pos && return true
    pos .+ (0, 1) in region.pos && return true
    false
end

function add_plant!(pos::Tuple{Int64,Int64}, region::Region)
    push!(region.pos, pos)

    x, y = pos
    borderh = [Border(y, x, x + 1, -1), Border(y + 1, x, x + 1, 1)]
    borderv = [Border(x, y, y + 1, -1), Border(x + 1, y, y + 1, 1)]

    symdiff!(region.borderh, borderh)
    symdiff!(region.borderv, borderv)
end

function merge!!(ri::Region, rj::Region)
    for pj in rj.pos
        add_plant!(pj, ri)
    end
    empty!(rj.pos)
    empty!(rj.borderh)
    empty!(rj.borderv)
end

regions = Region[]
for i in axes(matrix, 2), j in axes(matrix, 1)
    added = false
    first_region = nothing
    for r in regions
        r.type == matrix[i, j] || continue
        touching((i, j), r) || continue

        added && (merge!!(first_region, r); continue)

        add_plant!((i, j), r)
        first_region = r
        added = true
    end
    !added && push!(regions, Region(matrix[i, j], (i, j)))
end

price = [area(r) * perimeter(r) for r in regions] |> sum
