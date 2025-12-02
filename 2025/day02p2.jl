function day02p2(filename)
    lines = split(readline(filename), [',', '-'])
    ranges = reshape(lines, 2, :)

    invalid = Set{Int}([])
    for (low, upp) in eachcol(ranges)
        n1, n2 = length.([low, upp])
        low_int = parse(Int, low)
        upp_int = parse(Int, upp)

        times = 2
        while times <= n1 + 1
            pattern1 = n1 % times == 0 ?
                       parse(Int, low[1:n1÷times]) :
                       10^(n1 ÷ times)

            pattern2 = n2 % times == 0 ?
                       parse(Int, upp[1:n2÷times]) :
                       10^(n2 ÷ times)

            for pattern in pattern1:pattern2
                id = repeat(string(pattern), times) |> x -> parse(Int, x)
                low_int <= id <= upp_int && push!(invalid, id)
            end

            times += 1
        end
    end
    sum(invalid)
end

filename = "day02/input.txt"
# filename = "day02/test.txt"
day02p2(filename)
