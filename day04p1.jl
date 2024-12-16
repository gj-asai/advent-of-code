filename = "day04/input.txt"
# filename = "day04/test.txt"

open(filename, "r") do f
    global matrix = map(collect, readlines(f))
    matrix = permutedims(hcat(matrix...))
end

n(pos) = pos .+ (-1, 0)
ne(pos) = pos .+ (-1, 1)
e(pos) = pos .+ (0, 1)
se(pos) = pos .+ (1, 1)
s(pos) = pos .+ (1, 0)
sw(pos) = pos .+ (1, -1)
w(pos) = pos .+ (0, -1)
nw(pos) = pos .+ (-1, -1)

read(pos) = get(matrix, pos, "")
word(pos, direction) = pos |> read == 'X' &&
                       pos |> direction |> read == 'M' &&
                       pos |> direction |> direction |> read == 'A' &&
                       pos |> direction |> direction |> direction |> read == 'S'
valid(pos) = word(pos, nw) + word(pos, n) + word(pos, ne) +
             word(pos, w) + word(pos, e) +
             word(pos, sw) + word(pos, s) + word(pos, se)

count = 0
for i in axes(matrix, 2), j in axes(matrix, 1)
    global count += valid((i, j))
end
count
