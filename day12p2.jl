filename = "day12/input.txt"
# filename = "day12/test.txt"

matrix = Matrix{Char}(undef, 0, 0)
open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

struct Border
    y::Int
    x1::Int
    x2::Int
    normal::Int
end
Base.hash(b::Border, h::UInt) = hash(b.y, hash(b.x1, hash(b.x2, hash(:Border, h))))
Base.isequal(b1::Border, b2::Border) = Base.isequal(hash(b1), hash(b2))

struct Region
    type::Char
    pos::Vector{CartesianIndex}
    borderh::Vector{Border}
    borderv::Vector{Border}
end
Region(type::Char, pos::CartesianIndex) = Region(type, [pos],
    [Border(pos[2], pos[1], pos[1] + 1, -1), Border(pos[2] + 1, pos[1], pos[1] + 1, 1)],
    [Border(pos[1], pos[2], pos[2] + 1, -1), Border(pos[1] + 1, pos[2], pos[2] + 1, 1)])

area(r::Region) = length(r.pos)
perimeter(r::Region) = length(r.borderh) + length(r.borderv)
function sides(r::Region)
    nsides = perimeter(r)
    for (i, hi) in pairs(r.borderh), hj in @view r.borderh[i+1:end]
        hi.y == hj.y || continue
        hi.normal == hj.normal || continue
        hi.x1 == hj.x2 && (nsides -= 1)
        hi.x2 == hj.x1 && (nsides -= 1)
    end
    for (i, vi) in pairs(r.borderv), vj in @view r.borderv[i+1:end]
        vi.y == vj.y || continue
        vi.normal == vj.normal || continue
        vi.x1 == vj.x2 && (nsides -= 1)
        vi.x2 == vj.x1 && (nsides -= 1)
    end
    nsides
end

function touching(pos::CartesianIndex, region::Region)
    pos + CartesianIndex(-1, 0) in region.pos && return true
    pos + CartesianIndex(0, -1) in region.pos && return true
    pos + CartesianIndex(1, 0) in region.pos && return true
    pos + CartesianIndex(0, 1) in region.pos && return true
    false
end

function add_plant!(pos::CartesianIndex, region::Region)
    push!(region.pos, pos)

    x, y = pos[1], pos[2]
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
for pos in eachindex(IndexCartesian(), matrix)
    added = false
    first_region = nothing
    for r in regions
        r.type == matrix[pos] || continue
        touching(pos, r) || continue

        added && (merge!!(first_region, r); continue)

        add_plant!(pos, r)
        first_region = r
        added = true
    end
    !added && push!(regions, Region(matrix[pos], pos))
end

price = [area(r) * sides(r) for r in regions] |> sum
