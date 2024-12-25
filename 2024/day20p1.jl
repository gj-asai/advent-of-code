function day20p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    start = findfirst(matrix .== 'S')
    path = fill(-1, size(matrix))
    path[start] = 0
    get_path!(path, matrix, start)

    count = 0
    for pos in eachindex(IndexCartesian(), path)
        count += sum(cheat(path, pos) .>= 100)
    end
    count
end

function get_path!(path, matrix, pos)
    for nextpos in pos .+ CartesianIndex.([(0, 1), (-1, 0), (0, -1), (1, 0)])
        matrix[nextpos] == '#' && continue
        path[nextpos] != -1 && continue

        path[nextpos] = path[pos] + 1
        get_path!(path, matrix, nextpos)
        break
    end
end

function cheat(path, pos)
    path[pos] == -1 && return Int[]

    finalpos = pos .+ CartesianIndex.([(0, 2), (-2, 0), (0, -2), (2, 0)])
    saved = Int[]
    for nextpos in finalpos
        checkbounds(Bool, path, nextpos) || continue
        path[nextpos] > path[pos] + 2 || continue
        push!(saved, path[nextpos] - path[pos] - 2)
    end
    saved
end

filename = "day20/input.txt"
# filename = "day20/test.txt"
day20p1(filename)
