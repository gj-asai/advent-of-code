filename = "day17/input.txt"
# filename = "day17/test.txt"
# filename = "day17/test2.txt"

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
Binit = B
Cinit = C

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

function get_full_output(searchA)
    global A, B, C
    A = searchA
    B = Binit
    C = Cinit
    output = Vector{Int}()

    pointer = 0
    while pointer < length(program)
        pointer = operate!(output, pointer, program[pointer+1], program[pointer+2])
    end
    return output
end

# find first A with correct length
target_length = length(program)
lower = 0
step = 100000000000000
while step > 0
    global lower, step
    test = lower + step
    testlen = length(get_full_output(test))
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
    global upper, step
    test = upper - step
    testlen = length(get_full_output(test))
    if testlen <= target_length
        step ÷= 2
    elseif testlen > target_length
        upper -= step
    end
end
upper -= 1

# list of possible values for the k-to-last output
function possible_values(lower, upper, k)
    values = Vector{Int}()
    # assuming the possible values are roughly evenly spaced, 1000 should be enough to capture all of them
    for i in range(lower, upper, 1000) .|> floor .|> Int
        output = get_full_output(i)
        value = output[end-k+1]
        if length(values) == 0 || values[end] != value
            push!(values, value)
        end
    end
    return values
end

for i = 1:length(program)
    global upper, lower
    possible = possible_values(lower, upper, i)
    println(possible)
    # possible for k=6 contains two 0s, using findfirst does not fnid the solution in the end
    target = findlast(possible .== program[end-i+1])

    local step = upper - lower
    possible1 = copy(possible)
    while step > 0
        test = lower + step
        local output = get_full_output(test)
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

    local step = upper - lower
    # not using the equivalent of possible1 ?
    while step > 0
        test = upper - step
        local output = get_full_output(test)
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

print(lower)
println(get_full_output(lower))
print(upper)
println(get_full_output(upper))

# bounds are close enough to check everything
output = Vector{Int}()
for search = lower:upper
    search % 100000 == 0 && (print(search); print(" "); println(upper))
    global A, B, C, output
    A = search
    B = Binit
    C = Cinit
    empty!(output)

    pointer = 0
    while pointer < length(program)
        pointer = operate!(output, pointer, program[pointer+1], program[pointer+2])
        output == program[1:length(output)] || break
    end

    output == program && (println(search); break)
end
