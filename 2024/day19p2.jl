function day19p2(filename)
    lines = join(readlines(filename), "\n")
    towels_in, designs_in = split(lines, "\n\n")

    towels = split(towels_in, ", ")

    designs = Vector{String}()
    for line in split(designs_in, "\n")
        push!(designs, line)
    end

    cache = Dict{String, Int}()
    sum([possible_arrangements!(cache, d, towels) for d in designs])
end

function possible_arrangements!(cache, design, towels)
    length(design) == 0 && return 1
    design in keys(cache) && return cache[design]

    total = 0
    for t in towels
        length(t) <= length(design) || continue
        startswith(design, t) || continue
        total += possible_arrangements!(cache, design[length(t)+1:end], towels)
    end
    return cache[design] = total
end


filename = "day19/input.txt"
# filename = "day19/test.txt"
day19p2(filename)
