function day18p1(filename, grid_size, ncorrupted)
    bytes = Vector{CartesianIndex}()
    for line in readlines(filename)
        x, y = split(line, ",") .|> x -> parse(Int, x)
        push!(bytes, CartesianIndex(x + 1, y + 1))
    end

    memory = fill(true, (grid_size, grid_size))
    for pos in @view bytes[1:ncorrupted]
        memory[pos] = false
    end

    start = CartesianIndex(1, 1)
    exit = CartesianIndex(grid_size, grid_size)

    distances = fill(Inf, (grid_size, grid_size))
    distances[start] = 0
    propagate_distances!(distances, memory, start)
    distances[exit] |> Int
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

filename = "day18/input.txt"
grid_size = 71
ncorrupted = 1024
# filename = "day18/test.txt"
# grid_size = 7
# ncorrupted = 12
day18p1(filename, grid_size, ncorrupted)
