filename = "day24/input.txt"
# filename = "day24/test.txt"
# filename = "day24/test2.txt"

memory = Dict{String,Bool}()
instructions = Vector{String}()
open(filename, "r") do f
    while !eof(f)
        line = readline(f)
        isempty(line) && break

        wire, state = match(r"(.+): (\d)", line).captures
        memory[wire] = parse(Bool, state)
    end

    while !eof(f)
        push!(instructions, readline(f))
    end
end

function parse_gate!(memory, line)
    wire1, gate, wire2, wire3 = match(r"(.*) (.*) (.*) -> (.*)", line).captures
    wire1 in keys(memory) || return nothing
    wire2 in keys(memory) || return nothing

    gate == "AND" && return memory[wire3] = memory[wire1] & memory[wire2]
    gate == "XOR" && return memory[wire3] = memory[wire1] ⊻ memory[wire2]
    gate == "OR" && return memory[wire3] = memory[wire1] | memory[wire2]
end

while length(instructions) > 0
    line = popfirst!(instructions)
    isnothing(parse_gate!(memory, line)) && push!(instructions, line)
end

z = 0
for (wire, state) in pairs(memory)
    startswith(wire, "z") || continue
    order = parse(Int, wire[2:end])
    global z += state * 2^order
end
z
