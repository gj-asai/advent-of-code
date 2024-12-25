function day11p2(filename)
    stones = readline(filename) |> split .|> x -> parse(Int, x)
    num_blinks = 75

    total = 0
    cache = Dict{Int, Vector{Int}}()
    for stone in stones
        total += blink!(cache, stone, num_blinks, num_blinks)
    end
    total
end

function blink!(cache::Dict{Int, Vector{Int}}, stone::Int, times::Int, total_blinks::Int)
    !haskey(cache, stone) && (cache[stone] = fill(0, total_blinks))

    times == 0 && return 1
    cache[stone][times] != 0 && return cache[stone][times]

    if stone == 0
        cache[stone][1] = 1
        times == 1 && return cache[stone][times]
        blink!(cache, 1, times - 1, total_blinks)
        cache[stone][2:times] = cache[1][1:times-1]
    else
        n = ndigits(stone)
        if iseven(n)
            divide = 10^(n ÷ 2)
            n1 = stone ÷ divide
            n2 = stone % divide
            cache[stone][1] = 2
            times == 1 && return cache[stone][times]
            blink!(cache, n1, times - 1, total_blinks)
            blink!(cache, n2, times - 1, total_blinks)
            cache[stone][2:times] = cache[n1][1:times-1] + cache[n2][1:times-1]
        else
            cache[stone][1] = 1
            times == 1 && return cache[stone][times]
            blink!(cache, 2024 * stone, times - 1, total_blinks)
            cache[stone][2:times] = cache[2024*stone][1:times-1]
        end
    end

    return cache[stone][times]
end

filename = "day11/input.txt"
# filename = "day11/test.txt"
day11p2(filename)
