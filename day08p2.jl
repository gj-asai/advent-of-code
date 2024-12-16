filename = "day08/input.txt"
# filename = "day08/test.txt"

matrix = Matrix{Char}(undef, 0, 0)
open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

frequencies = Dict([])
for pos in eachindex(IndexCartesian(), matrix)
    f = matrix[pos]
    f == '.' && continue
    f in keys(frequencies) || (frequencies[f] = [])
    push!(frequencies[f], pos)
end

function get_antinodes(matrix, pos1, pos2)
    antinodes = []
    vec12 = pos2 - pos1

    i = 0
    while true
        a = pos1 - i * vec12
        checkbounds(Bool, matrix, a) || break
        push!(antinodes, a)
        i += 1
    end

    antinodes
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
antinodes |> sum
