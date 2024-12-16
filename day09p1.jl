filename = "day09/input.txt"
# filename = "day09/test.txt"

diskmap = Vector{Char}()
open(filename, "r") do f
    global diskmap = readline(f) |> collect .|> x -> parse(Int64, x)
end

struct Block
    id::Int64
    len::Int64
end

blocks = Vector{Block}()
id = 0
free = false
for len in diskmap
    global id, free
    if free
        push!(blocks, Block(-1, len))
    else
        push!(blocks, Block(id, len))
        id += 1
    end
    free = !free
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

pos1 = 1
pos2 = length(blocks)
while pos1 < pos2
    if !checkbounds(Bool, blocks, pos1) || blocks[pos1].id != -1
        global pos1 += 1
        continue
    end
    if !checkbounds(Bool, blocks, pos2) || blocks[pos2].id == -1
        global pos2 -= 1
        continue
    end
    swap!(blocks, pos1, pos2)
end

checksum = 0
pos = 0
for block in blocks
    for _ = 1:block.len
        global checksum, pos
        block.id != -1 && (checksum += block.id * pos)
        pos += 1
    end
end
checksum
