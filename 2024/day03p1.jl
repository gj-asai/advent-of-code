function day03p1(filename)
    exp = r"mul\((\d{1,3}),(\d{1,3})\)"

    ans = 0
    for line in readlines(filename)
        for m in eachmatch(exp, line)
            n1 = parse(Int, m.captures[1])
            n2 = parse(Int, m.captures[2])
            ans += n1 * n2
        end
    end
    ans
end

filename = "day03/input.txt"
# filename = "day03/test.txt"
# filename = "day03/test2.txt"
day03p1(filename)
