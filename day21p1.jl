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

# KeyType: type of the target keypad
function move(key_start::Char, key_end::Char, ::Type{KeyType}) where {KeyType}
    key_start, key_end = KeyType(key_start), KeyType(key_end)
    pos_start, pos_end = get_pos(key_start), get_pos(key_end)
    delta = pos_end .- pos_start

    hor = delta[1] > 0 ? '>' :
          delta[1] < 0 ? '<' : ""
    ver = delta[2] > 0 ? '^' :
          delta[2] < 0 ? 'v' : ""

    # this is wrong, check solution for part 2
    if (KeyType == NumKey && pos_start[2] == 1 && pos_end[1] == 1) ||
       (KeyType == DirKey && pos_start[2] == 2 && pos_end[1] == 1)
        return ver^abs(delta[2]) * hor^(abs(delta[1])) * 'A'
    end
    return hor^abs(delta[1]) * ver^(abs(delta[2])) * 'A'
end

function get_full_sequence(code)
    # first robot
    dir1 = ""
    for (cur, next) in zip('A' * code, code)
        dir1 *= move(cur, next, NumKey)
    end

    # second robot
    dir2 = ""
    for (cur, next) in zip('A' * dir1, dir1)
        dir2 *= move(cur, next, DirKey)
    end

    # manual
    dir3 = ""
    for (cur, next) in zip('A' * dir2, dir2)
        dir3 *= move(cur, next, DirKey)
    end

    return dir3
end

function get_numeric_part(code)
    parse(Int, code[1:end-1])
end

len = codes .|> get_full_sequence .|> length
num = codes .|> get_numeric_part
complexities = sum(len .* num)
