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

cliques = Vector{Vector{String}}()
push!(cliques, [])
for pc in keys(connectivity), clique in cliques
    clique ⊆ connectivity[pc] || continue
    new_clique = copy(clique)
    push!(new_clique, pc)
    push!(cliques, new_clique)
end

largest = []
for clique in cliques
    length(clique) > length(largest) && (global largest = clique)
end
join(sort!(largest), ",") |> println
