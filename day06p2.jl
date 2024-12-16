filename = "day06/input.txt"
# filename = "day06/test.txt"

open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

function rotate(direction)
    direction == '^' && return '>'
    direction == '>' && return 'v'
    direction == 'v' && return '<'
    direction == '<' && return '^'
end

function step(matrix, pos, direction)
    direction == '^' && (new_pos = pos .+ (-1, 0))
    direction == '>' && (new_pos = pos .+ (0, 1))
    direction == 'v' && (new_pos = pos .+ (1, 0))
    direction == '<' && (new_pos = pos .+ (0, -1))

    checkbounds(Bool, matrix, new_pos...) || return nothing, nothing
    matrix[new_pos...] == '#' && return pos, rotate(direction)
    return new_pos, direction
end

function makes_loop(matrix, pos, direction)
    path = fill("", size(matrix))
    while !isnothing(pos)
        direction in path[pos...] && return true
        path[pos...] *= direction
        pos, direction = step(matrix, pos, direction)
    end
    return false
end

direction = '^'
pos = findfirst(matrix .== '^') |> Tuple
path = fill("", size(matrix))
obstructions = fill(false, size(matrix))

while !isnothing(pos)
    global pos, direction
    path[pos...] *= direction

    ahead, _ = step(matrix, pos, direction)
    if !isnothing(ahead) && isempty(path[ahead...])
        temp_matrix = copy(matrix)
        temp_matrix[ahead...] = '#'
        makes_loop(temp_matrix, pos, rotate(direction)) && (obstructions[ahead...] = true)
    end

    pos, direction = step(matrix, pos, direction)
end
obstructions |> sum
