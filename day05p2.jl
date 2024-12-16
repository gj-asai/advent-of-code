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

# PART 1
function check(update, rules)
    for rule in rules
        rule.first in update || continue
        rule.second in update || continue
        findfirst(update .== rule.first) < findfirst(update .== rule.second) || return false
    end
    return true
end

# numbers that have to appear before page
function get_prioritary(page, rules)
    prioritary = []
    for rule in rules
        rule.second == page && push!(prioritary, rule.first)
    end
    prioritary
end

count = 0
for update in updates
    check(update, rules) && continue

    correct = []
    for page in update
        idx = 1
        for p in get_prioritary(page, rules)
            p in correct || continue
            idx = max(findfirst(correct .== p) + 1, idx)
        end
        insert!(correct, idx, page)
    end
    
    global count += correct[end÷2+1]
end
count
