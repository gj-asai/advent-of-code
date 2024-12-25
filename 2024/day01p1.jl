function day01p1(filename)
    list1 = Vector{Int}()
    list2 = Vector{Int}()

    for line in readlines(filename)
        n1, n2 = line |> split .|> x -> parse(Int, x)
        push!(list1, n1)
        push!(list2, n2)
    end

    sort!(list1)
    sort!(list2)
    sum(abs.(list1 - list2))
end

filename = "day01/input.txt"
# filename = "day01/test.txt"
day01p1(filename)
