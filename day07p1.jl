filename = "day07/input.txt"
# filename = "day07/test.txt"

function is_possible(result::Int, numbers::Vector{Int}, partial::Int=0)
    length(numbers) == 0 && return partial == result
    result < partial && return false

    n1, nend = numbers[1], numbers[2:end]
    partial == 0 && return is_possible(result, nend, n1)

    is_possible(result, nend, partial + n1) && return true
    is_possible(result, nend, partial * n1) && return true
    return false
end

ans = 0
open(filename, "r") do f
    for line in eachline(f)
        result, numbers... = split(line, [':', ' '], keepempty=false) .|> x -> parse(Int, x)
        is_possible(result, numbers) && (global ans += result)
    end
end
ans
