function day01p1(filename)
    list = Vector{Int}()

    for line in readlines(filename)
        n = parse(Int, line[2:end])
        line[1] == 'L' && (n *= -1)
        push!(list, n)
    end

    dial = 50
    password = 0
    for n in list
        dial = (dial + n) % 100
        dial == 0 && (password += 1)
    end
    password
end

filename = "day01/input.txt"
# filename = "day01/test.txt"
day01p1(filename)
