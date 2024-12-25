struct Block
    id::Int64
    len::Int64
end

function day09p1(filename)
    diskmap = readline(filename) |> collect .|> x -> parse(Int, x)

    id = 0
    free = false
    blocks = Vector{Block}()
    for len in diskmap
        if free
            push!(blocks, Block(-1, len))
        else
            push!(blocks, Block(id, len))
            id += 1
        end
        free = !free
    end

    pos1 = 1
    pos2 = length(blocks)
    while pos1 < pos2
        if !checkbounds(Bool, blocks, pos1) || blocks[pos1].id != -1
            pos1 += 1
            continue
        end
        if !checkbounds(Bool, blocks, pos2) || blocks[pos2].id == -1
            pos2 -= 1
            continue
        end
        swap!(blocks, pos1, pos2)
    end

    checksum = 0
    pos = 0
    for block in blocks
        for _ = 1:block.len
            block.id != -1 && (checksum += block.id * pos)
            pos += 1
        end
    end
    checksum
end

function swap!(blocks, pos1, pos2)
    block1, block2 = blocks[pos1], blocks[pos2]

    if block1.len == block2.len
        blocks[pos1] = block2
        blocks[pos2] = block1
    elseif block1.len > block2.len
        blocks[pos1] = Block(block1.id, block1.len - block2.len)
        blocks[pos2] = Block(block1.id, block2.len)
        insert!(blocks, pos1, block2)
    elseif block1.len < block2.len
        blocks[pos1] = Block(block2.id, block1.len)
        blocks[pos2] = Block(block2.id, block2.len - block1.len)
        insert!(blocks, pos2 + 1, block1)
    end
end

filename = "day09/input.txt"
# filename = "day09/test.txt"
day09p1(filename)
