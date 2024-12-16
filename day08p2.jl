filename = "day08/input.txt"
# filename = "day08/test.txt"

open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

frequencies = Dict([])
for i in axes(matrix, 2), j in axes(matrix, 1)
    f = matrix[i, j]
    f == '.' && continue
    f in keys(frequencies) || (frequencies[f] = [])
    push!(frequencies[f], (i, j))
end

function get_antinodes(matrix, pos1, pos2)
    antinodes = []
    vec12 = pos2 .- pos1

    i = 0
    while true
        a = pos1 .- i .* vec12
        checkbounds(Bool, matrix, a...) || break
        push!(antinodes, a)
        i += 1
    end

    i = 0
    while true
        a = pos2 .+ i .* vec12
        checkbounds(Bool, matrix, a...) || break
        push!(antinodes, a)
        i += 1
    end

    antinodes
end

antinodes = fill(false, size(matrix))
for antennas in values(frequencies)
    for i in 1:length(antennas), j in i+1:length(antennas)
        for a in get_antinodes(matrix, antennas[i], antennas[j])
            antinodes[a...] = true
        end
    end
end
antinodes |> sum
