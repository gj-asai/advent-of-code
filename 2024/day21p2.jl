struct NumKey end
struct DirKey end

function day21p2(filename)
    codes = readlines(filename)

    total = 0
    cache = Dict{Tuple{Int,Char,Char},Int}()
    for code in codes
        total += get_min_length!(cache, code) * parse(Int, code[1:end-1])
    end
    total
end

function get_pos(key::Char, ::Type{NumKey})
    keypad = Dict('7' => (1, 4), '8' => (2, 4), '9' => (3, 4),
                  '4' => (1, 3), '5' => (2, 3), '6' => (3, 3),
                  '1' => (1, 2), '2' => (2, 2), '3' => (3, 2),
                  ' ' => (1, 1), '0' => (2, 1), 'A' => (3, 1))
    return keypad[key]
end
function get_pos(key::Char, ::Type{DirKey})
    keypad = Dict(' ' => (1, 2), '^' => (2, 2), 'A' => (3, 2),
                  '<' => (1, 1), 'v' => (2, 1), '>' => (3, 1))
    return keypad[key]
end

function get_valid_sequences(key_start::Char, key_end::Char, ::Type{KeyType}) where {KeyType}
    pos_start, pos_end = get_pos(key_start, KeyType), get_pos(key_end, KeyType)
    delta = pos_end .- pos_start

    hor = delta[1] > 0 ? '>' :
          delta[1] < 0 ? '<' : ""
    ver = delta[2] > 0 ? '^' :
          delta[2] < 0 ? 'v' : ""

    gap = get_pos(' ', KeyType)
    sequences = Vector{String}()
    if !(pos_start[1] == gap[1] && pos_end[2] == gap[2]) # == is sufficient because gaps are at the border
        push!(sequences, ver^abs(delta[2]) * hor^(abs(delta[1])) * 'A')
    end
    if !(pos_start[2] == gap[2] && pos_end[1] == gap[1])
        push!(sequences, hor^abs(delta[1]) * ver^(abs(delta[2])) * 'A')
    end
    return sequences
end

function move!(cache, key_start::Char, key_end::Char, depth::Int=0)
    key_start == key_end && return 1 # press A
    depth > 25 && return 1 # manual control, press key_end directly
    (depth, key_start, key_end) in keys(cache) && return cache[(depth, key_start, key_end)]

    best_len = Inf
    key_type = depth == 0 ? NumKey : DirKey
    for seq in get_valid_sequences(key_start, key_end, key_type)
        len = 0
        for (cur, next) in zip('A' * seq, seq)
            len += move!(cache, cur, next, depth + 1)
        end
        best_len = min(best_len, len) |> Int
    end
    return cache[(depth, key_start, key_end)] = best_len
end

function get_min_length!(cache, code)
    len = 0
    for (cur, next) in zip('A' * code, code)
        len += move!(cache, cur, next)
    end
    return len
end

filename = "day21/input.txt"
# filename = "day21/test.txt"
day21p2(filename)
