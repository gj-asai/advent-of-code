function day08p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    frequencies = Dict{Char, Vector{CartesianIndex}}()
    for pos in eachindex(IndexCartesian(), matrix)
        f = matrix[pos]
        f == '.' && continue
        f in keys(frequencies) || (frequencies[f] = Vector{CartesianIndex}())
        push!(frequencies[f], pos)
    end

    antinodes = fill(false, size(matrix))
    for antennas in values(frequencies)
        for ai in antennas, aj in antennas
            ai == aj && continue
            for a in get_antinodes(matrix, ai, aj)
                antinodes[a] = true
            end
        end
    end
    sum(antinodes)
end

function get_antinodes(matrix::Matrix{Char}, pos1::CartesianIndex, pos2::CartesianIndex)
    antinodes = Vector{CartesianIndex}()
    vec12 = pos2 - pos1

    a1 = pos1 - vec12
    checkbounds(Bool, matrix, a1) && push!(antinodes, a1)

    antinodes
end

filename = "day08/input.txt"
# filename = "day08/test.txt"
day08p1(filename)
