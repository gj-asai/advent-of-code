function day04p2(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    accessible = 0
    while true
        cur_round = 0
        new_matrix = copy(matrix)

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

            adjacent < 4 && (cur_round += 1; new_matrix[pos] = '.')
        end

        accessible += cur_round
        matrix = new_matrix
        cur_round == 0 && break
    end

    accessible
end

filename = "day04/input.txt"
# filename = "day04/test.txt"
day04p2(filename)
