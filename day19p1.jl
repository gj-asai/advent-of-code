filename = "day19/input.txt"
# filename = "day19/test.txt"

towels = ""
designs = Vector{String}()
open(filename, "r") do f
    global towels = split(readline(f), ", ")
    readline(f)

    while !eof(f)
        push!(designs, readline(f))
    end
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

[is_possible(d, towels) for d in designs] |> sum
