function day01p2(filename)
    list = Vector{Int}()

    for line in readlines(filename)
        n = parse(Int, line[2:end])
        line[1] == 'L' && (n *= -1)
        push!(list, n)
    end

    dial = 50
    password = 0
    for n in list
        password += abs(n ÷ 100)

        new_dial = dial + n % 100
        dial == 0 || 0 < new_dial < 100 || (password += 1)
        dial = mod(new_dial, 100)
    end
    password
end

filename = "day01/input.txt"
# filename = "day01/test.txt"
day01p2(filename)
