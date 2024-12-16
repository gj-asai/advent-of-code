filename = "day15/input.txt"
# filename = "day15/test1.txt"
# filename = "day15/test2.txt"
# filename = "day15/test3.txt"

matrix = []
moves = []
open(filename, "r") do f
    while !eof(f)
        line = readline(f)
        isempty(line) && break
        push!(matrix, line)
    end
    while !eof(f)
        line = readline(f)
        append!(moves, collect(line))
    end
end
matrix = map(collect, matrix)
matrix = permutedims(hcat(matrix...))

function next_pos(pos, direction)
    direction == '^' && return pos + CartesianIndex(-1, 0)
    direction == '>' && return pos + CartesianIndex(0, 1)
    direction == 'v' && return pos + CartesianIndex(1, 0)
    direction == '<' && return pos + CartesianIndex(0, -1)
end

function check_movable(matrix, pos, direction)
    new_pos = next_pos(pos, direction)
    matrix[new_pos] == '.' && return true
    matrix[new_pos] == '#' && return false

    if direction == '>' || direction == '<'
        return check_movable(matrix, new_pos, direction)
    end

    if direction == '^' || direction == 'v'
        matrix[new_pos] == '[' && (extra_new_pos = new_pos + CartesianIndex(0, 1))
        matrix[new_pos] == ']' && (extra_new_pos = new_pos + CartesianIndex(0, -1))
        return check_movable(matrix, new_pos, direction) && check_movable(matrix, extra_new_pos, direction)
    end
end

function move!(matrix, pos, direction)
    !check_movable(matrix, pos, direction) && return false

    new_pos = next_pos(pos, direction)
    if direction == '^' || direction == 'v'
        matrix[new_pos] == '[' && move!(matrix, new_pos + CartesianIndex(0, 1), direction)
        matrix[new_pos] == ']' && move!(matrix, new_pos + CartesianIndex(0, -1), direction)
    end
    matrix[new_pos] != '.' && move!(matrix, new_pos, direction)

    matrix[new_pos] = matrix[pos]
    matrix[pos] = '.'
    return true
end

matrix_large = fill('.', (1, 2) .* size(matrix))
for i in axes(matrix, 2), j in axes(matrix, 1)
    if matrix[i, j] == '#'
        matrix_large[i, 2j-1] = '#'
        matrix_large[i, 2j] = '#'
    elseif matrix[i, j] == 'O'
        matrix_large[i, 2j-1] = '['
        matrix_large[i, 2j] = ']'
    elseif matrix[i, j] == '@'
        matrix_large[i, 2j-1] = '@'
    end
end

pos = findfirst(matrix_large .== '@')
for m in moves
    move!(matrix_large, pos, m) && (global pos = next_pos(pos, m))
end

coordinates = 0
for box in findall(matrix_large .== '[')
    global coordinates += 100 * (box[1] - 1) + box[2] - 1
end
coordinates
