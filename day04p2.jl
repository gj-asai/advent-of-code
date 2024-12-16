filename = "day04/input.txt"
# filename = "day04/test.txt"

open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

ne(pos) = pos .+ (-1, 1)
se(pos) = pos .+ (1, 1)
sw(pos) = pos .+ (1, -1)
nw(pos) = pos .+ (-1, -1)

read(pos) = get(matrix, pos, "")

function xmas(pos)
    read(pos) == 'A' || return false

    diag1 = [
        pos |> nw |> read,
        pos |> se |> read,
    ]
    Set(diag1) == Set("MS") || return false

    diag2 = [
        pos |> sw |> read,
        pos |> ne |> read,
    ]
    Set(diag2) == Set("MS") || return false

    return true
end

count = 0
for i in axes(matrix, 2), j in axes(matrix, 1)
    global count += xmas((i, j))
end
count
