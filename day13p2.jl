filename = "day13/input.txt"
# filename = "day13/test.txt"

struct Machine
    a::Tuple{Int64,Int64}
    b::Tuple{Int64,Int64}
    prize::Tuple{Int64,Int64}
end

machines = Machine[]
open(filename, "r") do f
    while !eof(f)
        ax, ay = match(r"Button A: X\+(\d+), Y\+(\d+)", readline(f)).captures .|> x -> parse(Int64, x)
        bx, by = match(r"Button B: X\+(\d+), Y\+(\d+)", readline(f)).captures .|> x -> parse(Int64, x)
        px, py = match(r"Prize: X=(\d+), Y=(\d+)", readline(f)).captures .|> x -> parse(Int64, x)
        readline(f)
        push!(machines, Machine((ax, ay), (bx, by), (px, py)))
    end
end

function min_tokens(m::Machine)
    det = m.a[1] * m.b[2] - m.a[2] * m.b[1]
    if det != 0
        na = (m.prize[1] * m.b[2] - m.b[1] * m.prize[2]) / det
        nb = (m.a[1] * m.prize[2] - m.prize[1] * m.a[2]) / det
        (!isinteger(na) || !isinteger(nb)) && return 0
        return 3 * na + nb |> Int
    end
    return 0
end

machines = [Machine(m.a, m.b, m.prize .+ (10000000000000, 10000000000000)) for m in machines]
cost = [min_tokens(m) for m in machines] |> sum
