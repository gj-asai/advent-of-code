function day02p1(filename)
    lines = split(readline(filename), [',', '-'])
    ranges = reshape(lines, 2, :)

    invalid = 0
    for (low, upp) in eachcol(ranges)
        n1, n2 = length.([low, upp])

        pattern1 = iseven(n1) ?
                   parse(Int, low[1:n1÷2]) :
                   10^((n1 - 1) ÷ 2)

        pattern2 = iseven(n2) ?
                   parse(Int, upp[1:n2÷2]) :
                   10^((n2 - 1) ÷ 2)

        low = parse(Int, low)
        upp = parse(Int, upp)
        for pattern in pattern1:pattern2
            id = "$pattern$pattern" |> x -> parse(Int, x)
            low <= id <= upp && (invalid += id)
        end
    end
    invalid
end

filename = "day02/input.txt"
# filename = "day02/test.txt"
day02p1(filename)
