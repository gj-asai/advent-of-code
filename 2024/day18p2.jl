function day18p2(filename, grid_size)
    bytes = Vector{CartesianIndex}()
    for line in readlines(filename)
        x, y = split(line, ",") .|> x -> parse(Int, x)
        push!(bytes, CartesianIndex(x + 1, y + 1))
    end

    lower = 0
    upper = length(bytes)
    while upper - lower > 1
        ncorrupted = (lower + upper) ÷ 2
        if is_exitable!(grid_size, bytes[1:ncorrupted])
            lower = ncorrupted
        else
            upper = ncorrupted
        end
    end
    pos = bytes[upper]
    join([pos[1] - 1, pos[2] - 1], ",")
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

function is_exitable!(grid_size, corrupted_bytes)
    memory = fill(true, (grid_size, grid_size))
    for pos in corrupted_bytes
        memory[pos] = false
    end

    start = CartesianIndex(1, 1)
    exit = CartesianIndex(grid_size, grid_size)

    distances = fill(Inf, (grid_size, grid_size))
    distances[start] = 0
    propagate_distances!(distances, memory, start)
    return !isinf(distances[exit])
end

filename = "day18/input.txt"
grid_size = 71
# filename = "day18/test.txt"
# grid_size = 7
day18p2(filename, grid_size)
