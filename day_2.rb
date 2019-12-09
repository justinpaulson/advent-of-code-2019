initial_intcode = File.read(ARGV[0]).split(?,).map(&:to_i)

def run_intcode(intcode)
  intcode.each_slice(4) do |opcode, pos_1, pos_2, target|
    case opcode
    when 1
      intcode[target] = intcode[pos_1] + intcode[pos_2]
    when 2
      intcode[target] = intcode[pos_1] * intcode[pos_2]
    when 99
      break
    else
      intcode[target] = intcode[target]
    end
  end
end

part_1_intcode = initial_intcode.clone
part_1_intcode[1] = 12
part_1_intcode[2] = 2

run_intcode(part_1_intcode)

puts "Part 1 Code: " + part_1_intcode.join(',')

noun = 0
verb = 0
part_2_intcode = []
while part_2_intcode[0] != 19690720
  part_2_intcode = initial_intcode.clone
  if verb == 99
    noun += 1
    verb = 0
  else
    verb += 1
  end
  part_2_intcode[1] = noun
  part_2_intcode[2] = verb
  run_intcode(part_2_intcode)
end

puts "Part 2 Code: " + part_2_intcode.join(',')
puts "Part 2 Noun: " + noun.to_s
puts "Part 2 Verb: " + verb.to_s
puts "100 * noun + verb = " + (100 * noun + verb).to_s
