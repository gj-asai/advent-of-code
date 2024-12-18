filename = "day18/input.txt"
SIZE = 71
NCORRRUPTED = 1024
# filename = "day18/test.txt"
# SIZE = 7
# NCORRRUPTED = 12

bytes = Vector{CartesianIndex}()
open(filename, "r") do f
    while !eof(f)
        x, y = split(readline(f), ",") .|> x -> parse(Int, x)
        push!(bytes, CartesianIndex(x + 1, y + 1))
    end
end

memory = fill(true, (SIZE, SIZE))
for pos in @view bytes[1:NCORRRUPTED]
    memory[pos] = false
end

function propagate_distances!(distances, memory, pos)
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

start = CartesianIndex(1, 1)
exit = CartesianIndex(SIZE, SIZE)

distances = fill(Inf, (SIZE, SIZE))
distances[start] = 0
propagate_distances!(distances, memory, start)
distances[exit] |> Int
