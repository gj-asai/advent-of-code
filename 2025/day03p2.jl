function day03p2(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...)) .|> x -> parse(Int, x)

    joltage = 0
    for bank in eachrow(matrix)
        i = 0
        for exponent in 11:-1:0
            value, move = findmax(bank[i+1:end-exponent])
            i += move
            joltage += 10^exponent * value
        end
    end
    joltage
end

filename = "day03/input.txt"
# filename = "day03/test.txt"
day03p2(filename)
