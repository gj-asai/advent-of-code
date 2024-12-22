filename = "day22/input.txt"
# filename = "day22/test.txt"

secrets = Vector{Int}()
open(filename, "r") do f
    for line in eachline(f)
        push!(secrets, parse(Int, line))
    end
end

mix(secret::Int, value::Int) = secret ⊻ value
prune(secret::Int) = secret % 16777216
function evolve(secret::Int)
    secret = mix(secret, 64 * secret) |> prune
    secret = mix(secret, secret ÷ 32) |> prune
    secret = mix(secret, 2048 * secret) |> prune
end

function price_sequence(secret::Int, n::Int)
    seq = [secret % 10]
    for _ = 1:n
        secret = evolve(secret)
        push!(seq, secret % 10)
    end
    seq
end

function possible_bananas(secret::Int)
    possible = Dict([])
    seq = price_sequence(secret, 2000)
    diff = seq[2:end] - seq[1:end-1]
    for (d1, d2, d3, d4, p) in zip(diff, diff[2:end], diff[3:end], diff[4:end], seq[5:end])
        target = (d1, d2, d3, d4)
        target in keys(possible) && continue
        possible[target] = p
    end
    return possible
end

possible = Dict([])
for secret in secrets
    merge!(+, possible, possible_bananas(secret))
end
max(values(possible)...)
