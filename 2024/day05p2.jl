struct Rule
    first::Int
    second::Int
end

function day05p2(filename)
    lines = join(readlines(filename), "\n")
    rules_in, updates_in = split(lines, "\n\n")

    rules = Vector{Rule}()
    for line in split(rules_in, "\n")
        push!(rules, Rule([parse(Int, n) for n in split(line, "|")]...))
    end

    updates = Vector{Vector{Int}}()
    for line in split(updates_in, "\n")
        push!(updates, [parse(Int, n) for n in split(line, ",")])
    end

    count = 0
    for update in updates
        check(update, rules) && continue

        correct = Vector{Int}()
        for page in update
            idx = 1
            for p in get_prioritary(page, rules)
                p in correct || continue
                idx = max(findfirst(correct .== p) + 1, idx)
            end
            insert!(correct, idx, page)
        end

        count += correct[end÷2+1]
    end
    count
end

function check(update::Vector{Int}, rules::Vector{Rule})
    for rule in rules
        rule.first in update || continue
        rule.second in update || continue
        findfirst(update .== rule.first) < findfirst(update .== rule.second) || return false
    end
    return true
end

# numbers that have to appear before page
function get_prioritary(page::Int, rules::Vector{Rule})
    prioritary = Vector{Int}()
    for rule in rules
        rule.second == page && push!(prioritary, rule.first)
    end
    prioritary
end

filename = "day05/input.txt"
# filename = "day05/test.txt"
day05p2(filename)
