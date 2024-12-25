function day19p1(filename)
    lines = join(readlines(filename), "\n")
    towels_in, designs_in = split(lines, "\n\n")

    towels = split(towels_in, ", ")

    designs = Vector{String}()
    for line in split(designs_in, "\n")
        push!(designs, line)
    end

    sum([is_possible(d, towels) for d in designs])
end

function is_possible(design, towels)
    length(design) == 0 && return true
    for t in towels
        length(t) <= length(design) || continue
        startswith(design, t) || continue
        is_possible(design[length(t)+1:end], towels) || continue
        return true
    end
    return false
end


filename = "day19/input.txt"
# filename = "day19/test.txt"
day19p1(filename)
