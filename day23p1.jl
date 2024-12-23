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

total = 0
for pc1 in keys(connectivity), pc2 in connectivity[pc1], pc3 in connectivity[pc2]
    pc3 in connectivity[pc1] || continue
    !startswith(pc1, "t") && !startswith(pc2, "t") && !startswith(pc3, "t") && continue
    global total += 1
end
total ÷= 6 # permutations of (pc1, pc2, pc3)
