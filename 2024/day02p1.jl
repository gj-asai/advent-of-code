function day02p1(filename)
    reports = Vector{Vector{Int}}()
    for line in readlines(filename)
        levels = line |> split .|> x -> parse(Int, x)
        push!(reports, levels)
    end
    sum(is_safe.(reports))
end

function is_safe(levels::Vector{Int})
    diff = levels[2:end] - levels[1:end-1]
    (all(diff .> 0) || all(diff .< 0)) && all(abs.(diff) .<= 3)
end

filename = "day02/input.txt"
# filename = "day02/test.txt"
day02p1(filename)
