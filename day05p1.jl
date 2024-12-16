filename = "day05/input.txt"
# filename = "day05/test.txt"

struct Rule
    first::Int64
    second::Int64
end

rules = Rule[]
updates = Vector{Int64}[]

open(filename, "r") do f
    while !eof(f)
        line = readline(f)
        isempty(line) && break # no more rules
        push!(rules,
            Rule([parse(Int64, n) for n in split(line, "|")]...)
        )
    end

    while !eof(f)
        line = readline(f)
        push!(updates,
            [parse(Int64, n) for n in split(line, ",")]
        )
    end
end

function check(update, rules)
    for rule in rules
        rule.first in update || continue
        rule.second in update || continue
        findfirst(update .== rule.first) < findfirst(update .== rule.second) || return false
    end
    return true
end

count = 0
for update in updates
    check(update, rules) || continue
    global count += update[end÷2+1]
end
count
