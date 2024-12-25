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

function day12p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    regions = Vector{Region}()
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

    sum([area(r) * perimeter(r) for r in regions])
end

area(r::Region) = length(r.pos)
perimeter(r::Region) = length(r.borderh) + length(r.borderv)

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

filename = "day12/input.txt"
# filename = "day12/test.txt"
day12p1(filename)
