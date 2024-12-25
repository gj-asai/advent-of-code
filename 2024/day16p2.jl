function day16p2(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    start = findfirst(matrix .== 'S')
    finish = findfirst(matrix .== 'E')
    scores = fill(Inf, size(matrix))
    scores[start] = 0
    compute_score!(scores, matrix, start, '>')

    paths = fill(false, size(scores))
    paths[finish] = true
    reconstruct_paths!(paths, scores, finish, start)
    sum(paths)
end

function rotate_left(direction)
    direction == '^' && return '<'
    direction == '>' && return '^'
    direction == 'v' && return '>'
    direction == '<' && return 'v'
end
function rotate_right(direction)
    direction == '^' && return '>'
    direction == '>' && return 'v'
    direction == 'v' && return '<'
    direction == '<' && return '^'
end

function step(pos, direction)
    direction == '^' && return pos + CartesianIndex(-1, 0)
    direction == '>' && return pos + CartesianIndex(0, 1)
    direction == 'v' && return pos + CartesianIndex(1, 0)
    direction == '<' && return pos + CartesianIndex(0, -1)
end

function compute_score!(scores, matrix, pos, direction)
    current = scores[pos]

    front = step(pos, direction)
    if matrix[front] != '#' && scores[front] > current + 1
        scores[front] = current + 1
        compute_score!(scores, matrix, front, direction)
    end

    left = step(pos, rotate_left(direction))
    if matrix[left] != '#' && scores[left] > current + 1001
        scores[left] = current + 1001
        compute_score!(scores, matrix, left, rotate_left(direction))
    end

    right = step(pos, rotate_right(direction))
    if matrix[right] != '#' && scores[right] > current + 1001
        scores[right] = current + 1001
        compute_score!(scores, matrix, right, rotate_right(direction))
    end
end

function reconstruct_paths!(paths, scores, pos, start)
    pos == start && return
    current = scores[pos]

    n = step(pos, '^')
    e = step(pos, '>')
    s = step(pos, 'v')
    w = step(pos, '<')
    forward = [n, e, s, w]
    backward = [s, w, n, e]

    for (ff, bb) in zip(forward, backward)
        if scores[ff] == current - 1 || scores[ff] == current - 1001 ||
           (scores[ff] == current + 999 && scores[bb] == current + 1001 && paths[bb]) # when two paths intersect
            paths[ff] = true
            reconstruct_paths!(paths, scores, ff, start)
        end
    end
end

filename = "day16/input.txt"
# filename = "day16/test.txt"
# filename = "day16/test2.txt"
day16p2(filename)
