function day06p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    direction = '^'
    pos = findfirst(matrix .== direction)
    path = fill("", size(matrix))

    count = 0
    while !isnothing(pos)
        isempty(path[pos]) && (count += 1)
        path[pos] *= direction
        pos, direction = step(matrix, pos, direction)
    end
    count
end

function rotate(direction)
    direction == '^' && return '>'
    direction == '>' && return 'v'
    direction == 'v' && return '<'
    direction == '<' && return '^'
end

function step(matrix, pos, direction)
    direction == '^' && (new_pos = pos + CartesianIndex(-1, 0))
    direction == '>' && (new_pos = pos + CartesianIndex(0, 1))
    direction == 'v' && (new_pos = pos + CartesianIndex(1, 0))
    direction == '<' && (new_pos = pos + CartesianIndex(0, -1))

    checkbounds(Bool, matrix, new_pos) || return nothing, nothing
    matrix[new_pos] == '#' && return pos, rotate(direction)
    return new_pos, direction
end

filename = "day06/input.txt"
# filename = "day06/test.txt"
day06p1(filename)
