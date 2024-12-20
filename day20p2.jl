filename = "day20/input.txt"
# filename = "day20/test.txt"

matrix = Matrix{Char}(undef, 0, 0)
open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
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

    saved = Int[]
    for time = 2:20, i = 0:time
        reach = [(i, time - i), (-i, i - time), (i, i - time), (-i, time - i)] |> Set
        for nextpos in pos .+ CartesianIndex.(reach)
            checkbounds(Bool, path, nextpos) || continue
            path[nextpos] > path[pos] + time || continue
            push!(saved, path[nextpos] - path[pos] - time)
        end
    end
    saved
end

start = findfirst(matrix .== 'S')
path = fill(-1, size(matrix))
path[start] = 0
get_path!(path, matrix, start)

count = 0
for pos in eachindex(IndexCartesian(), path)
    global count += sum(cheat(path, pos) .>= 100)
end
count
