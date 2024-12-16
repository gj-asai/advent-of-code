filename = "day03/input.txt"
# filename = "day03/test.txt"
# filename = "day03/test2.txt"

exp = r"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

ans = 0
enabled = true
open(filename, "r") do f
    for line in eachline(f)
        for m in eachmatch(exp, line)
            if m.match == "do()"
                global enabled = true
            elseif m.match == "don't()"
                global enabled = false
            elseif enabled
                n1 = parse(Int, m.captures[1])
                n2 = parse(Int, m.captures[2])
                global ans += n1 * n2
            end
        end
    end
end
ans
