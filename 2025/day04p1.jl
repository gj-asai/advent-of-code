function day04p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    accessible = 0
    for pos in eachindex(IndexCartesian(), matrix)
        matrix[pos] == '.' && continue

        adjacent = 0
        neighbors = pos .+ CartesianIndex.([
            (-1, -1), (-1, 0), (-1, 1),
            (0, -1), (0, 1),
            (1, -1), (1, 0), (1, 1)
        ])
        for nextpos in neighbors
            checkbounds(Bool, matrix, nextpos) || continue
            matrix[nextpos] == '@' && (adjacent += 1)
        end

        adjacent < 4 && (accessible += 1)
    end

    accessible
end

filename = "day04/input.txt"
# filename = "day04/test.txt"
day04p1(filename)
