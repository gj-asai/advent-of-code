function day22p1(filename)
    secrets = Vector{Int}()
    for line in readlines(filename)
        push!(secrets, parse(Int, line))
    end

    total = 0
    for secret in secrets
        for _ = 1:2000
            secret = evolve(secret)
        end
        total += secret
    end
    total
end

mix(secret::Int, value::Int) = secret ⊻ value
prune(secret::Int) = secret % 16777216
function evolve(secret::Int)
    secret = mix(secret, 64 * secret) |> prune
    secret = mix(secret, secret ÷ 32) |> prune
    secret = mix(secret, 2048 * secret) |> prune
end

filename = "day22/input.txt"
# filename = "day22/test.txt"
day22p1(filename)
