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

known = Dict([])
function possible_arrangements(design, towels)
    length(design) == 0 && return 1
    design in keys(known) && return known[design]

    total = 0
    for t in towels
        length(t) <= length(design) || continue
        startswith(design, t) || continue
        total += possible_arrangements(design[length(t)+1:end], towels)
    end
    return known[design] = total
end

[possible_arrangements(d, towels) for d in designs] |> sum
