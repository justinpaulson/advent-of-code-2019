load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)

def ascii_code(input)
  input.split('').map(&:ord) + [10]
end

inputs_1 = [
  "NOT C J",
  "AND D J",
  "NOT A T",
  "OR T J",
  "WALK"
]

inputs_2 = [
  "NOT C J",
  "AND D J",
  "AND H J",
  "NOT A T",
  "AND D T",
  "OR T J",
  "NOT C T",
  "AND A T",
  "AND D T",
  "AND H T",
  "OR T J",
  "NOT B T",
  "AND D T",
  "AND H T",
  "OR T J",
  "RUN"
]

catcher = IntcodeCatcher.new
IntCode.new(code.clone, inputs_1, false, catcher).run
line = ""
while output = catcher.outputs.shift
  break if output > 300
  line += output.chr
end

puts line + "Part 1 Damage: " + output.to_s

IntCode.new(code.clone, inputs_2, false, catcher).run
line = ""
while output = catcher.outputs.shift
  break if output > 300
  line += output.chr
end

puts line + "Part 1 Damage: " + output.to_s
