filename = "day18/input.txt"
SIZE = 71
# filename = "day18/test.txt"
# SIZE = 7

bytes = Vector{CartesianIndex}()
open(filename, "r") do f
    while !eof(f)
        x, y = split(readline(f), ",") .|> x -> parse(Int, x)
        push!(bytes, CartesianIndex(x + 1, y + 1))
    end
end

function propagate_distances!(distances, memory, pos)
    isinf(distances[SIZE, SIZE]) || return
    cur = distances[pos]

    neighbors = @. pos + CartesianIndex([(1, 0), (0, -1), (-1, 0), (0, 1)])
    for n in neighbors
        checkbounds(Bool, memory, n) || continue
        if memory[n] && distances[n] > cur + 1
            distances[n] = cur + 1
            propagate_distances!(distances, memory, n)
        end
    end
end

function is_exitable!(memory, new_corrupted)
    start = CartesianIndex(1, 1)
    exit = CartesianIndex(SIZE, SIZE)

    memory[new_corrupted] = false

    distances = fill(Inf, (SIZE, SIZE))
    distances[start] = 0
    propagate_distances!(distances, memory, start)
    return !isinf(distances[exit])
end

memory = fill(true, (SIZE, SIZE))
for corrupted in bytes
    is_exitable!(memory, corrupted) && continue
    println(join([corrupted[1] - 1, corrupted[2] - 1], ","))
    break
end
