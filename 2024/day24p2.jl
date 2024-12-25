abstract type Unit end
struct Single <: Unit
    wire::String
end
struct Double <: Unit
    gate::String
    wires::Set{Unit}
end
Base.hash(u::Double, h::UInt) = hash(u.gate, hash(u.wires, hash(:Double, h)))
Base.isequal(u1::Double, u2::Double) = Base.isequal(hash(u1), hash(u2))

mutable struct Instruction
    w1::String
    gate::String
    w2::String
    w3::String
end
Instruction(s::SubString) = Instruction(match(r"(.*) (.*) (.*) -> (.*)", s).captures...)

function day24p2(filename)
    lines = join(readlines(filename), "\n")
    memory_in, instructions_in = split(lines, "\n\n")

    initial_memory = Dict{String,Unit}()
    initial_deps = Dict{String,Vector{String}}()
    for line in split(memory_in, "\n")
        wire = match(r"(.+): \d", line).captures[1]
        initial_memory[wire] = Single(wire)
        initial_deps[wire] = Vector{String}()
    end

    instructions = Vector{Instruction}()
    for line in split(instructions_in, "\n")
        push!(instructions, Instruction(line))
    end

    all_swaps = Vector{String}()
    for _ = 1:4
        memory, deps = parse_all_instructions(initial_memory, initial_deps, instructions)
        wire_maybe_wrong, first_wrong = check_correct_sum(memory, deps)
        for wi in intersect(wire_maybe_wrong, deps["z"*string(first_wrong, pad=2)]), wj in wire_maybe_wrong
            wi == wj && continue

            temp_instructions = deepcopy(instructions)
            swap_instructions!(temp_instructions, wi, wj)
            memory, deps = parse_all_instructions(initial_memory, initial_deps, temp_instructions)
            isnothing(memory) && continue

            _, ff = check_correct_sum(memory, deps)
            if ff > first_wrong
                push!(all_swaps, wi)
                push!(all_swaps, wj)
                swap_instructions!(instructions, wi, wj)
                break
            end
        end
    end

    join(sort(all_swaps), ",")
end

function parse_instruction!!(memory, deps, instruction)
    w1, w2, w3 = instruction.w1, instruction.w2, instruction.w3
    w1 in keys(memory) || return nothing
    w2 in keys(memory) || return nothing

    deps[w3] = vcat(deps[w1], deps[w2], [w3])
    !startswith(w1, "x") && !startswith(w1, "y") && push!(deps[w3], w1)
    !startswith(w2, "x") && !startswith(w2, "y") && push!(deps[w3], w2)
    return memory[w3] = Double(instruction.gate, Set([memory[w1], memory[w2]]))
end

function parse_all_instructions(memory, deps, instructions)
    new_memory, new_deps = copy(memory), copy(deps)
    new_instructions = deepcopy(instructions)
    it_count = 0
    while length(new_instructions) > 0
        line = popfirst!(new_instructions)
        isnothing(parse_instruction!!(new_memory, new_deps, line)) && push!(new_instructions, line)
        (it_count += 1) == 10000 && return nothing, nothing
    end
    return new_memory, new_deps
end

function check_correct_sum(memory, deps)
    wire_maybe_wrong = Vector{String}()
    for k in keys(memory)
        startswith(k, "x") && continue
        startswith(k, "y") && continue
        push!(wire_maybe_wrong, k)
    end

    i = 0
    name(c::String) = c * string(i, pad=2)
    carry = nothing
    while name("x") in keys(memory) || name("y") in keys(memory)
        # correct = x XOR y XOR carry
        correct = Double("XOR", Set([Single(name("x")), Single(name("y"))]))
        !isnothing(carry) && (correct = Double("XOR", Set([carry, correct])))

        # update carry
        # carry = (x AND y) OR ((x XOR y) AND carry)
        if isnothing(carry)
            carry = Double("AND", Set([Single(name("x")), Single(name("y"))]))
        else
            carry = Double("OR", Set([
                Double("AND", Set([
                    Double("XOR", Set([Single(name("x")), Single(name("y"))])),
                    carry
                ])),
                Double("AND", Set([Single(name("x")), Single(name("y"))]))
            ]))
        end

        isequal(memory[name("z")], correct) || return wire_maybe_wrong, i
        setdiff!(wire_maybe_wrong, deps[name("z")])
        i += 1
    end
    return wire_maybe_wrong, i
end

function swap_instructions!(instructions, wi, wj)
    for inst in instructions
        inst.w3 == wi && (inst.w3 = wj; continue)
        inst.w3 == wj && (inst.w3 = wi)
    end
end

filename = "day24/input.txt"
# filename = "day24/test.txt"
# filename = "day24/test2.txt"
day24p2(filename)
