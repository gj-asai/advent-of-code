function day03p2(filename)
    exp = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

    ans = 0
    enabled = true
    for line in readlines(filename)
        for m in eachmatch(exp, line)
            if m.match == "do()"
                enabled = true
            elseif m.match == "don't()"
                enabled = false
            elseif enabled
                n1 = parse(Int, m.captures[1])
                n2 = parse(Int, m.captures[2])
                ans += n1 * n2
            end
        end
    end
    ans
end

filename = "day03/input.txt"
# filename = "day03/test.txt"
# filename = "day03/test2.txt"
day03p2(filename)
