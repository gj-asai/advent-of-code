filename = "day17/input.txt"
# filename = "day17/test.txt"

A, B, C = 0, 0, 0
program = Vector{Int}()
open(filename, "r") do f
    global A = match(r"\d+", readline(f)).match |> x -> parse(Int, x)
    global B = match(r"\d+", readline(f)).match |> x -> parse(Int, x)
    global C = match(r"\d+", readline(f)).match |> x -> parse(Int, x)
    readline(f)

    for m in eachmatch(r"\d+", readline(f))
        push!(program, parse(Int, m.match))
    end
end

function combo(operand)
    global A, B, C
    operand == 4 && return A
    operand == 5 && return B
    operand == 6 && return C
    return operand
end

function operate!(output, pointer, opcode, operand)
    global A, B, C
    if opcode == 0
        A ÷= 2^combo(operand)
    elseif opcode == 1
        B ⊻= operand
    elseif opcode == 2
        B = combo(operand) % 8
    elseif opcode == 3
        A != 0 && return operand
    elseif opcode == 4
        B ⊻= C
    elseif opcode == 5
        push!(output, combo(operand) % 8)
    elseif opcode == 6
        B = A ÷ 2^combo(operand)
    elseif opcode == 7
        C = A ÷ 2^combo(operand)
    end
    return pointer + 2
end

pointer = 0
output = Vector{Int}()
while pointer < length(program)
    global pointer = operate!(output, pointer, program[pointer+1], program[pointer+2])
end
join(output, ",") |> println
