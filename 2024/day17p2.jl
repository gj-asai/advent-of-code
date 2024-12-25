mutable struct RegisterState
    A::Int
    B::Int
    C::Int
end

function day17p2(filename)
    line_prog = readlines(filename)[end]

    program = Vector{Int}()
    for m in eachmatch(r"\d+", line_prog)
        push!(program, parse(Int, m.match))
    end

    # find first A with correct length
    target_length = length(program)
    lower = 0
    step = 100000000000000
    while step > 0
        test = lower + step
        testlen = length(get_full_output(test, program))
        if testlen >= target_length
            step ÷= 2
        elseif testlen < target_length
            lower += step
        end
    end
    lower += 1

    # find last A with correct length
    target_length = length(program)
    upper = 10000000000000000
    step = 10000000000000000
    while step > 0
        test = upper - step
        testlen = length(get_full_output(test, program))
        if testlen <= target_length
            step ÷= 2
        elseif testlen > target_length
            upper -= step
        end
    end
    upper -= 1

    # narrowing bounds by matching last values in the output
    for i = 1:length(program)
        possible = possible_values(lower, upper, i, program)
        # possible for k=6 contains two 0s, using findfirst does not find the solution in the end
        target = findlast(possible .== program[end-i+1])

        step = upper - lower
        possible1 = copy(possible)
        while step > 0
            test = lower + step
            output = get_full_output(test, program)
            pos = findlast(possible1 .== output[end-i+1])
            possible1 = possible1[1:pos]
            if pos >= target
                step *= 0.9
                step = step |> floor |> Int
            elseif pos < target
                lower += step
                step = upper - lower
                possible1 = copy(possible)
            end
        end
        lower += 1

        step = upper - lower
        # not using the equivalent of possible1 ?
        while step > 0
            test = upper - step
            output = get_full_output(test, program)
            pos = findfirst(possible .== output[end-i+1])
            if pos <= target
                step *= 0.9
                step = step |> floor |> Int
            elseif pos > target
                upper -= step
                step = upper - lower
            end
        end
        upper -= 1

        upper - lower < 10^8 && break
    end

    # bounds are close enough to check everything
    output = Vector{Int}()
    for search = lower:upper
        state = RegisterState(search, 0, 0)
        empty!(output)

        pointer = 0
        while pointer < length(program)
            pointer = operate!!(state, output, pointer, program[pointer+1], program[pointer+2])
            output == program[1:length(output)] || break
        end

        output == program && return search
    end
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

function get_full_output(searchA, program)
    pointer = 0
    output = Vector{Int}()
    state = RegisterState(searchA, 0, 0)
    while pointer < length(program)
        pointer = operate!!(state, output, pointer, program[pointer+1], program[pointer+2])
    end
    return output
end

# list of possible values for the k-to-last output
function possible_values(lower, upper, k, program)
    values = Vector{Int}()
    # assuming the possible values are roughly evenly spaced, 1000 should be enough to capture all of them
    for i in range(lower, upper, 1000) .|> floor .|> Int
        output = get_full_output(i, program)
        value = output[end-k+1]
        if length(values) == 0 || values[end] != value
            push!(values, value)
        end
    end
    return values
end

filename = "day17/input.txt"
# filename = "day17/test.txt"
# filename = "day17/test2.txt"
day17p2(filename)
