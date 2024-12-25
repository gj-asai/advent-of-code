function day02p2(filename)
    reports = Vector{Vector{Int}}()
    for line in readlines(filename)
        levels = line |> split .|> x -> parse(Int, x)
        push!(reports, levels)
    end
    sum(is_safe_dampened.(reports))
end

function is_safe(levels::Vector{Int})
    diff = levels[2:end] - levels[1:end-1]
    (all(diff .> 0) || all(diff .< 0)) && all(abs.(diff) .<= 3)
end

function is_safe_dampened(levels::Vector{Int})
    # i = 0 -> already safe
    # i = 1:length(levels) -> safe after removing one at position i
    for i in 0:length(levels)
        is_safe([levels[1:i-1]; levels[i+1:end]]) && return true
    end
    return false
end

filename = "day02/input.txt"
# filename = "day02/test.txt"
day02p2(filename)
