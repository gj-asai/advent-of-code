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

sort!(list1)
sort!(list2)
list1 - list2 .|> abs |> sum
