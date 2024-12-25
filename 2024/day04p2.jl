function day04p2(filename)
    matrix = map(collect, readlines(filename))
    matrix = permutedims(hcat(matrix...))

    ne(pos) = pos + CartesianIndex(-1, 1)
    se(pos) = pos + CartesianIndex(1, 1)
    sw(pos) = pos + CartesianIndex(1, -1)
    nw(pos) = pos + CartesianIndex(-1, -1)

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
    for pos in eachindex(IndexCartesian(), matrix)
        count += xmas(pos)
    end
    count
end

filename = "day04/input.txt"
# filename = "day04/test.txt"
day04p2(filename)
