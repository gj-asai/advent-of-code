filename = "day01/input.txt"
# filename = "day01/test.txt"

list1 = []
list2 = []
open(filename, "r") do f
    for line in eachline(f)
        n1, n2 = line |> split .|> x -> parse(Int64, x)
        push!(list1, n1)
        push!(list2, n2)
    end
end

similarity = 0
for x in list1
    global similarity += x * sum(list2 .== x)
end
similarity
