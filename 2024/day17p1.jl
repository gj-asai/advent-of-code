mutable struct RegisterState
    A::Int
    B::Int
    C::Int
end

function day17p1(filename)
    lineA, lineB, lineC, _, line_prog = readlines(filename)
    A = match(r"\d+", lineA).match |> x -> parse(Int, x)
    B = match(r"\d+", lineB).match |> x -> parse(Int, x)
    C = match(r"\d+", lineC).match |> x -> parse(Int, x)
    state = RegisterState(A, B, C)

    program = Vector{Int}()
    for m in eachmatch(r"\d+", line_prog)
        push!(program, parse(Int, m.match))
    end

    pointer = 0
    output = Vector{Int}()
    while pointer < length(program)
        pointer = operate!!(state, output, pointer, program[pointer+1], program[pointer+2])
    end
    join(output, ",")
end

function combo(operand, state::RegisterState)
    operand == 4 && return state.A
    operand == 5 && return state.B
    operand == 6 && return state.C
    return operand
end

function operate!!(state, output, pointer, opcode, operand)
    if opcode == 0
        state.A ÷= 2^combo(operand, state)
    elseif opcode == 1
        state.B ⊻= operand
    elseif opcode == 2
        state.B = combo(operand, state) % 8
    elseif opcode == 3
        state.A != 0 && return operand
    elseif opcode == 4
        state.B ⊻= state.C
    elseif opcode == 5
        push!(output, combo(operand, state) % 8)
    elseif opcode == 6
        state.B = state.A ÷ 2^combo(operand, state)
    elseif opcode == 7
        state.C = state.A ÷ 2^combo(operand, state)
    end
    return pointer + 2
end

filename = "day17/input.txt"
# filename = "day17/test.txt"
day17p1(filename)
