function day03p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...)) .|> x -> parse(Int, x)

    joltage = 0
    for bank in eachrow(matrix)
        tens, i = findmax(bank[1:end-1])
        ones = maximum(bank[i+1:end])
        joltage += 10 * tens + ones
    end
    joltage
end

filename = "day03/input.txt"
# filename = "day03/test.txt"
day03p1(filename)
