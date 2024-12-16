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

function move!(matrix, pos, direction)
    new_pos = next_pos(pos, direction)

    matrix[new_pos] == '#' && return false
    matrix[new_pos] == 'O' && !move!(matrix, new_pos, direction) && return false

    matrix[new_pos] = matrix[pos]
    matrix[pos] = '.'
    return true
end

pos = findfirst(matrix .== '@')
for m in moves
    move!(matrix, pos, m) && (global pos = next_pos(pos, m))
end

coordinates = 0
for box in findall(matrix .== 'O')
    global coordinates += 100 * (box[1] - 1) + box[2] - 1
end
coordinates
