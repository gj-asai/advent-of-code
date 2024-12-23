filename = "day23/input.txt"
# filename = "day23/test.txt"

connectivity = Dict{String,Vector{String}}()
open(filename, "r") do f
    for line in eachline(f)
        pc1, pc2 = split(line, "-")
        pc1 in keys(connectivity) || (connectivity[pc1] = [])
        pc2 in keys(connectivity) || (connectivity[pc2] = [])
        push!(connectivity[pc1], pc2)
        push!(connectivity[pc2], pc1)
    end
end

loops = Vector{Vector{String}}()
push!(loops, [])
for pc in keys(connectivity), loop in loops
    loop ⊆ connectivity[pc] || continue
    new_loop = copy(loop)
    push!(new_loop, pc)
    push!(loops, new_loop)
end

largest = []
for loop in loops
    length(loop) > length(largest) && (global largest = loop)
end
join(sort!(largest), ",") |> println
