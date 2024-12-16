filename = "day03/input.txt"
# filename = "day03/test.txt"
# filename = "day03/test2.txt"

exp = r"mul\((\d{1,3}),(\d{1,3})\)"

ans = 0
open(filename, "r") do f
    for line in eachline(f)
        for m in eachmatch(exp, line)
            n1 = parse(Int64, m.captures[1])
            n2 = parse(Int64, m.captures[2])
            global ans += n1 * n2
        end
    end
end
ans
