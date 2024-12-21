filename = "day21/input.txt"
# filename = "day21/test.txt"

codes = Vector{String}()
open(filename, "r") do f
    for line in eachline(f)
        push!(codes, line)
    end
end

struct NumKey
    key::Char
end
struct DirKey
    key::Char
end

function get_pos(k::NumKey)
    k.key == '0' && return (2, 1)
    k.key == 'A' && return (3, 1)
    k.key == '1' && return (1, 2)
    k.key == '2' && return (2, 2)
    k.key == '3' && return (3, 2)
    k.key == '4' && return (1, 3)
    k.key == '5' && return (2, 3)
    k.key == '6' && return (3, 3)
    k.key == '7' && return (1, 4)
    k.key == '8' && return (2, 4)
    k.key == '9' && return (3, 4)
end
function get_pos(k::DirKey)
    k.key == '<' && return (1, 1)
    k.key == 'v' && return (2, 1)
    k.key == '>' && return (3, 1)
    k.key == '^' && return (2, 2)
    k.key == 'A' && return (3, 2)
end
gap_pos(::Type{NumKey}) = (1, 1)
gap_pos(::Type{DirKey}) = (1, 2)

# KeyType: type of keypad - NumKey or DirKey
function get_valid_sequences(key_start::Char, key_end::Char, ::Type{KeyType}) where {KeyType}
    key_start, key_end = KeyType(key_start), KeyType(key_end)
    pos_start, pos_end = get_pos(key_start), get_pos(key_end)
    delta = pos_end .- pos_start

    hor = delta[1] > 0 ? '>' : '<'
    ver = delta[2] > 0 ? '^' : 'v'

    delta[1] == 0 && return [ver^abs(delta[2]) * 'A']
    delta[2] == 0 && return [hor^abs(delta[1]) * 'A']

    sequences = Vector{String}()
    seq_len = sum(abs.(delta))
    for i = 0:2^seq_len-1
        # use binary numbers with seq_len digits to get all possible orders
        # 1: hor, 0: ver
        order = digits(i, base=2)
        sum(order) == abs(delta[1]) || continue # wrong number of each type of move

        # keep track of all positions in the sequence to check if passes over gap
        cur_pos = pos_start
        invalid = false

        seq = fill(ver, seq_len)
        for (j, d) in pairs(order)
            if d == 1
                seq[j] = hor
                cur_pos = cur_pos .+ (delta[1], 0)
            else
                seq[j] = ver
                cur_pos = cur_pos .+ (0, delta[2])
            end
            invalid |= cur_pos == gap_pos(KeyType)
        end

        invalid && continue
        seq = String(seq) * 'A'
        push!(sequences, seq)
    end
    return sequences
end

known = Dict([])
function move(key_start::Char, key_end::Char, ndeep::Int=0)
    key_start == key_end && return 1 # press A
    ndeep > 25 && return 1 # manual control, press key_end directly
    (ndeep, key_start, key_end) in keys(known) && return known[(ndeep, key_start, key_end)]

    key_type = ndeep == 0 ? NumKey : DirKey

    best_len = Inf
    for seq in get_valid_sequences(key_start, key_end, key_type)
        len = 0
        for (cur, next) in zip('A' * seq, seq)
            len += move(cur, next, ndeep + 1)
        end
        best_len = min(best_len, len) |> Int
    end
    return known[(ndeep, key_start, key_end)] = best_len
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
