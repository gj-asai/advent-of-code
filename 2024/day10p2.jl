function day10p2(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...)) .|> x -> parse(Int, x)

    total = 0
    score = propagate(matrix)
    for pos in eachindex(IndexCartesian(), matrix)
        matrix[pos] == 0 || continue
        total += score[pos]
    end
    total
end

function reach(matrix, pos)
    reachable = Vector{CartesianIndex}()

    for nextpos in pos .+ CartesianIndex.([(1, 0), (0, -1), (-1, 0), (0, 1)])
        checkbounds(Bool, matrix, nextpos) || continue
        matrix[nextpos] == matrix[pos] - 1 || continue
        push!(reachable, nextpos)
        for p in reach(matrix, nextpos)
            push!(reachable, p)
        end
    end
    reachable
end

function propagate(matrix)
    ans = fill(0, size(matrix))
    for pos in eachindex(IndexCartesian(), matrix)
        matrix[pos] == 9 || continue
        for r in reach(matrix, pos)
            ans[r] += 1
        end
    end
    ans
end

filename = "day10/input.txt"
# filename = "day10/test.txt"
day10p2(filename)
