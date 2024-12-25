function day23p1(filename)
    connectivity = Dict{String,Vector{String}}()
    for line in readlines(filename)
        pc1, pc2 = split(line, "-")
        pc1 in keys(connectivity) || (connectivity[pc1] = [])
        pc2 in keys(connectivity) || (connectivity[pc2] = [])
        push!(connectivity[pc1], pc2)
        push!(connectivity[pc2], pc1)
    end

    total = 0
    for pc1 in keys(connectivity), pc2 in connectivity[pc1], pc3 in connectivity[pc2]
        pc3 in connectivity[pc1] || continue
        !startswith(pc1, "t") && !startswith(pc2, "t") && !startswith(pc3, "t") && continue
        total += 1
    end
    total ÷= 6 # permutations of (pc1, pc2, pc3)
end

filename = "day23/input.txt"
# filename = "day23/test.txt"
day23p1(filename)
