filename = "day11/input.txt"
# filename = "day11/test.txt"

stones = Vector{Int}()
open(filename, "r") do f
    global stones = readline(f) |> split .|> x -> parse(Int, x)
end

function blink(stone, times)
    global results, NUM_BLINKS
    !haskey(results, stone) && (results[stone] = fill(0, NUM_BLINKS))

    times == 0 && return 1

    results[stone][times] != 0 && return results[stone][times]

    if stone == 0
        results[stone][1] = 1
        times == 1 && return results[stone][times]
        blink(1, times - 1)
        results[stone][2:times] = results[1][1:times-1]
    else
        n = ndigits(stone)
        if iseven(n)
            divide = 10^(n ÷ 2)
            n1 = stone ÷ divide
            n2 = stone % divide
            results[stone][1] = 2
            times == 1 && return results[stone][times]
            blink(n1, times - 1)
            blink(n2, times - 1)
            results[stone][2:times] = results[n1][1:times-1] + results[n2][1:times-1]
        else
            results[stone][1] = 1
            times == 1 && return results[stone][times]
            blink(2024 * stone, times - 1)
            results[stone][2:times] = results[2024*stone][1:times-1]
        end
    end

    return results[stone][times]
end

NUM_BLINKS = 25
results = Dict()
total = 0
for stone in stones
    global total += blink(stone, NUM_BLINKS)
end
total
