filename = "day10/input.txt"
# filename = "day10/test.txt"

open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...)) .|> x -> parse(Int64, x)
end

function reach(matrix, pos...)
        reachable = Vector{Tuple{Int64,Int64}}([])

    i, j = pos
    nextpos = [(i + 1, j), (i, j - 1), (i - 1, j), (i, j + 1)]
    for (inext, jnext) in nextpos
        checkbounds(Bool, matrix, inext, jnext) || continue
        matrix[inext, jnext] == matrix[i, j] - 1 || continue
        push!(reachable, (inext, jnext))
        for p in reach(matrix, inext, jnext)
            push!(reachable, p)
        end
    end
    reachable
end

function propagate(matrix)
    ans = fill(0, size(matrix))
    for i in axes(matrix, 2), j in axes(matrix, 1)
        matrix[i, j] == 9 || continue
        for (ri, rj) in reach(matrix, i, j)
            ans[ri, rj] += 1
        end
    end
    ans
end

total = 0
score = propagate(matrix)
for i in axes(matrix, 2), j in axes(matrix, 1)
    matrix[i, j] == 0 && (global total += score[i, j])
end
total
