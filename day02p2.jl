filename = "day02/input.txt"
# filename = "day02/test.txt"

reports = []
open(filename, "r") do f
    for line in eachline(f)
        levels = line |> split .|> x -> parse(Int64, x)
        push!(reports, levels)
    end
end

function is_safe(levels)
    diff = levels[2:end] - levels[1:end-1]
    (all(diff .> 0) || all(diff .< 0)) && all(abs.(diff) .<= 3)
end

function is_dampened_safe(levels)
    # i = 0 -> already safe
    # i = 1:length(levels) -> safe after removing 1
    for i in 0:length(levels)
        is_safe([levels[1:i-1]; levels[i+1:end]]) && return true
    end
    return false
end

reports .|> is_dampened_safe |> sum
