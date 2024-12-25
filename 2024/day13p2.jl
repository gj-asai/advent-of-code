struct Machine
    a::Tuple{Int,Int}
    b::Tuple{Int,Int}
    prize::Tuple{Int,Int}
end

function day13p2(filename)
    lines = join(readlines(filename), "\n")

    machines = Vector{Machine}()
    for block in split(lines, "\n\n")
        line1, line2, line3 = split(block, "\n")
        ax, ay = match(r"Button A: X\+(\d+), Y\+(\d+)", line1).captures .|> x -> parse(Int, x)
        bx, by = match(r"Button B: X\+(\d+), Y\+(\d+)", line2).captures .|> x -> parse(Int, x)
        px, py = match(r"Prize: X=(\d+), Y=(\d+)", line3).captures .|> x -> parse(Int, x)
        push!(machines, Machine((ax, ay), (bx, by), (px, py)))
    end

    machines = [Machine(m.a, m.b, m.prize .+ (10000000000000, 10000000000000)) for m in machines]
    sum([min_tokens(m) for m in machines])
end

function min_tokens(m::Machine)
    # linear system has a unique solution
    det = m.a[1] * m.b[2] - m.a[2] * m.b[1]
    if det != 0
        na = (m.prize[1] * m.b[2] - m.b[1] * m.prize[2]) / det
        nb = (m.a[1] * m.prize[2] - m.prize[1] * m.a[2]) / det
        (!isinteger(na) || !isinteger(nb)) && return 0
        return 3 * na + nb |> Int
    end

    # zero solutions
    m.a[1] / m.a[2] == m.b[1] / m.b[2] == m.prize[1] / m.prize[2] || return 0

    # infinite solutions (not necessarily integer)
    # equations in X and Y are equivalent
    if m.a[1] >= 3 * m.b[1] # A is more economical than B, maximize na
        namax = m.prize[1] ÷ m.a[1]
        # namax - m.b[1] = namax (mod m.b[1])
        # if nb isnt integer for any na between namax-m.b[1] and namax, there arent any integer solutions
        for na = namax:-1:namax-m.b[1]
            nb = (m.prize[1] - na * m.a[1]) / m.b[1]
            isinteger(nb) && return 3 * na + nb |> Int
        end
        return 0
    else # B is more economical than A, maximize nb
        nbmax = m.prize[1] ÷ m.b[1]
        for nb = nbmax:-1:nbmax-m.a[1]
            na = (m.prize[1] - nb * m.b[1]) / m.a[1]
            isinteger(na) && return 3 * na + nb |> Int
        end
        return 0
    end
end

filename = "day13/input.txt"
# filename = "day13/test.txt"
day13p2(filename)
