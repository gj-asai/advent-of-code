filename = "day21/input.txt"
# filename = "day21/test.txt"

codes = Vector{String}()
open(filename, "r") do f
    for line in eachline(f)
        push!(codes, line)
    end
end

struct NumKey end
struct DirKey end
function get_pos(key::Char, ::Type{NumKey})
    keypad = Dict('7' => (1, 4), '8' => (2, 4), '9' => (3, 4),
                  '4' => (1, 3), '5' => (2, 3), '6' => (3, 3),
                  '1' => (1, 2), '2' => (2, 2), '3' => (3, 2),
                                 '0' => (2, 1), 'A' => (3, 1))
    return keypad[key]
end
function get_pos(key::Char, ::Type{DirKey})
    keypad = Dict(               '^' => (2, 2), 'A' => (3, 2),
                  '<' => (1, 1), 'v' => (2, 1), '>' => (3, 1))
    return keypad[key]
end
gap_pos(::Type{NumKey}) = (1, 1)
gap_pos(::Type{DirKey}) = (1, 2)

function get_valid_sequences(key_start::Char, key_end::Char, ::Type{KeyType}) where {KeyType}
    pos_start, pos_end = get_pos(key_start, KeyType), get_pos(key_end, KeyType)
    delta = pos_end .- pos_start

    hor = delta[1] > 0 ? '>' :
          delta[1] < 0 ? '<' : ""
    ver = delta[2] > 0 ? '^' :
          delta[2] < 0 ? 'v' : ""

    gap = gap_pos(KeyType)
    sequences = Vector{String}()
    if !(pos_start[1] == gap[1] && pos_end[2] == gap[2]) # == is sufficient because gaps are at the border
        push!(sequences, ver^abs(delta[2]) * hor^(abs(delta[1])) * 'A')
    end
    if !(pos_start[2] == gap[2] && pos_end[1] == gap[1])
        push!(sequences, hor^abs(delta[1]) * ver^(abs(delta[2])) * 'A')
    end
    return sequences
end

known = Dict([])
function move(key_start::Char, key_end::Char, depth::Int=0)
    key_start == key_end && return 1 # press A
    depth > 25 && return 1 # manual control, press key_end directly
    (depth, key_start, key_end) in keys(known) && return known[(depth, key_start, key_end)]

    best_len = Inf
    key_type = depth == 0 ? NumKey : DirKey
    for seq in get_valid_sequences(key_start, key_end, key_type)
        len = 0
        for (cur, next) in zip('A' * seq, seq)
            len += move(cur, next, depth + 1)
        end
        best_len = min(best_len, len) |> Int
    end
    return known[(depth, key_start, key_end)] = best_len
end

function get_min_length(code)
    len = 0
    for (cur, next) in zip('A' * code, code)
        len += move(cur, next)
    end
    return len
end

total = 0
for code in codes
    global total += get_min_length(code) * parse(Int, code[1:end-1])
end
total
