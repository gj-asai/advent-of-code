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

reports .|> is_safe |> sum
