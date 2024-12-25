function day04p1(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    n(pos) = pos + CartesianIndex(-1, 0)
    ne(pos) = pos + CartesianIndex(-1, 1)
    e(pos) = pos + CartesianIndex(0, 1)
    se(pos) = pos + CartesianIndex(1, 1)
    s(pos) = pos + CartesianIndex(1, 0)
    sw(pos) = pos + CartesianIndex(1, -1)
    w(pos) = pos + CartesianIndex(0, -1)
    nw(pos) = pos + CartesianIndex(-1, -1)

    read(pos) = get(matrix, pos, "")
    word(pos, direction) = pos |> read == 'X' &&
                           pos |> direction |> read == 'M' &&
                           pos |> direction |> direction |> read == 'A' &&
                           pos |> direction |> direction |> direction |> read == 'S'
    valid(pos) = word(pos, nw) + word(pos, n) + word(pos, ne) +
                 word(pos, w) + word(pos, e) +
                 word(pos, sw) + word(pos, s) + word(pos, se)

    count = 0
    for pos in eachindex(IndexCartesian(), matrix)
        count += valid(pos)
    end
    count
end


filename = "day04/input.txt"
# filename = "day04/test.txt"
day04p1(filename)
