load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)

def ascii_code(input)
  input.split('').map(&:ord) + [10]
end

inputs = []
catcher = IntcodeCatcher.new
computer = IntCode.new(code.clone, inputs, false, catcher)

inputs = [
  "NOT A J",
  "NOT B T",
  "AND T J",
  "NOT C T",
  "AND D T",
  "OR T J",
  "NOT A T",
  "OR T J",
  # "NOT A J",
  # "AND D T",
  # "AND T J",
  # "NOT B T",
  # "AND D T",
  # "AND T J",
  # "NOT C T",
  # "AND T J",
  # "AND D J",
  "WALK"
]

inputs.each{|i| computer.add_input(ascii_code(i))}
computer.run

line = ""
while output = catcher.outputs.shift
  line += output.chr
end

puts line

puts "Answer is: #{}"

# 4



# A 1
# B 2
# C 3
# D 4

#   NOT A AND DNOT B  AND  D
