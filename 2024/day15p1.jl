function day15p1(filename)
    lines = join(readlines(filename), "\n")
    matrix_in, moves_in = split(lines, "\n\n")

    matrix = map(collect, split(matrix_in, "\n"))
    matrix = permutedims(hcat(matrix...))

    moves = Vector{Char}()
    for line in split(moves_in, "\n")
        append!(moves, collect(line))
    end

    pos = findfirst(matrix .== '@')
    for m in moves
        move!(matrix, pos, m) && (pos = next_pos(pos, m))
    end

    coordinates = 0
    for box in findall(matrix .== 'O')
        coordinates += 100 * (box[1] - 1) + box[2] - 1
    end
    coordinates
end

function next_pos(pos, direction)
    direction == '^' && return pos + CartesianIndex(-1, 0)
    direction == '>' && return pos + CartesianIndex(0, 1)
    direction == 'v' && return pos + CartesianIndex(1, 0)
    direction == '<' && return pos + CartesianIndex(0, -1)
end

function move!(matrix, pos, direction)
    new_pos = next_pos(pos, direction)

    matrix[new_pos] == '#' && return false
    matrix[new_pos] == 'O' && !move!(matrix, new_pos, direction) && return false

    matrix[new_pos] = matrix[pos]
    matrix[pos] = '.'
    return true
end

filename = "day15/input.txt"
# filename = "day15/test1.txt"
# filename = "day15/test2.txt"
# filename = "day15/test3.txt"
day15p1(filename)
