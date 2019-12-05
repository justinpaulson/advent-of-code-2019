intcode = File.read(ARGV[0]).split(?,).map(&:to_i)
input = (ARGV[1] || 1).to_i

def run_intcode(intcode, input)
  cursor = 0
  while cursor < intcode.length - 1
    code = intcode[cursor]
    opcode = code.to_s.split('').last(2).join('').to_i
    modes = code.to_s.split('').reverse.drop(2)
    param_1 = modes[0] == '1' ? intcode[cursor + 1] : intcode[intcode[cursor + 1]] if cursor < intcode.length - 2
    param_2 = modes[1] == '1' ? intcode[cursor + 2] : intcode[intcode[cursor + 2]] if cursor < intcode.length - 3
    target = intcode[cursor + 3] if cursor < intcode.length - 4
    case opcode
    when 1
      intcode[target] = param_1 + param_2
      cursor += 4
    when 2
      intcode[target] = param_1 * param_2
      cursor += 4
    when 3
      intcode[intcode[cursor + 1]] = input
      cursor += 2
    when 4
      puts param_1
      cursor += 2
    when 5
      cursor = param_1 > 0 ? param_2 : cursor + 3
    when 6
      cursor = param_1 == 0 ? param_2 : cursor + 3
    when 7
      intcode[target] = param_1 < param_2 ? 1 : 0
      cursor += 4
    when 8
      intcode[target] = param_1 == param_2 ? 1 : 0
      cursor += 4
    when 99
      return
    end
  end
end

run_intcode(intcode, input)

