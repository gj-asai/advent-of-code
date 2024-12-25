function day25p1(filename)
    all_keys = Vector{Vector{Int}}()
    all_locks = Vector{Vector{Int}}()

    lines = join(readlines(filename), "\n")
    for block in split(lines, "\n\n")
        type = block[1] == '.' ? all_keys : all_locks
        columns = sum([[c == '#' for c in line] for line in split(block, "\n")]) .- 1
        push!(type, columns)
    end

    total = 0
    for k in all_keys, l in all_locks
        all(k + l .<= 5) && (total += 1)
    end
    total
end

filename = "day25/input.txt"
# filename = "day25/test.txt"
day25p1(filename)
