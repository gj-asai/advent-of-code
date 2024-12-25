function day01p2(filename)
    list1 = Vector{Int}()
    list2 = Vector{Int}()
    for line in readlines(filename)
        n1, n2 = line |> split .|> x -> parse(Int, x)
        push!(list1, n1)
        push!(list2, n2)
    end

    similarity = 0
    for x in list1
        similarity += x * sum(list2 .== x)
    end
    similarity
end

filename = "day01/input.txt"
# filename = "day01/test.txt"
day01p2(filename)
