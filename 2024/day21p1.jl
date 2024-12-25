struct NumKey end
struct DirKey end

function day21p1(filename)
    codes = readlines(filename)
    len = length.(get_full_sequence.(codes))
    num = get_numeric_part.(codes)
    sum(len .* num)
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

# KeyType: type of the target keypad
function move(key_start::Char, key_end::Char, ::Type{KeyType}) where {KeyType}
    pos_start, pos_end = get_pos(key_start, KeyType), get_pos(key_end, KeyType)
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

filename = "day21/input.txt"
# filename = "day21/test.txt"
day21p1(filename)
