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

total = 0
for secret in secrets
    for _ = 1:2000
        secret = evolve(secret)
    end
    global total += secret
end
total
