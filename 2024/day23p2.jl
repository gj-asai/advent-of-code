function day23p2(filename)
    connectivity = Dict{String,Vector{String}}()
    for line in readlines(filename)
        pc1, pc2 = split(line, "-")
        pc1 in keys(connectivity) || (connectivity[pc1] = [])
        pc2 in keys(connectivity) || (connectivity[pc2] = [])
        push!(connectivity[pc1], pc2)
        push!(connectivity[pc2], pc1)
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
        length(clique) > length(largest) && (largest = clique)
    end
    join(sort!(largest), ",")
end

filename = "day23/input.txt"
# filename = "day23/test.txt"
day23p2(filename)
